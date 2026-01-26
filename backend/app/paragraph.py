import uuid
import json
import httpx
import os
import asyncio
from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from fastapi.responses import JSONResponse
from pathlib import Path
from sqlalchemy.orm import Session
from app.database import SessionLocal, ReaderSession, get_db

router = APIRouter()

# --- Configuration ---
GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
API_KEY = os.getenv("GEMINI_API_KEY", "")
# Directory to source paragraph-specific prompts
PROMPTS_DIR = os.path.join("prompts", "paragraph")
COMMON_PROMPTS_FILE = os.path.join("prompts", "common.txt")

# --- Helper Logic ---
def load_custom_prompts():
    """Reads prompts/common.txt and all .txt files from prompts/paragraph directory."""
    custom_prompts = []
    
    # Load common prompts first
    if os.path.exists(COMMON_PROMPTS_FILE):
        try:
            with open(COMMON_PROMPTS_FILE, "r", encoding="utf-8") as f:
                content = f.read().strip()
                if content:
                    custom_prompts.append(content)
        except Exception as e:
            print(f"Error reading common prompts file: {e}")
    
    # Load module-specific prompts
    if os.path.exists(PROMPTS_DIR) and os.path.isdir(PROMPTS_DIR):
        for filename in os.listdir(PROMPTS_DIR):
            if filename.endswith(".txt"):
                file_path = os.path.join(PROMPTS_DIR, filename)
                try:
                    with open(file_path, "r", encoding="utf-8") as f:
                        content = f.read().strip()
                        if content:
                            custom_prompts.append(content)
                except Exception as e:
                    print(f"Error reading prompt file {filename}: {e}")
    return "\n\n".join(custom_prompts)

# --- Request Schemas ---
class ReaderInput(BaseModel):
    input_method: str  # paragraph | audio | image
    input_data: str

# --- AI Logic ---
async def call_gemini_explainer(input_text: str):
    """
    Calls Gemini to explain a topic in a sensory-friendly, simplified way.
    Returns a clear explanation with structured points.
    Sources additional context from the prompts/paragraph directory.
    """
    base_instruction = (
        "You are a sensory-safe reading assistant. Your goal is to explain topics in a clear, "
        "calm, and easy-to-understand way for people who may feel overwhelmed by complex text. "
        "Break down the topic into simple, digestible points. Use short sentences and bullet points. "
        "Avoid jargon and complex vocabulary. Return ONLY a strict JSON object with 'title' (string - a short title for the topic) "
        "and 'explanation' (string - the simplified explanation with line breaks and bullet points using • symbol). "
        "Make the explanation feel calm and supportive."
    )
    
    # Dynamic prompt sourcing
    custom_context = load_custom_prompts()
    full_system_instruction = base_instruction
    if custom_context:
        full_system_instruction += "\n\nADDITIONAL CONTEXT AND GUIDELINES:\n" + custom_context
    
    payload = {
        "contents": [{"parts": [{"text": f"Please explain this topic in a simple, sensory-friendly way:\n\n{input_text}"}]}],
        "systemInstruction": {"parts": [{"text": full_system_instruction}]},
        "generationConfig": {
            "responseMimeType": "application/json",
            "responseSchema": {
                "type": "OBJECT",
                "properties": {
                    "title": {"type": "STRING"},
                    "explanation": {"type": "STRING"}
                },
                "required": ["title", "explanation"]
            }
        }
    }

    async with httpx.AsyncClient() as client:
        for attempt in range(5):
            try:
                response = await client.post(
                    f"{GEMINI_API_URL}?key={API_KEY}",
                    json=payload,
                    timeout=20.0
                )
                if response.status_code == 200:
                    result = response.json()
                    content = result.get("candidates", [{}])[0].get("content", {}).get("parts", [{}])[0].get("text", "")
                    return json.loads(content)
                
                if response.status_code in [429, 500, 503]:
                    await asyncio.sleep(2 ** attempt)
                    continue
                break
            except Exception as e:
                print(f"Gemini API Error: {e}")
                await asyncio.sleep(2 ** attempt)

    # Fallback if AI fails completely
    return {
        "title": "Topic Explanation",
        "explanation": "• We couldn't process your request right now.\n\n• Please try again in a moment.\n\n• The text you provided was: " + input_text[:100]
    }

# --- Routes ---

# Legacy HTML route removed - Flutter is the frontend

@router.post("/api/reader/input")
async def process_reader_input(data: ReaderInput, db: Session = Depends(get_db)):
    """
    Called by input.html when module=paragraph. 
    Triggers AI to explain the topic, saves to DB, and returns session_id.
    """
    # 1. AI Content Generation
    ai_output = await call_gemini_explainer(data.input_data)
    
    # 2. Generate Session ID
    session_id = str(uuid.uuid4())
    
    # 3. Format output text with title
    output_text = f"# {ai_output.get('title', 'Topic Explanation')}\n\n{ai_output.get('explanation', '')}"
    
    # 4. Store in DB
    new_session = ReaderSession(
        session_id=session_id,
        input_method=data.input_method,
        input_text=data.input_data,
        output_text=output_text
    )
    db.add(new_session)
    db.commit()

    return {
        "session_id": session_id,
        "input_method": data.input_method,
        "title": ai_output.get("title", "Topic Explanation"),
        "output_text": ai_output.get("explanation", "")
    }

@router.get("/api/reader/details/{session_id}")
async def get_reader_details(session_id: str, db: Session = Depends(get_db)):
    """Used by paragraph.html to fetch and render the saved content."""
    session = db.query(ReaderSession).filter(ReaderSession.session_id == session_id).first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    
    return {
        "session_id": session.session_id,
        "input_text": session.input_text,
        "output_text": session.output_text
    }

@router.post("/api/paragraph/done/{session_id}")
async def paragraph_done(session_id: str, db: Session = Depends(get_db)):
    """Mark the reading session as complete."""
    session = db.query(ReaderSession).filter(ReaderSession.session_id == session_id).first()
    if not session:
        return {"status": "error", "message": "Session not found"}
    return {"status": "ok"}
