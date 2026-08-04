# Development setup

This guide is a concise reference for local development in the MentorinAja monorepo. Use it alongside [GETTING_STARTED.md](GETTING_STARTED.md) when you need a quick reminder of the expected workflow.

## Prerequisites

Install the following before you start:

- Git
- Flutter SDK
- Android Studio
- Python 3.10+

## Frontend

The frontend lives in [frontend](../../frontend).

```bash
cd frontend
flutter pub get
flutter run
```

If Flutter reports missing Android tools, run `flutter doctor` and complete the missing setup steps in Android Studio.

## Backend

The backend lives in [backend](../../backend).

```bash
cd backend
python -m venv .venv
```

Activate the virtual environment:

### Windows

```powershell
.venv\Scripts\activate
```

### Linux and macOS

```bash
source .venv/bin/activate
```

Install dependencies and start the server:

```bash
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Environment variables

If the project includes example environment files, copy them to the expected `.env` location and fill in the required values before running the backend.

## Troubleshooting

- Use `flutter doctor` for Android, Flutter, and Java issues.
- Use `python -m pip install --upgrade pip` if package installation fails.
- Recreate the backend virtual environment if dependency issues persist.
- Keep the frontend and backend commands separate unless you are intentionally running both.

Required placeholders include:

- `APP_ENV=local`
- `APP_DEBUG=false`
- `SUPABASE_URL=https://your-project.supabase.co`
- `SUPABASE_ANON_KEY=your-supabase-anon-key`

### Backend environment

The backend lives in `backend/` and uses Python with a FastAPI bootstrap.

Create the backend environment file:

```bash
cp backend/.env.example backend/.env
```

On Windows PowerShell:

```powershell
Copy-Item backend/.env.example backend/.env
```

The backend environment file should contain at least:

- `APP_ENV=local`
- `APP_DEBUG=false`
- `SUPABASE_URL=https://your-project.supabase.co`
- `SUPABASE_ANON_KEY=your-supabase-anon-key`
- `SUPABASE_SERVICE_ROLE_KEY=your-supabase-service-role-key`

### Secrets management

- never commit `.env` files
- keep local secrets out of source control
- use the repository’s approved secret delivery mechanism for production or shared values
- rotate any exposed credential immediately

### Supabase configuration

Use a dedicated local or development Supabase project for onboarding. Keep the project identity distinct from production credentials.

The repository expects the following Supabase variables to be available to the backend and frontend at runtime:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`

Do not create database models or implement auth in this setup guide. Only configure the connection surface.

---

## Dependency installation

### Frontend

From the repository root:

```bash
cd frontend
flutter pub get
```

Optional but recommended after dependency updates:

```bash
flutter clean
flutter pub get
```

### Backend

From the repository root:

```bash
cd backend
python -m venv .venv
```

On Windows PowerShell:

```powershell
cd backend
py -m venv .venv
.\.venv\Scripts\Activate.ps1
```

On macOS / Linux:

```bash
source .venv/bin/activate
```

Then install dependencies:

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

If you are using the repository’s Python project metadata, keep the virtual environment active whenever you run backend commands.

---

## Project verification

Verify that the toolchain is synchronized before running the application.

### Verify Git

```bash
git --version
```

### Verify Flutter SDK

```bash
flutter --version
```

### Verify Dart SDK

```bash
dart --version
```

### Verify Python

```bash
python --version
```

### Verify Supabase CLI

```bash
supabase --version
```

### Verify Android SDK

```bash
flutter doctor -v
```

### Verify environment files

Check that the following files exist and are loaded correctly:

- `frontend/.env`
- `backend/.env`

Do not rely on `.env.example` for runtime execution.

### Flutter doctor

Run the standard verification step before opening the frontend:

```bash
flutter doctor
```

If the command reports missing Android toolchain, SDK licenses, or platform dependencies, fix those before continuing. Do not proceed with frontend development while the doctor is failing on required components.

---

## Running the project

### Frontend

From the repository root:

```bash
cd frontend
flutter run
```

Use a connected device or emulator. The frontend should start from the approved Flutter entrypoint using the repository’s existing architecture.

### Backend

From the repository root:

```bash
cd backend
source .venv/bin/activate
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

On Windows PowerShell:

