from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from datetime import datetime
import httpx
from typing import List
from sqlalchemy.orm import Session
from app.database import ChatSession, ChatMessage, get_db

from fastapi.responses import HTMLResponse
from pathlib import Path

router = APIRouter()

# Firebase AI Engine Configuration (API Server runs on 3400, UI on 4000)
FIREBASE_AI_URL = "http://localhost:4000/chatbot_ai"

@router.get("/chat/{session_id}", response_class=HTMLResponse)
async def get_chat_page(session_id: str, db: Session = Depends(get_db)):
    # Ensure session exists in DB
    existing_session = db.query(ChatSession).filter(ChatSession.id == session_id).first()
    if not existing_session:
        new_session = ChatSession(id=session_id, module="chatbot", status="active")
        db.add(new_session)
        db.commit()
    return HTMLResponse(content=Path("temp/chat.html").read_text())

# --- Request/Response Models ---

class ChatStartRequest(BaseModel):
    module: str = "chatbot"

class MessageRequest(BaseModel):
    session_id: str
    message_text: str

class ChatMessageResponse(BaseModel):
    id: int
    sender: str
    message_text: str
    created_at: datetime

class ChatSessionResponse(BaseModel):
    session_id: str
    status: str
    messages: List[ChatMessageResponse]

# --- API Endpoints ---

@router.post("/api/chatbot/session", response_model=ChatSessionResponse)
async def create_chat_session(request: ChatStartRequest, db: Session = Depends(get_db)):
    """
    Step 1: Create a new chat session.
    """
    import uuid
    session_id = str(uuid.uuid4())
    
    new_session = ChatSession(id=session_id, module=request.module, status="active")
    db.add(new_session)
    db.commit()
    
    return {
        "session_id": session_id,
        "status": "active",
        "messages": []
    }

@router.get("/api/chatbot/session/{session_id}", response_model=ChatSessionResponse)
async def get_chat_session(session_id: str, db: Session = Depends(get_db)):
    """
    Step 2: Retrieve an existing chat session with messages.
    """
    session = db.query(ChatSession).filter(ChatSession.id == session_id).first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    
    return {
        "session_id": session.id,
        "status": session.status,
        "messages": [
            {
                "id": m.id,
                "sender": m.sender,
                "message_text": m.message_text,
                "created_at": m.created_at
            }
            for m in session.messages
        ]
    }

@router.post("/api/chatbot/message")
async def send_message(data: MessageRequest, db: Session = Depends(get_db)):
    """
    Flow: 
    1. Store user message
    2. Get AI reply from Firebase Genkit
    3. Store AI message
    4. Return AI response
    """
    session_id = data.session_id
    user_text = data.message_text

    # 1. Store User Message in DB
    user_msg = ChatMessage(session_id=session_id, sender="user", message_text=user_text)
    db.add(user_msg)
    db.commit()

    # 2. Fetch chat history for AI context
    messages = db.query(ChatMessage).filter(
        ChatMessage.session_id == session_id
    ).order_by(ChatMessage.created_at).all()
    
    # Format for AI engine
    history = [
        {
            "sender": msg.sender,
            "text": msg.message_text
        }
        for msg in messages
    ]

    # 3. Generate AI Reply (Firebase Genkit)
    ai_reply_text = await call_firebase_ai(history)

    # 4. Store AI Message in DB
    ai_msg = ChatMessage(session_id=session_id, sender="ai", message_text=ai_reply_text)
    db.add(ai_msg)
    
    db.commit()

    return {
        "session_id": session_id,
        "sender": "ai",
        "message_text": ai_reply_text,
        "created_at": datetime.now()
    }

@router.post("/api/chatbot/end")
async def end_chat_session(session_id: str, db: Session = Depends(get_db)):
    """
    Mark a session as ended and record the timestamp.
    """
    session = db.query(ChatSession).filter(ChatSession.id == session_id).first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    
    session.status = "ended"
    session.ended_at = datetime.utcnow()
    db.commit()
    
    return {"status": "success", "session_id": session_id, "message": "Session ended"}

# --- AI Integration Helper ---

async def call_firebase_ai(history: List[dict]) -> str:
    """
    Call Firebase Genkit AI engine with chat history.
    Returns AI reply text.
    Implements fallback if AI is unavailable.
    """
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            response = await client.post(
                FIREBASE_AI_URL,
                json={"data": history}
            )
            
            if response.status_code == 200:
                result = response.json()
                # Genkit returns: {"result": {"reply": "..."}}
                return result.get("result", {}).get("reply", get_fallback_message())
            else:
                return get_fallback_message()
                
    except Exception as e:
        print(f"AI Engine Error: {e}")
        return get_fallback_message()


def get_fallback_message() -> str:
    """
    Safe fallback message when AI engine fails
    """
    return "I'm here with you. Can you tell me a bit more about what's going on?"
