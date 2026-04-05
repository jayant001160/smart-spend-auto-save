# AI Usage

## Tools used

- Cursor AI agent
- LLM-assisted code generation/refactoring
- Command-line validation and static analysis

## Where AI helped

- Scaffolding Clean Architecture layers quickly across features
- Generating repetitive boilerplate for BLoC, entities, repositories, and usecases
- Accelerating model generation workflows with `json_serializable`
- Drafting initial documentation files and setup guides
- Iterating UI refinements quickly (theme system, gradient background, pie chart widget)

## Examples where AI output was wrong/suboptimal and how it was corrected

1. **Frontend endpoint mismatch**
   - AI initially generated an onboarding endpoint (`/api/onboarding`) that did not exist in backend routes.
   - Correction: aligned onboarding flow to backend contract by splitting requests into `POST /api/user` and `POST /api/goal`.

2. **Dashboard/insights response parsing mismatch**
   - AI initially assumed a flat dashboard response and a dedicated `/api/insights` endpoint.
   - Correction: updated parsing to use nested `data` payload from `/api/dashboard`, mapped `categoryBreakdown` into chart points, and mapped string insights into card entities.

3. **Frontend networking assumption on Android emulator**
   - AI initially used `localhost` as a universal base URL.
   - Correction: added platform-aware base URL logic (`10.0.2.2` for Android emulator, `localhost` otherwise).

## One design decision that was mine (not AI's)

- I chose to keep the backend recommendation logic as a modular service and expose it through a dedicated endpoint (`GET /api/recommendation`) while also showing recommendation on dashboard. This keeps the engine reusable, testable, and aligned with assignment deliverables.

