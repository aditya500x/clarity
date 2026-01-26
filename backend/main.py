"""
Clarity Backend - FastAPI REST API Server

This is a pure API server for the Flutter frontend.
All responses are JSON. No HTML rendering.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

# Load environment variables BEFORE importing app modules
load_dotenv()

from app import tasker, paragraph, chatbot, settings
from app.database import init_db

# Initialize database
init_db()

app = FastAPI(
    title="Clarity API",
    description="REST API for Clarity Flutter app",
    version="1.0.0"
)

# CORS middleware for Flutter Web & Android
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Development: allow all origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount API Routers
app.include_router(tasker.router)
app.include_router(paragraph.router)
app.include_router(chatbot.router)
app.include_router(settings.router)


@app.get("/")
async def root():
    """Health check endpoint."""
    return {"status": "ok", "message": "Clarity API is running"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5050)

