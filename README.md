# MentorinAja

MentinorinAja is a course-based learning platform for Indonesian learners — "Teman Belajar yang Memahami Kamu". The repository combines a Flutter frontend (the implemented product) with a FastAPI backend bootstrap in a simple monorepo structure.

## Project overview

- Flutter frontend for Android, iOS, and Windows (current implementation)
- FastAPI backend (bootstrap only; no services implemented yet)
- Product, design, architecture, and development documentation for contributors

## Architecture

- Frontend: onboarding → auth → four-tab learning shell (Home, Explore, Progress, Profile) on local mock data
- Backend: FastAPI bootstrap scaffold; not yet wired to the frontend

## Folder structure

- [frontend](frontend): Flutter application code and platform assets
- [backend](backend): Python backend service (scaffold)
- [docs](docs): product, design, architecture, and contributor workflow documents
- [.github](.github) and [.vscode](.vscode): repository configuration

## Tech stack

- Flutter and Dart
- Python and FastAPI (backend scaffold)
- Git, Android Studio, and VS Code for local development

## Getting started

### Frontend

```bash
cd frontend
flutter pub get
flutter run
```

### Backend

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

On Windows, activate the virtual environment with:

```powershell
.venv\Scripts\activate
```

### Documentation

Start with [docs/README.md](docs/README.md) for the documentation hub, or [docs/development/contributing.md](docs/development/contributing.md) for the full setup guide.

## Contributing

Contributions should stay small, focused, and well documented. Review the relevant product, design, and architecture documents before changing behavior or contracts.

## License

See [LICENSE](LICENSE) for details.
