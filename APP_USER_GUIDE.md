# Smart Spend & Auto-Save: New User Guide

This guide explains the app from scratch for someone who has never seen it before.

## What this app is

`Smart Spend & Auto-Save` is a personal finance app that helps you:
- track daily spending
- plan a savings goal
- understand your money habits
- get a weekly smart savings recommendation

It is designed to make saving easier without complex setup.

---

## What problem it solves

Many users know they should save but struggle because:
- they do not track where money goes
- they do not have a concrete goal
- they do not know how much is safe to save every week

This app solves that with one simple flow:
1. Enter your income and savings goal
2. Log expenses regularly
3. Review dashboard and insights
4. Follow recommendation to save consistently

---

## How the app works (high level)

The product has 3 technical parts:

## 1) Frontend (Flutter mobile app)
This is the app you use on your phone.  
It has 4 main screens:
- Onboarding
- Expense Entry
- Dashboard
- Insights

UI style in current version:
- teal brand app bar across screens
- top-to-bottom gradient background (teal to soft light tone)
- card-based sections for readability

## 2) Backend (Node.js + Express APIs)
This powers all business logic and validation:
- stores and updates your profile, goal, and expenses
- calculates spending summaries
- generates savings recommendation and alerts

## 3) Database (MongoDB)
This stores your data in collections:
- `users`
- `goals`
- `expenses`

So when you submit data in the app, it is validated and saved in the backend/database, then shown back to you as dashboard insights.

---

## Frontend: what each screen does

## Onboarding
This is the **default landing page** when the app opens for every user.

You provide:
- monthly income
- goal name (example: “Emergency Fund”)
- target amount
- target date

What happens after submit:
- app saves profile (`/api/user`)
- app saves goal (`/api/goal`)
- you get sync status (success/failure with retry)

Why this matters:
- it gives the recommendation engine context
- it defines your savings target and timeline

### Important behavior: multiple submits from same user

In the current app/backend behavior:
- A user can submit the onboarding form multiple times.
- Submitting again with the same salary and a new goal name/amount/date is allowed.
- The app does **not** create multiple separate user profiles/goals.
- Instead, backend **updates the existing profile and existing goal** with the latest submitted values.

So practically, each new submit acts like an **edit/update** of the current setup for that user flow.

## Expense Entry
You add daily/weekly expenses with:
- amount
- category
- merchant
- date
- payment mode
- optional notes

Important:
- each expense includes a generated `requestId` (UUID) to avoid duplicate records when users tap multiple times or retry after unstable network.

Why this matters:
- better expense quality leads to better dashboard accuracy and better recommendations.

## Dashboard
This is the core decision screen. It shows:
- weekly spend
- monthly spend
- remaining budget
- goal progress
- weekly smart auto-save recommendation
- category spend pie chart with legend
- insight messages

Why this matters:
- gives a quick health check of your money
- converts raw expense data into actions

## Insights
This screen shows insight cards from backend rules and trends, such as:
- spending increase patterns
- budget usage warnings
- savings opportunity reminders

Why this matters:
- helps you improve habits before overspending becomes a problem.

---

## Backend: APIs and logic

The backend exposes REST APIs under `/api`:

- `POST /api/user` -> create/update user profile
- `GET /api/user` -> fetch user profile
- `POST /api/goal` -> create/update savings goal
- `GET /api/goal` -> fetch goal
- `POST /api/expenses` -> create expense
- `GET /api/expenses` -> list expenses
- `PUT /api/expenses/:id` -> update expense
- `DELETE /api/expenses/:id` -> delete expense
- `GET /api/dashboard` -> dashboard summary
- `GET /api/recommendation` -> smart weekly savings recommendation

### Business rules handled in backend

- positive amount validation
- no future expense dates
- valid goal date and amount
- idempotent expense creation via `requestId`
- weekly recommendation based on:
  - income
  - monthly spending
  - distance to goal
  - time left for target date
  - spending spikes
- alert generation for risky spending patterns

---

## Database model overview

## User
- monthlyIncome
- monthlyBudget (optional; defaults effectively from income in flow)

## Goal
- goalName
- targetAmount
- targetDate
- savedAmount

## Expense
- amount
- category
- merchant
- date
- paymentMode
- notes
- requestId (unique for duplicate prevention)

---

## Complete user flow (step-by-step)

1. Open app and go to **Onboarding**
2. Enter income + savings goal and submit
   - If you submit onboarding again later, your latest values replace previous profile/goal values.
3. Move to **Expense Entry** and add expenses regularly
4. Open **Dashboard** to monitor spend and recommendation
5. Open **Insights** to understand behavior patterns
6. Adjust spending based on insight cards and recommendation
7. Repeat weekly for steady progress toward your goal

---

## How users get real benefit

Users get value in 3 layers:

1. **Awareness**  
   They finally see where money is going every week/month.

2. **Control**  
   They receive alerts before spending goes out of control.

3. **Progress**  
   They follow practical weekly save recommendations and move toward a concrete goal.

In short: this app turns spending data into clear, actionable savings decisions.

---

## Tips for best results

- log expenses daily (or at least every 2-3 days)
- keep categories consistent
- set realistic goal amounts and dates
- review dashboard weekly
- use recommendation as a guide, not a rigid rule

---

## Reliability and safety notes

- If network fails, UI shows sync state and retry actions.
- Duplicate expense submits are handled safely using `requestId`.
- All API validation errors return readable messages.

