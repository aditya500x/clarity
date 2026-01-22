from fastapi import APIRouter
from pydantic import BaseModel
import uuid

from fastapi.responses import HTMLResponse
from pathlib import Path

router = APIRouter()

@router.get("/paragraph/{session_id}", response_class=HTMLResponse)
async def get_paragraph_page(session_id: str):
    return HTMLResponse(content=Path("temp/paragraph.html").read_text())

class ReaderInput(BaseModel):
    input_method: str
    input_data: str

@router.post("/api/reader/input")
async def process_reader_input(data: ReaderInput):
    session_id = str(uuid.uuid4())
    
    # Mock AI Logic for text adaptation
    # In production, this adapts formatting and vocabulary
    adapted_text = f"Simplified version of your {data.input_method} input:\n\n"
    adapted_text += data.input_data.replace(". ", ".\n\n• ")
    
    # Store in DB
    # save_reader_session(session_id, data.input_method, data.input_data, adapted_text)

    return {
        "session_id": session_id,
        "input_method": data.input_method,
        "output_text": adapted_text
    }
