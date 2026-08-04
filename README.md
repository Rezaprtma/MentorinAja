# MentorinAja

MentorinAja is a voice-first, AI-assisted learning platform for personalized tutoring. The repository combines a Flutter frontend with a FastAPI backend in a simple monorepo structure.

## Project overview

- Flutter frontend for Android, iOS, and Windows
- FastAPI backend for tutoring workflows, APIs, and business logic
- Product, architecture, schema, and design documentation for contributors

## Architecture

- Frontend: screens, lesson flow, voice and camera interaction, and local state
- Backend: API orchestration, progress logic, tutoring coordination, and persistence
- Data and services: Supabase-backed auth, storage, and supporting services

## Folder structure

- [frontend](frontend): Flutter application code and platform assets
- [backend](backend): Python backend service and API implementation
- [docs](docs): product, architecture, schema, design, and contributor workflow documents
- [.github](.github) and [.vscode](.vscode): repository configuration

## Tech stack

- Flutter and Dart
- Python and FastAPI
- Supabase for auth, storage, and data services
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

Start with [docs/development/GETTING_STARTED.md](docs/development/GETTING_STARTED.md) for the full setup guide.

## Contributing

Contributions should stay small, focused, and well documented. Review the relevant architecture and schema documents before changing behavior or contracts.

## License

See [LICENSE](LICENSE) for details.
