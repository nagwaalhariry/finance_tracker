# Finance Tracker API Documentation

Base URL: `http://localhost:3000/api`

## Health Check

- `GET /health`
- Response:

```json
{
  "status": "ok"
}
```

## Expense Endpoints

### 1) Create Expense

- `POST /expenses`
- Request body:

```json
{
  "id": "e4b58f52-84d7-42d2-bf80-e80fd6f8ea81",
  "title": "Lunch",
  "amount": 12.5,
  "category": "Food",
  "date": "2026-03-10T12:30:00.000Z",
  "note": "Office cafeteria",
  "userId": "default-user",
  "createdAt": "2026-03-10T12:30:00.000Z"
}
```

- Success response (`201`):

```json
{
  "message": "Expense created",
  "data": {
    "_id": "67ce8f9e76b7f860d71b1d72",
    "id": "e4b58f52-84d7-42d2-bf80-e80fd6f8ea81",
    "title": "Lunch",
    "amount": 12.5,
    "category": "Food",
    "date": "2026-03-10T12:30:00.000Z",
    "note": "Office cafeteria",
    "userId": "default-user",
    "createdAt": "2026-03-10T12:30:00.000Z"
  }
}
```

### 2) Get All Expenses

- `GET /expenses`
- Success response (`200`):

```json
{
  "data": [
    {
      "_id": "67ce8f9e76b7f860d71b1d72",
      "id": "e4b58f52-84d7-42d2-bf80-e80fd6f8ea81",
      "title": "Lunch",
      "amount": 12.5,
      "category": "Food",
      "date": "2026-03-10T12:30:00.000Z",
      "note": "Office cafeteria",
      "userId": "default-user",
      "createdAt": "2026-03-10T12:30:00.000Z"
    }
  ]
}
```

### 3) Update Expense

- `PUT /expenses/:id`
- Example: `PUT /expenses/e4b58f52-84d7-42d2-bf80-e80fd6f8ea81`
- Request body:

```json
{
  "title": "Lunch (updated)",
  "amount": 14.25,
  "note": "With coffee"
}
```

- Success response (`200`):

```json
{
  "message": "Expense updated",
  "data": {
    "id": "e4b58f52-84d7-42d2-bf80-e80fd6f8ea81",
    "title": "Lunch (updated)",
    "amount": 14.25
  }
}
```

### 4) Delete Expense

- `DELETE /expenses/:id`
- Example: `DELETE /expenses/e4b58f52-84d7-42d2-bf80-e80fd6f8ea81`
- Success response (`200`):

```json
{
  "message": "Expense deleted"
}
```

## Sync Endpoint

### 5) Bulk Sync from Mobile

- `POST /sync`
- Request body:

```json
{
  "expenses": [
    {
      "id": "uuid-1",
      "title": "Dinner",
      "amount": 25.99,
      "category": "Food",
      "date": "2026-03-09T20:00:00.000Z",
      "note": "Restaurant",
      "createdAt": "2026-03-09T20:00:00.000Z"
    },
    {
      "id": "uuid-2",
      "title": "Bus Ticket",
      "amount": 2.75,
      "category": "Transport",
      "date": "2026-03-10T07:30:00.000Z",
      "note": "",
      "createdAt": "2026-03-10T07:30:00.000Z"
    }
  ]
}
```

- Success response (`200`):

```json
{
  "message": "Sync completed",
  "syncedCount": 2
}
```

## MongoDB Expense Schema

```js
{
  id: String,         // unique client-generated UUID
  title: String,
  amount: Number,
  category: String,
  date: Date,
  note: String,
  userId: String,
  createdAt: Date
}
```
