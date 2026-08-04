# Simple repository workflow

This repository keeps the developer workflow intentionally simple. Use the framework commands directly from the relevant app directory rather than introducing repository-level automation.

## Frontend

Use the frontend when you are working on screens, app state, or Flutter-specific behavior.

```bash
cd frontend
flutter pub get
flutter run
```

## Backend

Use the backend when you are working on FastAPI routes, services, or business logic.

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

## Documentation

Use [GETTING_STARTED.md](GETTING_STARTED.md) and [Setup.md](Setup.md) as the source of truth for local setup.

## Contributing

Keep changes focused and document any setup or environment requirements that a teammate may need to know.
