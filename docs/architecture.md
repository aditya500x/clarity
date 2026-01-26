# 🏛️ System Architecture

Clarity uses a **modular, backend-first architecture** designed to keep the system simple, maintainable, and replaceable.

The architecture intentionally separates:
- **UI concerns**
- **application logic**
- **AI reasoning**
- **data persistence**

This separation ensures that no single layer becomes overly complex or tightly coupled to another.

---

## 🧱 Tech Stack Overview

### 🐍 Backend (FastAPI)

FastAPI acts as the **central orchestrator** of the system.

Responsibilities:
- HTTP routing and request validation
- Session creation and lifecycle management (UUID-based)
- Communication with the AI engine (Firebase)
- Reading and writing persistent data (SQLite)
- Acting as a stable API layer for any frontend client

FastAPI owns **all business logic** and acts as the single source of truth.

---

### 🤖 AI Engine (Firebase + Genkit)

Firebase Functions serve as a **dedicated AI execution layer**, completely isolated from the main backend.

Genkit is used to:
- Define structured AI flows
- Manage prompt loading and composition
- Enforce schemas and safety boundaries
- Provide consistent AI behavior across modules

Each module has its own AI entry point:
- `tasker_ai()` – Task Deconstructor
- `paragraph_ai()` – Sensory Safe Reader
- `chatbot_ai()` – Socratic Buddy

FastAPI communicates with Firebase via HTTP calls, making the AI layer:
- Replaceable
- Independently deployable
- Easy to scale or modify without touching core logic

---

### 🎨 Frontend (Flutter)

Flutter is responsible for **presentation only**.

Responsibilities:
- Rendering screens and UI states
- Handling user input (text, audio, image)
- Displaying loading and result states
- Managing theming and accessibility options

The frontend does **not** contain business logic or AI reasoning.
All decisions come from the backend.

This ensures the UI remains:
- Simple
- Fast
- Easily replaceable

---

### 🗄️ Database (SQLite)

SQLite is used for lightweight, session-based persistence.

Stored data includes:
- Session metadata
- Module inputs and outputs
- Chat history (per session)

SQLite is accessed **only by FastAPI**, ensuring data integrity and controlled access.

---

## 🔌 Responsibility Split

| Layer     | Primary Responsibility |
|----------|------------------------|
| Flutter  | UI, user input, display states |
| FastAPI | Routing, sessions, orchestration |
| Firebase + Genkit | AI reasoning and prompt execution |
| SQLite  | Persistent storage |

---

## 🔄 High-Level Data Flow

```
USER → Flutter → FastAPI → Firebase (Genkit AI)
↕
SQLite
```


- The frontend never talks directly to Firebase
- The AI layer never accesses the database
- FastAPI coordinates all communication

---

## 🧠 Architectural Principles

- **Backend-first**: Logic lives on the server
- **Loose coupling**: Layers communicate via well-defined interfaces
- **Replaceability**: Any layer can be swapped with minimal impact
- **Clarity over complexity**: No unnecessary abstractions

This architecture allows Clarity to remain flexible, scalable, and easy to reason about — even as features evolve.