```powershell
cd backend
.\.venv\Scripts\Activate.ps1
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Run both together

Use two terminals:

1. one terminal for the backend (`uvicorn ... --reload`)
2. one terminal for the frontend (`flutter run`)

This is the standard local development workflow for the monorepo.

### Expected startup output

The backend should respond with a normal FastAPI startup banner and bind to port `8000`.

The frontend should launch the Flutter app on the selected device or emulator with no sample counter, demo screen, or placeholder business logic.

### Common startup mistakes

- forgetting to activate the Python virtual environment
- missing or empty `.env` files
- running the frontend before `flutter pub get`
- missing Android licenses or device availability
- wrong working directory during command execution
- stale build caches after platform tooling changes

---

## Debugging

### Flutter debugging

Use VS Code with the Dart and Flutter extensions.

Recommended debugging workflow:

- set breakpoints in widgets and feature entry points
- run the app in debug mode from VS Code
- use hot reload for UI iteration
- use hot restart for stateful resets when necessary

### Python debugging

Use the Python extension and the configured debugpy integration.

Recommended debugging workflow:

- set breakpoints in the FastAPI startup and service layers
- run the backend with the Python debugger attached
- inspect configuration objects and env values before the app starts serving requests

### VS Code launch profiles

Use the workspace launch configuration to target:

- Flutter frontend debugging
- Python backend debugging

### Hot reload and hot restart

- use hot reload for incremental UI changes
- use hot restart when widget state or app bootstrap state must be reset
- avoid relying on hot restart for business logic changes that should be validated through a clean startup

---

## Building

### Android APK

```bash
cd frontend
flutter build apk
```

### Windows

```bash
cd frontend
flutter build windows
```

### iOS

On macOS:

```bash
cd frontend
flutter build ios
```

### Release mode

Use release builds only when you are testing packaging and deployment behavior, not during routine local iteration.

### Debug mode

Use debug mode for normal development and day-to-day feature work.

---

## Testing

### Flutter unit tests

```bash
cd frontend
flutter test test/unit
```

### Flutter widget tests

```bash
cd frontend
flutter test test/widget
```

### Flutter integration tests

```bash
cd frontend
flutter test integration_test
```

### Python tests

From the backend root:

```bash
cd backend
pytest
```

If the repository tests are organized under `backend/tests/`, maintain that structure and run the relevant subset first while developing.

---

## Code quality

### Formatting

- Dart: `dart format .`
- Python: `black .`

### Linting

- Flutter: `flutter analyze`
- Python: use repository-compatible linting and static checks

### Static analysis

Use the workspace analysis tools and the repository’s configured linting baseline for both frontend and backend.

### Code generation

When generated files are required, use the approved repository generation workflow and never hand-author generated artifacts. Keep generated output in the repository’s designated generated directories and preserve `.gitkeep` placeholders where appropriate.

---

## Monorepo workflow

Developers should work within the monorepo using a single repository root and a clear separation of responsibilities.

### Frontend workflow

- keep frontend changes inside `frontend/`
- use the existing Flutter feature architecture
- do not create ad hoc screens or utilities outside the approved structure
- keep routing and shared widgets consistent with the repository conventions

### Backend workflow

- keep backend changes inside `backend/app/`
- preserve configuration boundaries, logging, and dependency injection shape
- avoid leaking business logic into the frontend

### Shared documentation workflow

- update documentation only when repository behavior or contributor workflow changes
- do not edit product or architecture docs to reflect implementation drift
- keep documentation aligned with the engineering source-of-truth documents

### Repository conventions

- keep the repository root clean
- preserve the existing architecture
- do not introduce new top-level package managers or build systems unless the repository already requires them
- align changes with the repository’s approved directory structure

---

## Git workflow

### Branch naming

Use branch names that are descriptive and short-lived:

- `feature/auth-flow`
- `fix/lesson-progress-sync`
- `chore/backend-bootstrap`

### Commit convention

Use concise, descriptive commit messages that explain what changed and why.

Recommended pattern:

```text
<type>: <short summary>
```

Examples:

- `feat: add lesson view bootstrap`
- `fix: resolve backend env loading`
- `chore: align repo tooling with onboarding guide`

### Pull request convention

Pull requests should:

- include a minimal, reviewable scope
- describe the impact on frontend, backend, or platform behavior
- include verification evidence where relevant
- avoid unrelated refactors

### Code review

Reviewers should validate:

- architecture alignment
- dependency correctness
- environment assumptions
- test coverage for the changed scope

### Merge strategy

Use the repository’s standard protected branch workflow and merge through the approved review process.

---

## Project conventions

### Folder conventions

- keep all frontend application code in `frontend/lib/`
- keep backend application code in `backend/app/`
- keep repository automation in `scripts/` and `tools/`
- keep generated artifacts in their approved generated locations only

### Naming conventions

- Dart symbols should be descriptive and idiomatic
- Python modules should use straightforward, predictable names
- environment variables should be uppercase and explicit
- feature names should remain consistent across the monorepo

### Feature conventions

Each feature must follow the existing repository shape and remain isolated from unrelated feature concerns.

### Clean architecture conventions

- presentation should remain presentation-oriented
- domain and rules should stay server-side where required
- data access should be abstracted behind stable interfaces
- cross-cutting services should live in the core/shared layers, not inside individual feature implementations

---

## Troubleshooting

### Flutter doctor errors

Common causes:

- missing Android SDK path
- missing Android licenses
- missing Flutter PATH configuration
- platform tools not installed

Fix by re-running `flutter doctor` and installing the missing tools or updating environment path variables.

### Android emulator issues

Check:

- whether the emulator is installed
- whether virtualization is enabled
- whether the Android SDK platform is present
- whether the device is visible to `adb devices`

### Python virtual environment problems

Check:

- the virtual environment is activated
- `python --version` matches the expected version
- dependencies are installed into the active environment
- the working directory is the backend root when running the app

### Supabase connection issues

Check:

- `SUPABASE_URL` is valid
- `SUPABASE_ANON_KEY` is present
- `SUPABASE_SERVICE_ROLE_KEY` is present where required
- the local Supabase project is reachable from the machine

### Git problems

Check:

- remote origin is configured
- local branch is clean or intentionally dirty
- your working tree is not blocked by line-ending or permission issues

### Windows PATH problems

Common symptoms:

- `flutter` command not found
- `python` resolves to the wrong interpreter
- `supabase` command not found

Fix by ensuring the relevant SDK binaries are on PATH and restarting the terminal after updates.

### Dependency conflicts

When a dependency update causes churn:

1. remove the local package cache only if it is safe to do so
2. rerun `flutter pub get`
3. recreate the virtual environment if the Python environment is inconsistent
4. re-run verification commands

---

## FAQ

### How do I start the frontend?

Run:

```bash
cd frontend
flutter pub get
flutter run
```

### How do I start the backend?

Run:

```bash
cd backend
source .venv/bin/activate
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Do I need to install a separate Dart SDK?

