# Design Notes

## Architecture choices

## Flutter
- Feature-based Clean Architecture was used:
  - `presentation/` for UI + BLoC
  - `domain/` for entities, repository abstractions, usecases
  - `data/` for models, data sources, repository implementations
- `Either<Failure, T>` is used in repository + usecase layers for explicit success/failure modeling.
- `get_it` is used for dependency injection.
- `NetworkManager` is the single HTTP entry point for all frontend API calls.
- App-level theme is centralized and includes:
  - teal app bar branding
  - vertical gradient scaffold background
  - unified card/input/button styling
  - reusable chart and insight widgets

## Backend
- Express app uses route/controller/service separation.
- Mongoose models represent `User`, `Goal`, and `Expense`.
- Recommendation and alert logic are extracted into dedicated service modules.

## Recommendation logic

The weekly auto-save recommendation considers:
- user monthly income
- current month spend
- distance from goal (`targetAmount - savedAmount`)
- months left until goal date
- weekly spending spike compared to previous week

Rules currently applied:
- baseline recommendation = min(goal pace target, safe fraction of disposable income)
- if weekly spend spikes above 125% of previous week, recommendation is reduced
- alerts generated when:
  - category exceeds 80% of monthly budget
  - discretionary monthly spend is too high relative to income

## Edge cases handled

- invalid or future expense date
- negative/zero amount and target values
- goal date in the past
- duplicate taps / duplicate submissions (idempotency with `requestId`)
- network/backend failures surfaced to UI with clear sync status and retry action
- onboarding resubmission updates existing profile/goal with latest values

## Trade-offs

- Insights endpoint is served from dashboard payload to keep backend simple and avoid duplicated logic.
- Offline-first persistent queue was not implemented; instead, graceful retry/failure UX is implemented.
- Authentication and multi-user tenancy were kept out of scope to match assignment scope and timeline.
- Goal management is single-record (latest goal), not multi-goal portfolio, to keep MVP focused.

