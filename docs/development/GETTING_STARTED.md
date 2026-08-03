# Getting Started with MentorinAja

**Status:** Current contributor onboarding guide  
**Audience:** New contributors on a fresh Windows machine

This guide is the first document new contributors should read. It is written for a developer starting from zero on a new Windows machine and is intended to take you from installation to a healthy local setup with minimal friction.

---

## 1. Repository overview

MentorinAja is an AI-assisted, voice-first learning platform built as a monorepo:

- Frontend: Flutter application for Android, iOS, and Windows
- Backend: Python FastAPI service for orchestration, business logic, and API endpoints
- Docs: product requirements, architecture, schema, design, and contributor workflow
- Tooling: Go Task-based repository commands in the repository root

The repository is intentionally organized so contributors can work from one entry point instead of remembering a long list of framework-specific commands.

---

## 2. Repository architecture at a glance

- The frontend lives in [frontend](../../frontend)
- The backend lives in [backend](../../backend)
- Product and implementation documentation lives in [docs](../)
- Repository automation lives in [Taskfile.yml](../../Taskfile.yml)

A typical contributor workflow is:

1. Install the required toolchain
2. Clone the repository
3. Run `task setup`
4. Verify the environment with `task doctor`
5. Start the app with `task dev`, `task frontend`, or `task backend`

---

## 3. Required software

The following tools are required for a full local setup on Windows.

| Tool           | Why it is needed                                           | Recommended source                                |
| -------------- | ---------------------------------------------------------- | ------------------------------------------------- |
| Git            | Clone and manage the repository                            | Official installer or Scoop                       |
| Python         | Run the FastAPI backend and create the virtual environment | Official installer or Scoop                       |
| Flutter SDK    | Build and run the Flutter app                              | Official Flutter SDK                              |
| Dart SDK       | Comes with Flutter; used for formatting and analysis       | Bundled with Flutter                              |
| Android Studio | Required for Android emulator, SDK tools, and Java         | Official installer                                |
| VS Code        | Recommended editor for the monorepo                        | Official installer or Scoop                       |
| Go Task        | Run the repository automation from the root                | Scoop                                             |
| Java JDK       | Required by Android tooling                                | Installed through Android Studio or JDK installer |

### Windows-specific prerequisites

For Android builds and emulator support, install the following in Android Studio:

- Android SDK Platform
- Android SDK Build-Tools
- Android Emulator
- Platform Tools
- Android SDK Command-line Tools

On Windows, Visual Studio Build Tools and CMake are also recommended for native build support.

---

## 4. Install the toolchain on a fresh Windows machine

### 4.1 Install Scoop

Open PowerShell and run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
Invoke-RestMethod https://get.scoop.sh | Invoke-Expression
```

### 4.2 Install Git, Python, VS Code, and Task with Scoop

```powershell
scoop bucket add extras
scoop install git python vscode go-task
```

### 4.3 Install Flutter SDK

Flutter is typically installed from the official Flutter SDK download rather than from a package manager.

1. Download the Flutter SDK for Windows from the official Flutter website.
2. Extract it to a stable location such as `C:\src\flutter`.
3. Add Flutter to your `PATH`.

Example PowerShell commands:

```powershell
$env:Path = "C:\src\flutter\bin;" + $env:Path
```

For a permanent setup, add the Flutter `bin` directory to your user PATH in System Properties.

### 4.4 Install Android Studio

1. Install Android Studio from the official website.
2. Open Android Studio and install the Android SDK components listed above.
3. Accept the Android Studio setup prompts and let the IDE install the default SDK packages.
4. Restart your terminal after installation so the updated environment is visible.

### 4.5 Install VS Code extensions (recommended)

Install the following extensions in VS Code:

- Dart
- Flutter
- Python
- Pylance
- Debugpy
- YAML
- GitLens

---

## 5. Verify that everything is installed

Open a new PowerShell window and run:

```powershell
git --version
python --version
flutter --version
dart --version
task --version
java -version
flutter doctor
```

If `flutter doctor` reports issues, resolve the missing Android or Java prerequisites before continuing.

---

## 6. Clone the repository

From PowerShell:

```powershell
git clone <repository-url>
cd MentorinAja
```

If you prefer a custom local folder, use:

```powershell
git clone <repository-url> C:\src\MentorinAja
cd C:\src\MentorinAja
```

---

## 7. Bootstrap the repository

The canonical setup entry point is:

```powershell
task setup
```

This installs or validates the frontend and backend dependencies and prepares the repository for local development.

After setup, run:

```powershell
task doctor
```

The doctor command should report the repository as ready before you start coding.

---

## 8. Set up only the frontend

Use this when you are working primarily on the Flutter app:

```powershell
task frontend:setup
```

This validates the Flutter toolchain, installs frontend dependencies, and checks the frontend environment.

---

## 9. Set up only the backend

Use this when you are working primarily on the FastAPI service:

```powershell
task backend:setup
```

This creates the backend virtual environment, installs Python dependencies, and validates the backend environment.

---

## 10. Run the application

### Run the frontend only

```powershell
task frontend
```

This starts the Flutter app. You will need a connected device or an emulator.

### Run the backend only

```powershell
task backend
```

This starts the FastAPI app at `http://localhost:8000`.

