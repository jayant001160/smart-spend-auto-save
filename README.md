# Smart Spend & Auto-Save

Fullstack interview assignment project with:
- Flutter frontend (`frontend/`)
- Node.js + Express + MongoDB backend (`backend/`)

## Features Implemented

### Flutter app
- Onboarding: monthly income + goal setup (goal name, target amount, target date)
- Expense Entry: add expense with UUID `requestId` for duplicate prevention
- Dashboard:
  - weekly spend
  - monthly spend
  - remaining budget
  - goal progress
  - smart auto-save recommendation
  - category-wise pie chart (using `fl_chart`)
  - insights list
- Insights screen: card-based rendering of backend insights
- Graceful failure handling with visible sync state and retry for onboarding/expense submission
- Themed UI:
  - top app bar with fintech teal brand color
  - vertical scaffold gradient (teal to soft light background)
  - updated cards, typography, and chart styling

### Backend APIs
- User profile: create/update/get
- Savings goal: create/update/get
- Expense: create/list/update/delete
- Dashboard summary
- Recommendation endpoint (`GET /api/recommendation`)
- Idempotency handling for duplicate `requestId` in expense creation
- Rule-based alert/recommendation logic

## Tech Stack

### Frontend
- Flutter
- flutter_bloc
- dio
- dartz (`Either<Failure, T>`)
- get_it
- json_serializable + build_runner
- equatable
- fl_chart
- uuid

### Backend
- Node.js
- Express
- MongoDB + Mongoose
- dotenv
- cors

## Project Structure

```
smart-spend-auto-save/
├── frontend/
└── backend/
```

Frontend follows feature-based Clean Architecture under `frontend/lib/` with:
- `core/`
- `features/onboarding`
- `features/expenses`
- `features/dashboard`
- `features/insights`

## Setup

## 1) Backend

From `backend/`:

1. Install dependencies:
   - `npm install`
2. Create `.env`:
   - `PORT=9000`
   - `MONGO_URI=<your_mongodb_connection_string>`
3. Start server:
   - `npm run dev`

## 2) Frontend

From `frontend/`:

1. Install dependencies:
   - `flutter pub get`
2. Generate model serializers:
   - `flutter pub run build_runner build --delete-conflicting-outputs`
3. Run app:
   - `flutter run`

### Android emulator networking note

For Android emulators, the app uses `http://10.0.2.2:9000` automatically.
For iOS/web/desktop, it uses `http://localhost:9000`.

### Current onboarding behavior note

Submitting onboarding multiple times updates the same profile/goal records with latest values.
It does not create multiple separate user profiles/goals in current backend logic.

## Quality Checks

From `frontend/`:
- `flutter analyze`

From `backend/`:
- `node --check server.js`

## Documents Included

- `design_notes.md`
- `ai_usage.md`
- `postman_collection.json`
- `APP_USER_GUIDE.md`