No. Use the Dart SDK that ships with Flutter.

### Do I need to create `.env` files from scratch?

Yes. Copy the `.env.example` files in the repository and fill in the local values.

### Can I use a different editor?

Yes, but VS Code is the standard and recommended contributor environment.

### What if `flutter doctor` reports missing Android tools?

Install the missing Android SDK components and re-run `flutter doctor` until no required issues remain.

### What if the backend cannot import modules?

Ensure the virtual environment is active and that the working directory and Python path are correct.

---

## Best practices

### Developer onboarding checklist

Before opening a Pull Request, verify the following:

- the repository clone is clean
- `flutter --version` succeeds
- `python --version` succeeds
- `flutter doctor` is clean enough for the target platform
- `frontend/.env` exists and is valid
- `backend/.env` exists and is valid
- `flutter pub get` completed successfully
- backend dependencies were installed into the active virtual environment
- the app starts locally in debug mode

### Repository checklist

Before merging or sharing work:

- confirm the repository layout is unchanged from the approved structure
- confirm no unnecessary files were added
- confirm the working branch is scoped to the task
- confirm environment changes are documented where necessary

### Pre-commit checklist

Before committing:

- run the appropriate formatters
- run lint or static analysis for the relevant scope
- verify the changed files are intentional
- review the diff for unrelated noise

### Before opening a Pull Request

- verify the branch is up to date with the integration branch
- check for missing environment assumptions
- run the relevant frontend and backend verification commands
- ensure the PR description reflects the actual change scope

### Before creating a Release

- verify all required environment values are available
- verify the Flutter and backend builds succeed
- verify the release path for Android, Windows, and iOS is understood by the team
- review the repository-level release and docs alignment

---

## Final engineering expectation

A new developer should be able to clone this repository and follow the steps in this document to establish a working local environment for the Flutter frontend, the Python backend, and the Supabase-backed development flow without needing a second person to unblock setup.

The repository is expected to be treated as a controlled engineering surface. Follow the architecture, preserve the monorepo boundaries, and keep local setup reproducible for the entire team.

### Backend checks

```bash
pytest
```

### Flutter checks

```bash
flutter test
flutter analyze
```

### Quality expectations

- tests should be run before submitting changes that affect behavior
- new functionality should include relevant test coverage where practical
- failing tests should be investigated before merging

---

## Troubleshooting

### Flutter issues

If Flutter dependencies fail to resolve:

```bash
flutter clean
flutter pub get
```

### Python issues

If Python package installation fails:

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### Supabase connection issues

- confirm the environment variables are set correctly
- verify that the configured project URL and keys are valid
- check whether the local environment is pointing at the intended Supabase project

### Backend startup issues

- check the Python environment is activated
- verify that required environment variables are loaded
- confirm the application entrypoint exists and is correctly named

---

## Contribution Conventions

Contributors should follow these conventions while developing locally:

- keep changes consistent with the product and architecture documents
- update documentation when setup or workflow changes materially
- avoid introducing environment-specific assumptions into the repository
- write code and tests in a way that others can run without special setup beyond the documented steps

---

## Documentation and Maintenance

This setup guide should evolve as the repository changes. If the local build process, toolchain, or environment assumptions change, update the document in the same change set.

---

## References

This document should be read alongside the following authoritative sources:

- [../Architecture.md](../architecture/Architecture.md)
- [../frontend/FlutterArchitecture.md](../frontend/FlutterArchitecture.md)
- [../design/DesignSystem.md](../design/DesignSystem.md)
- [../PRD.md](../PRD.md)
- [../ERD.md](../ERD.md)
- [../SCHEMA.md](../SCHEMA.md)

These documents define the product architecture, design system, and persistence model that the development setup is intended to support.
