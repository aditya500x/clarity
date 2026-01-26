# Clarity Firebase + Genkit Quick Start

## What I Built

I've implemented the Firebase Cloud Functions backend with Genkit for the Clarity AI engine. Here's what's complete:

### ✅ Complete Implementation

1. **Core Infrastructure**
   - `genkit/genkit.ts` - Single Genkit instance (initialized once)
   - `genkit/models.ts` - Model configurations
   - `utils/prompt_helpers.ts` - Prompt loading from disk
   - `utils/safety_helpers.ts` - AI safety settings
   - `config/env.ts` - Environment configuration
   - `config/constants.ts` - Application constants

2. **Tasker AI (Complete Vertical Slice)**
   - `schemas/tasker.schema.ts` - Zod validation schemas
   - `flows/tasker.flow.ts` - AI logic for task breakdown
   - `http/tasker.ts` - HTTP request handler
   - `index.ts` - Firebase function export
   - `prompts/tasker/` - ADHD-focused prompts

### 🚧 Ready for Implementation

The structure is ready for:
- `paragraph_ai` - Text rewriting module
- `chatbot_ai` - Conversational assistant module

## How It Works

### Architecture Flow

```
FastAPI → HTTP POST → Firebase Function → HTTP Handler → Flow → Genkit → Gemini → Response
```

### Example: Tasker AI

1. **FastAPI sends request**:
   ```python
   requests.post('/tasker_ai', json={
       'userInput': 'Clean my room',
       'sessionId': 'abc-123'
   })
   ```

2. **HTTP handler validates** (`http/tasker.ts`):
   - Checks request method
   - Validates input with Zod schema
   - Calls the flow

3. **Flow executes AI logic** (`flows/tasker.flow.ts`):
   - Loads prompts from `prompts/tasker/`
   - Constructs full prompt
   - Calls Gemini via Genkit
   - Parses JSON response
   - Validates output

4. **Response returned**:
   ```json
   {
     "success": true,
     "data": {
       "taskTitle": "Clean Your Room",
       "steps": [
         {"stepNumber": 1, "description": "Pick up clothes from floor", "completed": false},
         {"stepNumber": 2, "description": "Make the bed", "completed": false}
       ],
       "estimatedDuration": "30 minutes",
       "difficulty": "easy"
     },
     "sessionId": "abc-123"
   }
   ```

## File Explanations

### Core Files

**`src/genkit/genkit.ts`**
- Initializes Genkit ONCE when the module loads
- Configures Google AI plugin with API key
- Exports singleton `ai` instance used by all flows
- This is the SINGLE SOURCE OF TRUTH for Genkit

**`src/utils/prompt_helpers.ts`**
- `loadPrompts(dir)` - Reads all `.txt` files from a directory
- Sorts files alphabetically (use `01_`, `02_` prefixes)
- Concatenates prompts with double newlines
- Called at module initialization for performance

**`src/flows/tasker.flow.ts`**
- Pure AI orchestration logic
- NO HTTP concerns
- Loads prompts → calls Gemini → parses JSON → validates
- Uses `ai.defineFlow()` from Genkit
- Returns structured data

**`src/http/tasker.ts`**
- Pure HTTP handling logic
- NO AI concerns
- Validates request → calls flow → returns response
- Handles errors and status codes

**`src/index.ts`**
- ONLY exports Firebase functions
- NO business logic
- NO AI logic
- Just function definitions with configuration

### Schema Files

**`src/schemas/tasker.schema.ts`**
- Zod schemas for type safety
- Input validation (what FastAPI sends)
- Output validation (what AI returns)
- Response structure (what FastAPI receives)

### Configuration Files

**`src/config/env.ts`**
- Loads environment variables
- Validates required API keys
- Exports configuration object

**`src/config/constants.ts`**
- Model settings (temperature, tokens)
- Prompt directory paths
- Application-wide constants

## Setup Instructions

### 1. Install Dependencies

```bash
cd functions
npm install
```

### 2. Configure Environment

```bash
cp .env.example .env
```

Edit `.env` and add your Google AI API key:
```env
GOOGLE_API_KEY=your_actual_api_key_here
```

Get your API key from: https://makersuite.google.com/app/apikey

