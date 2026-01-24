import uuid
import asyncio
import httpx
import os
from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, Request
from pydantic import BaseModel
from fastapi.responses import HTMLResponse, FileResponse
from pathlib import Path
from sqlalchemy.orm import Session
from app.database import SessionLocal, ReaderSession, get_db

router = APIRouter()

# --- Configuration ---
GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent"
API_KEY = os.getenv("GEMINI_API_KEY", "")
# Directory to source reader-specific prompts
MODELS_DIR = os.path.join("models", "paragraph")

# --- Request Schemas ---
class ReaderInput(BaseModel):
    input_method: str  # paragraph | audio | image
    input_data: str

# --- Helper Logic ---
def load_custom_prompts():
    """Reads all .txt files from the models/paragraph directory and joins them."""
    custom_prompts = []
    if os.path.exists(MODELS_DIR) and os.path.isdir(MODELS_DIR):
        for filename in os.listdir(MODELS_DIR):
            if filename.endswith(".txt"):
                file_path = os.path.join(MODELS_DIR, filename)
                try:
                    with open(file_path, "r", encoding="utf-8") as f:
                        content = f.read().strip()
                        if content:
                            custom_prompts.append(content)
                except Exception as e:
                    print(f"Error reading prompt file {filename}: {e}")
    return "\n\n".join(custom_prompts)

# --- AI Logic ---
async def call_gemini_adapter(input_text: str):
    """
    Calls Gemini to adapt text for sensory-safe reading.
    Sources additional context from the models/paragraph directory.
    """
    base_instruction = (
        "You are a sensory-safe reading assistant. Your task is to adapt text to reduce cognitive load. "
        "Rules: "
        "1. Simplify complex language and long words. "
        "2. Use a gentle, calm, and professional tone. "
        "3. Use short sentences and simple grammar. "
        "4. Break dense text into short paragraphs or simple bullet points. "
        "5. Avoid jargon or overwhelming details. "
        "Return the adapted content in clean Markdown format."
    )

    custom_context = load_custom_prompts()
    full_system_instruction = base_instruction
    if custom_context:
        full_system_instruction += "\n\nADDITIONAL CONTEXT AND GUIDELINES:\n" + custom_context

    payload = {
        "contents": [{"parts": [{"text": input_text}]}],
        "systemInstruction": {"parts": [{"text": full_system_instruction}]}
    }

    async with httpx.AsyncClient() as client:
        for attempt in range(5):
            try:
                response = await client.post(
                    f"{GEMINI_API_URL}?key={API_KEY}",
                    json=payload,
                    timeout=30.0
                )
                if response.status_code == 200:
                    result = response.json()
                    return result.get("candidates", [{}])[0].get("content", {}).get("parts", [{}])[0].get("text", "I'm sorry, I couldn't adapt the text.")
                
                if response.status_code in [429, 500, 503]:
                    await asyncio.sleep(2 ** attempt)
                    continue
                break
            except Exception as e:
                print(f"Gemini API Error (Paragraph): {e}")
                await asyncio.sleep(2 ** attempt)

    return "The text could not be adapted at this time. Here is the original text:\n\n" + input_text

# --- Routes ---

@router.get("/paragraph/{session_id}", response_class=HTMLResponse)
async def get_paragraph_page(session_id: str):
    """Serves the frontend reader page."""
    return FileResponse("temp/paragraph.html")

@router.post("/api/paragraph/start")
async def start_paragraph_adaptation(data: ReaderInput, db: Session = Depends(get_db)):
    """
    Called by input.html. Triggers AI adaptation, saves to DB, and returns the session_id.
    """
    # 1. AI Adaptation
    adapted_content = await call_gemini_adapter(data.input_data)
    
    # 2. Generate Session
    session_id = str(uuid.uuid4())
    
    # 3. Store in DB (reader_sessions table)
    new_session = ReaderSession(
        session_id=session_id,
        input_method=data.input_method,
        input_text=data.input_data,
        output_text=adapted_content,
        created_at=datetime.utcnow()
    )
    db.add(new_session)
    db.commit()

    return {"session_id": session_id}

@router.get("/api/paragraph/details/{session_id}")
async def get_paragraph_details(session_id: str, db: Session = Depends(get_db)):
    """Used by paragraph.html to fetch the adapted text."""
    session = db.query(ReaderSession).filter(ReaderSession.session_id == session_id).first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    
    return {"output_text": session.output_text}

@router.post("/api/paragraph/done/{session_id}")
async def paragraph_done(session_id: str, db: Session = Depends(get_db)):
    """Acknowledge completion of reading."""
    return {"status": "ok"}
