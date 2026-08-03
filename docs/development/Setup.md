# MentorinAja Development Setup

**Status:** Production onboarding baseline  
**Maintained by:** Engineering leads, platform maintainers, and contributors  
**Audience:** New contributors, platform engineers, backend engineers, and Flutter engineers

---

## Overview

This document is a deeper setup reference for the MentorinAja monorepo. It is intended to complement the beginner-focused onboarding guide in [GETTING_STARTED.md](GETTING_STARTED.md) rather than replace it.

MentorinAja is a Flutter-first, cross-platform client for Android, iOS, and Windows, backed by a Python FastAPI service and Supabase-managed infrastructure. The repository is organized as a monorepo, and the setup flow below reflects that structure directly.

This guide is the source-of-truth setup reference for local development. It must remain aligned with the repository architecture, product requirements, data contract, and frontend architecture documents in `docs/`.

---

## Purpose

The goal of this document is to support the deeper operational details of repository setup for contributors who already know the basic workflow from [GETTING_STARTED.md](GETTING_STARTED.md).

A contributor should be able to:

1. clone the repository
2. install the required toolchain
3. prepare environment files
4. install frontend and backend dependencies
5. verify the workspace health
6. start the frontend and backend locally
7. debug, build, and test in a consistent way

This document is not a generative tutorial. It is the engineering baseline for the team.

---

## Source-of-truth alignment

This guide must remain consistent with the repository’s authoritative documentation:

- `docs/PRD.md`
- `docs/ERD.md`
- `docs/SCHEMA.md`
- `docs/architecture/Architecture.md`
- `docs/architecture/FolderStructure.md`
- `docs/architecture/ProjectStructure.md`
- `docs/design/Design.md`
- `docs/design/DesignSystem.md`
- `docs/frontend/FlutterArchitecture.md`
- `docs/development/RepositoryTooling.md`

When in doubt, follow the architecture and repository structure documents first, then use this setup guide as the operational procedure.

---

## Repository layout

The repository is organized as a production-grade monorepo.

```text
mentorinaja/
├── .github/
├── .vscode/
├── assets/
├── backend/
├── docs/
├── examples/
├── frontend/
├── scripts/
├── tools/
├── README.md
├── .gitignore
└── .editorconfig
```

### Important folders

- `frontend/`: Flutter application
- `backend/`: Python backend service
- `docs/`: product, architecture, schema, and development references
- `scripts/`: repository automation and operational scripts
- `tools/`: generators and contributor utility tooling
- `assets/`: shared product assets

The repository structure is considered final. Do not redesign it during local development.

---

## Prerequisites

The machine must meet the minimum baseline needed to work on cross-platform Flutter and Python code.

### Supported operating systems

#### Windows

Use Windows 10 or later with PowerShell or Command Prompt. This is the primary supported workstation environment for the repo.

Required platform dependencies:

- Visual Studio Build Tools
- CMake
- Android SDK
- Java JDK
- Git
- Flutter SDK

#### macOS

Use macOS with Xcode and CocoaPods installed. macOS is required if you plan to build or debug iOS-specific workflows.

Required platform dependencies:

- Xcode
- CocoaPods
- Git
- Flutter SDK
- Java JDK if needed for Android tooling

#### Linux

Use a current supported Ubuntu or Debian-based environment if you are working on the backend, Flutter command line, or CI-compatible development.

Required platform dependencies:

- Git
- Flutter SDK
- Python
- build tools such as `make`, `gcc`, and `cmake`
- Android SDK if you need emulator or Android build support

### Minimum hardware

Recommended baseline:

- CPU: 4-core processor or better
- RAM: 16 GB minimum
- Disk space: 25 GB free for Flutter SDK, Android SDK, IDE tooling, and caches

### Recommended hardware

For comfortable development:

- CPU: 8-core processor
- RAM: 32 GB
- SSD storage: 100 GB or more free
- Dedicated GPU is optional, but a fast SSD is strongly recommended

### Reasoning

Flutter and Android tooling are heavy. The Android SDK, Gradle caches, emulator images, and IDE files consume a lot of disk and memory. A strong laptop or workstation reduces startup time, build time, and general developer friction.

