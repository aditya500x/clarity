# Clarity

**ADHD Support Application** - Helping neurodivergent users break down tasks, simplify text, and get guided learning support through AI-powered tools.

![Dart](https://img.shields.io/badge/Dart-64.5%25-0175C2?logo=dart&logoColor=white)
![Python](https://img.shields.io/badge/Python-20.2%25-3776AB?logo=python&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-11.1%25-3178C6?logo=typescript&logoColor=white)
![Java](https://img.shields.io/badge/Java-1.1%25-007396?logo=openjdk&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-0.9%25-438EFF?logo=apple&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-0.7%25-4EAA25?logo=gnu-bash&logoColor=white)

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-0.109+-009688?logo=fastapi&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Functions-FFCA28?logo=firebase&logoColor=black)
![Genkit](https://img.shields.io/badge/Genkit-AI-4285F4?logo=google&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-Database-003B57?logo=sqlite&logoColor=white)

---

## 🎯 Problem Statement

People with ADHD and neurodivergent conditions often struggle with:
- **Task Overwhelm**: Large assignments feel impossible to start
- **Text Processing**: Dense paragraphs are hard to parse and retain
- **Learning Barriers**: Traditional teaching methods don't work for everyone

**Clarity** addresses these challenges with three specialized AI-powered modules.

---

## 🧩 Features

### 1. Task Deconstructor
Break down complex tasks into small, manageable steps with time estimates and progress tracking.

### 2. Sensory Safe Reader  
Simplify dense or academic text into calm, easy-to-understand explanations.

### 3. Socratic Buddy
AI-guided learning companion that helps you understand topics through questions rather than lectures.

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter (Dart) - Cross-platform mobile/web |
| **Backend** | FastAPI (Python) - REST API server |
| **AI Engine** | Firebase Genkit + Google AI (Gemini) |
| **Database** | SQLite (local sessions) |
| **Hosting** | Firebase Functions + Cloud Run |

---

## 📁 Project Structure

```
clarity/
├── frontend/           # Flutter app
│   ├── lib/
│   │   ├── screens/    # UI screens
│   │   ├── models/     # Data models
│   │   ├── services/   # API client
│   │   └── config/     # App configuration
│   └── pubspec.yaml
│
├── backend/            # FastAPI server
│   ├── app/
│   │   ├── tasker.py   # Task Deconstructor API
│   │   ├── paragraph.py# Sensory Reader API
│   │   ├── chatbot.py  # Socratic Buddy API
│   │   └── database.py # SQLite ORM
│   ├── main.py
│   └── requirements.txt
│
├── functions/          # Firebase Genkit (AI)
│   ├── src/genkit/     # AI flow definitions
│   ├── prompts/        # Prompt templates
│   └── package.json
│
└── firebase.json       # Firebase config
```

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.0+
- Python 3.11+
- Node.js 18+
- Firebase CLI (`npm install -g firebase-tools`)

---

## 1️⃣ Backend Setup

```bash
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# OR: venv\Scripts\activate  # Windows

# Install dependencies
pip install fastapi uvicorn sqlalchemy python-dotenv httpx

# Create .env file
cat > .env << EOF
GENKIT_API_URL=http://localhost:3400
GOOGLE_API_KEY=your_google_ai_api_key
EOF

# Run server
uvicorn main:app --reload --port 5050
```

**Backend runs at**: `http://localhost:5050`

---

## 2️⃣ Frontend Setup

```bash
cd frontend

# Get dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Or run on Android
flutter run -d android
```

**Frontend expects backend at**: `http://localhost:5050`

Update `/lib/config/constants.dart` if backend URL changes:
```dart
static const String apiBaseUrl = 'http://localhost:5050';
```

---

## 3️⃣ Firebase Genkit (AI Engine)

```bash
cd functions

# Install dependencies
npm install

# Create .env file
cat > .env << EOF
GOOGLE_API_KEY=your_google_ai_api_key
EOF

# Start Genkit dev server
npx genkit start -- npx tsx src/genkit/genkit.ts
```

**Genkit runs at**: `http://localhost:3400`

---

## 4️⃣ Firebase Setup (Optional - for Cloud Deployment)

### Initialize Firebase

```bash
# Login to Firebase
firebase login

# Initialize project
firebase init functions

# Link to existing project
firebase use your-project-id
```

### Deploy Functions

```bash
cd functions
npm run build
firebase deploy --only functions
```

---

## 🌐 Deployment

### Option A: Local Development (Recommended for Testing)

1. Start Genkit: `cd functions && npx genkit start`
2. Start Backend: `cd backend && uvicorn main:app --port 5050`
3. Run Flutter: `cd frontend && flutter run -d chrome`

### Option B: Cloud Deployment

#### Backend → Cloud Run

```bash
cd backend

# Build Docker image
docker build -t clarity-api .

# Push to Google Container Registry
docker tag clarity-api gcr.io/YOUR_PROJECT/clarity-api
docker push gcr.io/YOUR_PROJECT/clarity-api

# Deploy to Cloud Run
gcloud run deploy clarity-api \
  --image gcr.io/YOUR_PROJECT/clarity-api \
  --platform managed \
  --allow-unauthenticated
```

#### AI Engine → Firebase Functions

```bash
cd functions
firebase deploy --only functions
```

#### Flutter → Firebase Hosting (Web)

```bash
cd frontend
flutter build web

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

---

## 🔑 Environment Variables

### Backend (.env)
```env
GENKIT_API_URL=http://localhost:3400   # Local Genkit
# OR: https://your-function.cloudfunctions.net  # Production
GOOGLE_API_KEY=your_api_key
```

### Functions (.env)
```env
GOOGLE_API_KEY=your_google_ai_api_key
```

---

## 📡 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/tasker/start` | POST | Break down a task |
| `/api/reader/input` | POST | Simplify text |
| `/api/chat/message` | POST | Chat with Socratic Buddy |
| `/api/settings/theme` | POST | Update theme preference |

---

## 🧪 Testing

### Test Backend
```bash
curl http://localhost:5050/
# {"status":"ok","message":"Clarity API is running"}
```

### Test Tasker API
```bash
curl -X POST http://localhost:5050/api/tasker/start \
  -H "Content-Type: application/json" \
  -d '{"input_method":"text","input_data":"Write an essay on climate change"}'
```

---

## 📱 Screenshots

*Coming soon*

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

## 👥 Team

Built with ❤️ for **Namma Hackathon** by:
- Team Clarity

---

## 🙏 Acknowledgments

- Google Gemini AI for powering the AI features
- Firebase for serverless infrastructure
- Flutter for cross-platform development