### Run both together

```powershell
task dev
```

This launches the frontend and backend together for full-stack local development.

---

## 11. Check repository health

Use these commands regularly:

```powershell
task doctor
task status
```

The doctor command checks prerequisites and environment readiness. The status command prints the current toolchain versions and repository readiness summary.

---

## 12. Keep dependencies and code healthy

### Update dependencies

```powershell
task update
```

### Format code

```powershell
task format
```

### Run analysis

```powershell
task analyze
```

### Run tests

```powershell
task test
```

### Build artifacts

```powershell
task build
```

### Clean local artifacts

```powershell
task clean
```

---

## 13. Android and Windows notes

### Android

Before running the app on Android:

- Start an emulator from Android Studio, or
- Connect a physical Android device with USB debugging enabled

Then run:

```powershell
task frontend
```

### Windows

If you plan to build Windows artifacts, make sure the Windows build prerequisites are installed and then run:

```powershell
task build:windows
```

---

## 14. Task reference

The repository root commands are the preferred entry points for contributors.

| Command         | What it does                                    | When to use it                                               | Expected result                                              |
| --------------- | ----------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `task setup`    | Bootstraps the frontend and backend environment | First-time setup or after resetting local state              | Frontend and backend dependencies are installed and verified |
| `task doctor`   | Validates the repository environment            | Before coding, after setup, and after changing tooling       | A clear pass/fail summary for frontend and backend readiness |
| `task status`   | Prints installed versions and repository health | When you want a quick environment snapshot                   | Version information and readiness status                     |
| `task frontend` | Starts the Flutter frontend                     | When working on UI, screens, or mobile experiences           | Frontend runs in a local device or emulator session          |
| `task backend`  | Starts the FastAPI backend                      | When working on API routes, services, or business logic      | Backend runs at `http://localhost:8000`                      |
| `task dev`      | Starts both frontend and backend together       | For full-stack local development                             | Both applications start from the repository root             |
| `task analyze`  | Runs frontend and backend analysis              | Before review, before build, or after changes                | Static analysis results are reported                         |
| `task test`     | Runs frontend and backend tests                 | Before opening a PR or after significant changes             | Test results are printed for both sides                      |
| `task format`   | Formats source files                            | Before committing or before review                           | Code is formatted consistently                               |
| `task clean`    | Removes generated caches and temporary files    | When local state is stale or builds are failing unexpectedly | Temporary artifacts are removed                              |
| `task build`    | Builds release artifacts                        | Before release or before a major verification pass           | Build outputs are produced                                   |
| `task release`  | Prepares release artifacts                      | Before packaging or release review                           | Release-oriented build artifacts are prepared                |

---

## 15. Common troubleshooting

### `task` is not recognized

Open a new PowerShell window after installing Scoop or Task. If needed, restart your machine.

### `flutter` or `python` is not recognized

Make sure the relevant installation directory is on your PATH and restart PowerShell.

### `task doctor` fails on Android SDK or Java

Open Android Studio, install the Android SDK components, and confirm the SDK location is configured correctly.

### The frontend says no device is available

Start an Android emulator or connect a device with USB debugging enabled.

### The backend virtual environment is missing or stale

Run:

```powershell
task backend:setup
```

### The repository seems inconsistent after dependency changes

Run:

```powershell
task clean
task setup
task doctor
```

---

## 16. Next steps

Once setup is complete, the best next steps are:

1. Read the architecture overview in [../architecture/Architecture.md](../architecture/Architecture.md)
2. Review the product requirements in [../PRD.md](../PRD.md)
3. Review the implementation schema in [../SCHEMA.md](../SCHEMA.md)
4. Start development with `task dev` or focus on one subsystem with `task frontend` or `task backend`