---

## Software requirements

All tools below should be installed before running the repository locally.

### Required tools

- Git
- Flutter SDK
- Dart SDK (provided by Flutter)
- Python 3.12+
- Android Studio
- VS Code
- Supabase CLI
- Java JDK
- Android SDK
- CMake
- Visual Studio Build Tools (Windows only)
- CocoaPods (macOS only)
- Xcode (macOS only)

### Recommended stable versions

Use the latest stable releases that are compatible with the repository constraints.

- Flutter: stable 3.24.x or newer
- Dart: included with the Flutter SDK; use the Dart version bundled with the selected Flutter SDK
- Python: 3.12.x
- Git: latest stable 2.x release
- Java: 17 LTS
- Android SDK: command-line tools with the latest platform and build-tools installed

### Why these versions

- Flutter stable is the supported path for cross-platform application development.
- The repository backend bootstrap currently targets Python 3.12+, which is a strong baseline for modern FastAPI and dependency compatibility.
- Java 17 LTS is the most predictable support target for Android tooling.
- Using the Flutter-bundled Dart SDK avoids SDK mismatch issues.

---

## Recommended developer environment

### VS Code

Use VS Code as the standard editor for the entire monorepo.

Recommended extensions:

- `Dart-Code.dart-code`
- `Dart-Code.flutter`
- `ms-python.python`
- `ms-python.vscode-pylance`
- `ms-python.debugpy`
- `tamasfe.even-better-toml`
- `redhat.vscode-yaml`
- `eamodio.gitlens`
- `oderwat.indent-rainbow`
- `charliermarsh.ruff`

### Workspace settings

The repository already includes the VS Code workspace configuration. Use it as the standard contributor baseline.

Recommended settings:

- format on save enabled
- Python default interpreter set to the repository virtual environment
- Flutter and Dart language server enabled
- search exclusions enabled for generated and build directories
- terminal shell set to the system default shell

### Debug configuration

Use VS Code launch profiles for:

- frontend Flutter debug sessions
- backend Python debug sessions
- browser or device debugging where needed

### Tasks

Use the repository’s root Taskfile to run standard workflows from the repository root.

The official developer command surface is:

- `task setup` — bootstrap the repository toolchain and install dependencies
- `task doctor` — validate installed tools, environment variables, and local repository health
- `task dev` — start the frontend and backend together for local development
- `task frontend` — run only the Flutter frontend
- `task backend` — run only the Python backend
- `task test` — execute the frontend and backend test suites
- `task analyze` — run repository analysis checks
- `task lint` — run linting and validation checks
- `task format` — format the codebase
- `task build` — build standard repository artifacts
- `task clean` — remove generated caches and temporary artifacts

Use a repository task instead of calling framework-specific commands directly whenever possible.

### Terminal settings

Use integrated terminals with the repository root as the working directory by default. PowerShell is the standard shell on Windows; use the system shell on macOS and Linux.

### Formatting

Use the repository’s configured formatting rules:

- Dart formatting should be applied through Flutter tooling
- Python formatting should follow Black-compatible style
- `.editorconfig` is the repository-wide formatting baseline

---

## Clone the repository

Clone from the approved remote and enter the repository root.

### Windows PowerShell

```powershell
git clone <repository-url>
cd MentorinAja
```

### macOS / Linux

```bash
git clone <repository-url>
cd MentorinAja
```

### Branch strategy

Use the repository’s default branch as the integration branch and create short-lived feature branches for work.

Recommended branch naming:

- `feature/<short-name>`
- `fix/<short-name>`
- `chore/<short-name>`
- `refactor/<short-name>`

Do not mix unrelated changes into a single branch.

---

## Environment setup

### Frontend environment

The frontend lives in `frontend/` and uses Flutter.

Create the frontend environment file by copying the example:

```bash
cp frontend/.env.example frontend/.env
```

On Windows PowerShell:

```powershell
Copy-Item frontend/.env.example frontend/.env
```

Populate the variables with the project-specific values your environment requires.

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