### 3. Build TypeScript

```bash
npm run build
```

This compiles TypeScript to JavaScript in the `lib/` directory.

### 4. Run Locally (Optional)

```bash
# Install Firebase CLI if you haven't
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase (if not already done)
firebase init functions

# Start emulator
npm run serve
```

Functions will be available at:
```
http://localhost:5001/YOUR-PROJECT-ID/us-central1/tasker_ai
```

### 5. Deploy to Firebase

```bash
npm run deploy
```

After deployment, you'll get URLs like:
```
https://us-central1-YOUR-PROJECT.cloudfunctions.net/tasker_ai
```

## Testing

### Test with curl

```bash
curl -X POST http://localhost:5001/YOUR-PROJECT/us-central1/tasker_ai \
  -H "Content-Type: application/json" \
  -d '{
    "userInput": "Write a blog post about TypeScript",
    "sessionId": "test-123"
  }'
```

### Test from FastAPI

```python
import requests

response = requests.post(
    'https://us-central1-YOUR-PROJECT.cloudfunctions.net/tasker_ai',
    json={
        'userInput': 'Organize my desk',
        'sessionId': session_id
    }
)

if response.json()['success']:
    task_data = response.json()['data']
    # Save to database, return to frontend, etc.
```

## Next Steps

### Implement Paragraph AI

1. Create `src/schemas/paragraph.schema.ts`
2. Create `src/flows/paragraph.flow.ts`
3. Create `src/http/paragraph.ts`
4. Add export in `src/index.ts`
5. Add prompts in `prompts/paragraph/`

### Implement Chatbot AI

1. Create `src/schemas/chatbot.schema.ts`
2. Create `src/flows/chatbot.flow.ts`
3. Create `src/http/chatbot.ts`
4. Add export in `src/index.ts`
5. Add prompts in `prompts/chatbot/`

## Key Design Decisions

### Why Genkit?

- Built for Firebase integration
- Handles prompt management
- Provides flow abstraction
- Simplifies AI orchestration

### Why Load Prompts from Disk?

- Easy to update without code changes
- Version control for prompts
- Modular prompt organization
- Non-technical team members can edit

### Why Separate Flows and HTTP Handlers?

- Clean separation of concerns
- Flows are testable without HTTP
- HTTP handlers are testable without AI
- Easy to add new endpoints

### Why Zod Schemas?

- Runtime validation
- Type safety
- Clear error messages
- Self-documenting API

## Troubleshooting

### "GOOGLE_API_KEY environment variable is required"

- Make sure `.env` file exists in `functions/` directory
- Check that `GOOGLE_API_KEY` is set correctly
- Restart the emulator after changing `.env`

### "Prompt directory not found"

- Check that prompt directories exist
- Verify path in `CONSTANTS.PROMPT_DIRS`
- Ensure `.txt` files exist in the directory

### "AI response was not valid JSON"

- Check your prompts - make sure they instruct JSON output
- Verify the AI is returning properly formatted JSON
- Check logs for the raw AI response

### TypeScript Compilation Errors

```bash
# Clean build
rm -rf lib/
npm run build
```

## Project Structure Summary

```
functions/
├── src/                    # TypeScript source code
│   ├── index.ts           # Function exports ONLY
│   ├── genkit/            # Genkit initialization
│   ├── flows/             # AI logic (pure)
│   ├── http/              # HTTP handlers (pure)
│   ├── schemas/           # Zod validation
│   ├── utils/             # Helper functions
│   └── config/            # Configuration
├── prompts/               # AI prompts (.txt files)
│   ├── tasker/
│   ├── paragraph/
│   └── chatbot/
├── lib/                   # Compiled JavaScript (gitignored)
├── package.json
├── tsconfig.json
└── .env                   # Environment variables (gitignored)
```

## Important Reminders

1. **Genkit is initialized ONCE** in `genkit/genkit.ts`
2. **Prompts are loaded ONCE** at cold start
3. **Flows contain ONLY AI logic** - no HTTP
4. **HTTP handlers contain ONLY request logic** - no AI
5. **index.ts contains ONLY exports** - no logic
6. **FastAPI owns all state** - Firebase just does AI

---

Built for Clarity with care 💙
