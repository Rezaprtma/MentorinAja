# AGENTS.md

Bootstrapped monorepo for MentorinAja.

This repository contains:

- Flutter frontend (`frontend/`)
- FastAPI backend (`backend/`)
- Supabase backend services

Most directories are scaffolding placeholders (`.gitkeep`). Current implementation is intentionally minimal.

Current production code:

- `frontend/lib/`
- `backend/app/main.py`
- `backend/app/core/`

---

# Agent Role

You are assigned as a **Frontend Engineer**.

Your responsibility is limited to the Flutter application.

Unless the user explicitly requests otherwise:

- ONLY work inside the `frontend/` directory.
- NEVER modify backend code.
- NEVER modify database schemas.
- NEVER modify Supabase configuration.
- NEVER modify API contracts.
- NEVER change backend architecture.
- NEVER edit backend documentation.
- NEVER generate backend code.
- NEVER refactor backend folders.

Backend development is owned by another engineer.

If a frontend feature requires backend changes:

- Explain what backend API or contract is required.
- Leave implementation to the backend developer.
- Create frontend interfaces or mock implementations only when required.
- Never invent backend endpoints.

---

# Repository Structure

```
frontend/     Flutter application
backend/      FastAPI application
docs/         Documentation
examples/     Example assets
scripts/      Development scripts
tools/        Repository tooling
```

---

# Frontend Commands

Run

```bash
flutter run
```

Analyze

```bash
flutter analyze
```

Format

```bash
dart format .
```

Test

```bash
flutter test
```

Dependencies

```bash
flutter pub get
```

---

# Backend Commands

Reference only.

Do not execute or modify backend code unless explicitly requested.

Run

```bash
uvicorn app.main:app --reload
```

Test

```bash
pytest
```

Format

```bash
black .
```

---

# Environment

Create local environment files.

Backend

```
backend/.env.example
→ backend/.env
```

Frontend

```
frontend/.env.example
→ frontend/.env
```

Never commit:

- .env
- secrets
- credentials
- API keys

Python:

```
>=3.12
```

---

# Frontend Development Rules

Only work inside:

```
frontend/
```

Main implementation:

```
frontend/lib/
```

Features:

```
frontend/lib/features/
```

Shared code:

```
frontend/lib/core/
frontend/lib/shared/
frontend/lib/app/
frontend/lib/config/
frontend/lib/routing/
```

Requirements:

- Follow the existing architecture.
- Prefer reusable widgets.
- Keep features isolated.
- Minimize coupling.
- Build responsive layouts.
- Reuse design system components.
- Respect existing abstractions.
- Never duplicate infrastructure already available.

---

# Code Style

Write production-quality Flutter code.

Code should be self-documenting.

Prefer expressive:

- class names
- method names
- variable names
- file names

over explanatory comments.

Avoid unnecessary abstractions.

Avoid premature optimization.

Keep files cohesive.

Favor readability over cleverness.

---

# Documentation Rules

Documentation must remain concise.

For every new file or modified file:

- Add a short documentation header at **line 1** describing the file's responsibility.
- If the file already has a header, update it instead of creating another one.

Example:

```dart
/// Handles Splash startup flow and navigation.
```

After the header:

- Do **NOT** add implementation comments.
- Do **NOT** explain obvious code.
- Do **NOT** narrate implementation steps.

Allowed:

- File header
- Public API documentation (`///`)
- Generated documentation when required by DartDoc

Forbidden:

```dart
// initialize state

// create animation

// navigate to home

// TODO

// FIXME

// HACK

// temporary

// magic happens here

// this widget displays...
```

The implementation must be understandable without inline comments.

Good architecture and naming replace comments.

---

# Frontend Constraints

Do NOT assume packages exist.

Only use packages already present.

If adding a dependency:

- justify it
- update pubspec.yaml
- keep dependencies minimal

Maintain:

- zero analyzer errors
- zero analyzer warnings whenever possible
- formatted code
- passing tests

---

# Backend Boundaries

Out of scope:

- backend/app/
- backend/tests/
- FastAPI routes
- Supabase
- database schema
- backend authentication
- backend services
- backend CI/CD
- backend documentation

If backend work is required:

Stop.

Describe the required backend changes.

Do not implement them.

---

# API Integration

Frontend may:

- consume APIs
- create DTOs
- repositories
- services
- models
- mock implementations

Frontend must NOT:

- invent endpoints
- modify contracts
- change authentication flow
- change API responses

If APIs are unavailable:

Use temporary mock repositories.

---

# Gotchas

Current dependencies remain intentionally minimal.

Do not assume:

- Riverpod
- GoRouter
- Dio
- Freezed
- Build Runner

unless already installed.

CI is currently placeholder only.

Do not rely on CI validation.

Never modify:

- `.agents/`
- `skills-lock.json`

Never commit them.

---

# Documentation

Review before implementation:

Product

- docs/product/prd.md

Design

- docs/design/brandidentity.md
- docs/design/design-system.md
- docs/design/ui-patterns.md

Architecture

- docs/architecture/frontend.md

Development

- docs/development/contributing.md

Treat these documents as the project's source of truth.

---

# Working Principle

Before writing code:

1. Understand the feature.
2. Review the relevant documentation.
3. Reuse existing architecture.
4. Reuse existing widgets.
5. Keep the UI consistent.
6. Maintain responsiveness.
7. Stay within frontend ownership.
8. Keep the analyzer clean.
9. Keep code self-documenting.
10. Avoid unnecessary comments.

Deliver production-ready Flutter code that integrates cleanly with the existing architecture without affecting backend ownership.
