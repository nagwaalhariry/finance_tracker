# Offline-First Personal Finance Tracker

Production-style full-stack personal finance tracker with:

- Flutter mobile app (`mobile_app/`)
- Node.js + Express backend (`backend/`)
- Offline-first sync architecture (local-first write, background sync)

## Project Structure

```text
finance_tracker/
├── mobile_app/
│   ├── lib/
│   │   ├── core/
│   │   │   ├── constants/
│   │   │   ├── network/
│   │   │   ├── services/
│   │   │   └── utils/
│   │   └── features/
│   │       └── expenses/
│   │           ├── data/
│   │           │   ├── datasources/
│   │           │   ├── models/
│   │           │   └── repositories/
│   │           ├── domain/
│   │           │   ├── entities/
│   │           │   ├── repositories/
│   │           │   └── usecases/
│   │           └── presentation/
│   │               ├── cubit/
│   │               ├── pages/
│   │               └── widgets/
│   └── pubspec.yaml
├── backend/
│   ├── src/
│   │   ├── config/
│   │   ├── controllers/
│   │   ├── middleware/
│   │   ├── models/
│   │   ├── routes/
│   │   └── services/
│   ├── package.json
│   └── env.example
└── docs/
    └── api.md
```

## Flutter Mobile App

### Tech Stack

- Flutter (Material 3)
- Clean Architecture (presentation/domain/data)
- `flutter_bloc` + Cubit
- Dependency Injection: `get_it` + `injectable`
- Local DB: Isar
- Networking: Dio
- Charts: `fl_chart`
- Background sync: `workmanager`

### Implemented Features

- Dashboard:
  - total spending this month
  - monthly spending line chart
  - category pie chart
  - recent expenses
- Add Expense:
  - `title`, `amount`, `category`, `date`, `note`
  - saved locally and marked `isSynced = false`
- Expense List:
  - view all
  - filter by category
  - sort by date
  - delete
  - edit
- Background Sync:
  - periodic task every 10 minutes
  - find unsynced expenses
  - call backend `/sync`
  - mark synced on success
  - retry strategy in repository sync logic

### Run Mobile App

1. Install dependencies:

```bash
cd mobile_app
flutter pub get
```

2. Generate Isar + Injectable files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run app:

```bash
flutter run
```

Notes:
- For Android emulator, backend base URL in `lib/core/constants/app_constants.dart` uses `http://10.0.2.2:3000/api`.
- For iOS simulator/device, update it to your machine LAN IP or `localhost` as needed.

## Backend API Server

### Tech Stack

- Node.js
- Express.js
- MongoDB
- Mongoose

### Endpoints

- `POST /api/expenses`
- `GET /api/expenses`
- `PUT /api/expenses/:id`
- `DELETE /api/expenses/:id`
- `POST /api/sync`

See complete API docs: [`docs/api.md`](docs/api.md)

### Run Backend

1. Install dependencies:

```bash
cd backend
npm install
```

2. Configure environment:

```bash
cp env.example .env
```

3. Start server:

```bash
npm run dev
```

The API runs at `http://localhost:3000`.

## Example Sync Request

```bash
curl --request POST \
  --url http://localhost:3000/api/sync \
  --header 'Content-Type: application/json' \
  --data '{
    "expenses": [
      {
        "id": "uuid-1",
        "title": "Lunch",
        "amount": 12.5,
        "category": "Food",
        "date": "2026-03-10T12:30:00.000Z",
        "note": "Office cafeteria",
        "createdAt": "2026-03-10T12:30:00.000Z"
      }
    ]
  }'
```

## Expected Sync Response

```json
{
  "message": "Sync completed",
  "syncedCount": 1
}
```
