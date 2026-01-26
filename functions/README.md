# Clarity Firebase Functions

Firebase Cloud Functions with Genkit for the Clarity AI engine.

## Overview

This is the AI backend for Clarity, an ADHD-focused accessibility application. It exposes HTTP endpoints that FastAPI calls to get AI-powered responses.

**Key Points:**
- ✅ Firebase handles ONLY AI logic
- ✅ FastAPI handles database, sessions, and business logic
- ✅ This codebase exposes HTTP endpoints, nothing more

## Tech Stack

- **Runtime**: Node.js 18
- **Language**: TypeScript
- **Framework**: Firebase Cloud Functions
- **AI**: Genkit + Gemini (via @genkit-ai/googleai)

## Architecture

### Core Principles

1. **Single Genkit Instance**: Initialized once in `src/genkit/genkit.ts`
2. **Prompt-Driven**: All AI modules load prompts from `prompts/` directory
3. **Clean Separation**: Flows contain AI logic, HTTP handlers contain request logic
4. **Schema Validation**: All inputs and outputs validated with Zod

### Directory Structure

```
functions/
├── src/
│   ├── index.ts              # Firebase function exports ONLY
│   ├── genkit/
│   │   ├── genkit.ts         # Genkit initialization (SINGLETON)
│   │   └── models.ts         # Model configurations
│   ├── flows/
│   │   ├── tasker.flow.ts    # Task breakdown AI logic
│   │   ├── paragraph.flow.ts # Text rewriting AI logic (TODO)
│   │   └── chatbot.flow.ts   # Conversation AI logic (TODO)
│   ├── http/
│   │   ├── tasker.ts         # HTTP handler for tasker
│   │   ├── paragraph.ts      # HTTP handler for paragraph (TODO)
│   │   └── chatbot.ts        # HTTP handler for chatbot (TODO)
│   ├── schemas/
│   │   ├── tasker.schema.ts  # Zod schemas for tasker
│   │   ├── paragraph.schema.ts (TODO)
│   │   └── chatbot.schema.ts (TODO)
│   ├── utils/
│   │   ├── prompt_helpers.ts # Prompt loading utilities
│   │   └── safety_helpers.ts # AI safety utilities
│   └── config/
│       ├── env.ts            # Environment configuration
│       └── constants.ts      # Application constants
├── prompts/
│   ├── tasker/               # Task breakdown prompts
│   │   ├── 01_system.txt
│   │   └── 02_context.txt
│   ├── paragraph/            # Text rewriting prompts (TODO)
│   └── chatbot/              # Chatbot prompts (TODO)
├── package.json
└── tsconfig.json
```

## AI Modules

### 1. Tasker AI ✅ IMPLEMENTED

**Endpoint**: `POST /tasker_ai`

**Purpose**: Break down large tasks into small, actionable steps for ADHD users.

**Request**:
```json
{
  "userInput": "Write a research paper on climate change",
  "sessionId": "abc-123"
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "taskTitle": "Write Research Paper on Climate Change",
    "steps": [
      {
        "stepNumber": 1,
        "description": "Choose a specific aspect of climate change to focus on",
        "completed": false
      },
      {
        "stepNumber": 2,
        "description": "Research and gather 5 credible sources",
        "completed": false
      }
    ],
    "estimatedDuration": "2-3 hours",
    "difficulty": "medium"
  },
  "sessionId": "abc-123"
}
```

### 2. Paragraph AI 🚧 TODO

**Endpoint**: `POST /paragraph_ai`

**Purpose**: Rewrite text into a calm, sensory-safe, easy-to-read format.

### 3. Chatbot AI 🚧 TODO

**Endpoint**: `POST /chatbot_ai`

**Purpose**: Conversational assistant with session-based memory.

## Setup

### Prerequisites

- Node.js 18+
- Firebase CLI: `npm install -g firebase-tools`
- Google AI API key (for Gemini)

### Installation

```bash
cd functions
npm install
```

### Environment Variables

Create a `.env` file in the `functions/` directory:

```env
GOOGLE_API_KEY=your_gemini_api_key_here
NODE_ENV=development
ALLOWED_ORIGINS=http://localhost:8000,http://localhost:3000
```

### Build

```bash
npm run build
```

### Local Development

```bash
npm run serve
```

This starts the Firebase emulator. Functions will be available at:
- `http://localhost:5001/your-project-id/us-central1/tasker_ai`

### Deploy

```bash
npm run deploy
```

## How FastAPI Calls These Functions

Once deployed, FastAPI makes HTTP POST requests to the function URLs:

```python
import requests

response = requests.post(
    'https://us-central1-your-project.cloudfunctions.net/tasker_ai',
    json={
        'userInput': 'Clean my room',
        'sessionId': session_id
    }
)

result = response.json()
```

## Prompt Management

### How Prompts Work

1. Each AI module has a directory in `prompts/`
2. All `.txt` files in that directory are loaded and concatenated
3. Files are sorted alphabetically (use numeric prefixes like `01_`, `02_`)
4. Prompts are loaded once at cold start for performance

### Adding/Updating Prompts

1. Add or edit `.txt` files in the appropriate directory
2. Redeploy the function
3. Changes take effect on next cold start

### Best Practices

- Use numbered prefixes for ordering: `01_system.txt`, `02_context.txt`
- Keep prompts focused and modular
- Test prompt changes locally before deploying
- Document prompt purpose in comments

## Error Handling

All endpoints return consistent error responses:

```json
{
  "success": false,
  "error": "Error message here",
  "sessionId": "abc-123"
}
```

HTTP status codes:
- `200`: Success
- `400`: Invalid request (validation failed)
- `405`: Method not allowed
- `500`: Internal server error (AI failure, etc.)

## Development Workflow

### Adding a New AI Module

1. Create schema in `src/schemas/[module].schema.ts`
2. Create flow in `src/flows/[module].flow.ts`
3. Create HTTP handler in `src/http/[module].ts`
4. Export function in `src/index.ts`
5. Add prompts in `prompts/[module]/`
6. Test locally with emulator
7. Deploy

### Testing

Use curl or Postman to test endpoints:

```bash
curl -X POST http://localhost:5001/your-project/us-central1/tasker_ai \
  -H "Content-Type: application/json" \
  -d '{
    "userInput": "Learn TypeScript",
    "sessionId": "test-123"
  }'
```

## Next Steps

1. ✅ Implement `paragraph_ai` (schema → flow → http → export)
2. ✅ Implement `chatbot_ai` (schema → flow → http → export)
3. ✅ Add comprehensive error handling
4. ✅ Add logging for debugging
5. ✅ Test all three endpoints
6. ✅ Deploy to Firebase

## Notes

- This is a hackathon/demo project - keep it simple
- No overengineering
- FastAPI owns all state and database logic
- This codebase is ONLY for AI orchestration
- Genkit is initialized ONCE and reused everywhere

---

Built with care for the Clarity project 💙
