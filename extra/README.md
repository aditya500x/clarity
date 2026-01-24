# Genkit AI Engine - Integration Guide

This directory contains the standalone AI engine powered by Firebase Genkit.

## Prerequisites

- **API Key**: You must set `GOOGLE_GENAI_API_KEY` (or `GEMINI_API_KEY`) environment variable.

## how to Run

```bash
# Install dependencies
npm install

# Run the server
npx genkit start -- tsx index.ts
```

This will start:
- Genkit Developer UI: http://localhost:4000
- Flow API Server: http://localhost:3400 (default port)

## API Endpoints for FastAPI

FastAPI can call the AI functions via HTTP POST requests.

### Base URL
`http://localhost:3400`

### 1. Tasker AI
- **URL**: `/tasker_ai`
- **Method**: `POST`
- **Headers**: `Content-Type: application/json`
- **Body**:
  ```json
  {
    "data": "I need to clean my room and buy groceries."
  }
  ```
- **Response**:
  ```json
  {
    "result": {
      "task_title": "Clean room and groceries",
      "steps": ["..."]
    }
  }
  ```

### 2. Paragraph AI
- **URL**: `/paragraph_ai`
- **Method**: `POST`
- **Body**:
  ```json
  {
    "data": "Complex text here..."
  }
  ```
- **Response**:
  ```json
  {
    "result": {
      "adapted_text": "Simple text..."
    }
  }
  ```

### 3. Chatbot AI
- **URL**: `/chatbot_ai`
- **Method**: `POST`
- **Body**:
  ```json
  {
    "data": [
      { "sender": "user", "text": "Hello" },
      { "sender": "ai", "text": "Hi there" }
    ]
  }
  ```
- **Response**:
  ```json
  {
    "result": {
      "reply": "AI response..."
    }
  }
  ```
