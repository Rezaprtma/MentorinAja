# Contributing Guide

This document describes the engineering workflow for MentorinAja: how to set up, develop, verify, and submit changes to this repository.

- **Status:** Authoritative
- **Last updated:** 2026-08-12
- **Scope:** Repo-wide engineering workflow. Product intent → `docs/product/`, visual rules → `docs/design/`.

---

## 1. Repository Overview

```
docs/                      # This documentation
frontend/                  # Flutter application (primary implementation)
backend/                   # FastAPI bootstrap (minimal, no services yet)
scripts/, tools/, examples/, assets/  # auxiliary (sparse)
```

- **Frontend-first.** The Flutter app is the implemented product. Backend is a bootstrap only.
- Monorepo: one repo, frontend + backend owned separately.

---

## 2. Prerequisites

| Tool | Version | Notes |
|---|---|---|
| Flutter | Stable | `flutter --version` |
| Dart | Bundled with Flutter | |
| Android Studio / Xcode | Latest | For emulator/device runs |
| Python | 3.12+ | Backend only |

---

## 3. Setup

### Frontend

```bash
cd frontend
flutter pub get
flutter run            # pick device when prompted
```

### Backend (reference)

```bash
cd backend
python -m venv .venv
.venv\Scripts\activate        # Windows; source .venv/bin/activate on macOS/Linux
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Environment variables: copy the relevant `.env.example` to `.env` and fill in values. Never commit `.env` or secrets.

---

## 4. Verify Before You Commit

Run from the root or the relevant package:

| Check | Command | Must be |
|---|---|---|
| Frontend analyze | `cd frontend && flutter analyze` | Zero issues |
| Frontend format | `cd frontend && dart format .` | Formatted |
| Frontend tests | `cd frontend && flutter test` | All passing |
| Backend tests | `cd backend && pytest` | All passing |

CI (if present) runs the same checks. If you cannot run a check locally, say so in the PR.

---

## 5. Development Workflow

1. **Pick a focused task.** Keep changes scoped; a PR should do one thing well.
2. **Read the relevant docs first:** `docs/product/prd.md` for intent, `docs/design/*` for how it must look, `docs/architecture/*` for how it fits.
3. **Reuse before building:** check `shared/design_system/` and existing features for a component or pattern before writing new UI.
4. **Follow the coding standards** in `docs/architecture/frontend.md` §8 (self-documenting code, expressive names, minimal comments).
5. **Verify** with the commands above (analyze + format + tests).
6. **Update docs** if the change alters behavior, structure, or conventions.

---

## 6. Coding Standards (Frontend)

- **Self-documenting code** wins over comments: expressive names, cohesive files, clear structure.
- **Comments:** file-level doc header (line 1) + public API docs only. No inline narration or TODO noise.
- **Design tokens:** never hardcode colors/spacing/type in screens — use the token layer.
- **State management:** plain Flutter first (`StatefulWidget`, `ChangeNotifier`). Do not add packages without justification.
- **Dependencies:** verify a package exists in `pubspec.yaml` before importing; keep dependencies minimal.
- **Responsive:** every screen works at all three breakpoints.
- **Accessibility:** labels, contrast, touch targets, text scaling.

---

## 7. Feature Development Pattern

A new feature is created in `lib/features/<name>/`:

```
features/<name>/
├── <name>.dart              # public barrel
├── logic/                   # controllers, validators, mock data
└── presentation/
    ├── pages/               # screens
    └── widgets/             # screen-scoped widgets
```

1. Expose only the public API through the barrel.
2. Keep the presentation layer unaware of the data source (mock today, API later).
3. Add unit tests for logic and widget tests for screens/flows.

---

## 8. Documentation Rules

- Keep docs concise and current; update them in the same change that affects behavior.
- Add a one-line doc header at the top of every new file.
- Do not document planned-but-unbuilt systems as existing.
- Product claims belong in `docs/product/`; visual rules in `docs/design/`; structure in `docs/architecture/`.

---

## 9. Commit and Review

- Follow the repo's commit conventions (concise, conventional-style subject).
- Do not commit secrets, `.env`, or generated artifacts.
- Reviewers: check docs consistency, token usage, accessibility, and responsiveness as well as logic.
