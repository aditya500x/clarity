# 🚀 Clarity Firebase Functions - Quick Reference

## 📦 What's Been Built

✅ **Complete Firebase + Genkit backend** for Clarity AI engine  
✅ **572 lines** of TypeScript across **17 files**  
✅ **Full vertical slice** for tasker_ai  
✅ **Ready-to-use patterns** for paragraph_ai and chatbot_ai  

---

## 📁 Directory Structure

```
functions/
├── src/
│   ├── index.ts              # Exports Firebase functions
│   ├── genkit/               # Genkit singleton + models
│   ├── flows/                # AI logic (tasker.flow.ts ✅)
│   ├── http/                 # HTTP handlers (tasker.ts ✅)
│   ├── schemas/              # Zod validation (tasker.schema.ts ✅)
│   ├── utils/                # Helpers (prompts + safety)
│   └── config/               # Environment + constants
├── prompts/
│   ├── tasker/               # ✅ ADHD-focused prompts
│   ├── paragraph/            # 🚧 TODO
│   └── chatbot/              # 🚧 TODO
└── [docs + config files]
```

---

## 🎯 Quick Start

```bash
# 1. Install
cd functions
npm install

# 2. Configure
cp .env.example .env
# Edit .env and add GOOGLE_API_KEY

# 3. Build
npm run build

# 4. Deploy
npm run deploy
```

---

## 🔌 API Endpoint

### Tasker AI ✅

**Endpoint**: `POST /tasker_ai`

**Request**:
```json
{
  "userInput": "Clean my room",
  "sessionId": "abc-123"
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "taskTitle": "Clean Your Room",
    "steps": [
      {"stepNumber": 1, "description": "Pick up clothes", "completed": false},
      {"stepNumber": 2, "description": "Make the bed", "completed": false}
    ],
    "estimatedDuration": "30 minutes",
    "difficulty": "easy"
  },
  "sessionId": "abc-123"
}
```

---

## 🏗️ Architecture Pattern

```
HTTP Handler → Flow → Genkit → Gemini
     ↓           ↓       ↓
  Validate   AI Logic  Model
  Request    Prompts   Config
  Response   Parsing   Safety
```

---

## 📝 Implementation Pattern (Copy for New Modules)

### 1. Schema (`schemas/[module].schema.ts`)
```typescript
export const [Module]InputSchema = z.object({...});
export const [Module]OutputSchema = z.object({...});
```

### 2. Flow (`flows/[module].flow.ts`)
```typescript
export const [module]Flow = ai.defineFlow({
  name: '[module]Flow',
  inputSchema: [Module]InputSchema,
  outputSchema: [Module]OutputSchema,
}, async (input) => {
  // Load prompts, call AI, return data
});
```

### 3. HTTP Handler (`http/[module].ts`)
```typescript
export async function handle[Module]Request(req, res) {
  // Validate, call flow, return response
}
```

### 4. Export (`index.ts`)
```typescript
export const [module]_ai = onRequest(
  { cors: true },
  handle[Module]Request
);
```

### 5. Prompts (`prompts/[module]/`)
```
01_system.txt    # System instructions
02_context.txt   # Additional context
```

---

## 🎯 Next Steps

### Paragraph AI
- [ ] Copy tasker pattern
- [ ] Create schema, flow, HTTP handler
- [ ] Add prompts for text rewriting
- [ ] Export function

### Chatbot AI
- [ ] Copy tasker pattern
- [ ] Create schema, flow, HTTP handler
- [ ] Add prompts for conversation
- [ ] Handle chat history
- [ ] Export function

---

## 📚 Documentation

| File | Purpose |
|------|---------|
| [`README.md`](file:///home/aditya/Projects/gdg/namma-hack/clarity/functions/README.md) | Technical documentation |
| [`QUICKSTART.md`](file:///home/aditya/Projects/gdg/namma-hack/clarity/functions/QUICKSTART.md) | Setup guide |
| [`SUMMARY.md`](file:///home/aditya/Projects/gdg/namma-hack/clarity/functions/SUMMARY.md) | Implementation overview |

---

## 🔧 Key Files

| File | Lines | Purpose |
|------|-------|---------|
| [`genkit/genkit.ts`](file:///home/aditya/Projects/gdg/namma-hack/clarity/functions/src/genkit/genkit.ts) | 30 | Genkit singleton |
| [`utils/prompt_helpers.ts`](file:///home/aditya/Projects/gdg/namma-hack/clarity/functions/src/utils/prompt_helpers.ts) | 83 | Prompt loading |
| [`flows/tasker.flow.ts`](file:///home/aditya/Projects/gdg/namma-hack/clarity/functions/src/flows/tasker.flow.ts) | 110 | Task breakdown AI |
| [`http/tasker.ts`](file:///home/aditya/Projects/gdg/namma-hack/clarity/functions/src/http/tasker.ts) | 88 | HTTP handler |
| [`schemas/tasker.schema.ts`](file:///home/aditya/Projects/gdg/namma-hack/clarity/functions/src/schemas/tasker.schema.ts) | 62 | Zod validation |

---

## ✅ Design Principles

✅ Single Genkit instance (initialized once)  
✅ Prompts loaded from disk  
✅ Clean separation (flows = AI, HTTP = requests)  
✅ Schema validation (Zod)  
✅ No overengineering  

---

## 🎉 Status

**Core**: ✅ Complete  
**Tasker AI**: ✅ Complete  
**Paragraph AI**: 🚧 TODO  
**Chatbot AI**: 🚧 TODO  

Built with care for Clarity 💙
