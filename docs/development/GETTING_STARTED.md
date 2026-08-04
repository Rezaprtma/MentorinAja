# Getting started with MentorinAja

This guide is for a developer starting from scratch. It covers the minimum tools you need, the simple setup flow, and the common commands to run the frontend and backend locally.

## 1. Install the required tools

Install these first:

- Git
- Flutter SDK
- Android Studio
- Python

### Install Git

Download and install Git from the official website.

### Install Flutter

1. Download the Flutter SDK from the official Flutter site.
2. Extract it to a stable location such as `C:\src\flutter`.
3. Add the Flutter `bin` directory to your `PATH`.

Verify the install with:

```powershell
flutter --version
flutter doctor
```

### Install Android Studio

1. Install Android Studio from the official website.
2. Open Android Studio and install the Android SDK components you need for emulator support.
3. If `flutter doctor` reports missing Android SDK or Java tools, install the missing components through Android Studio.

### Install Python

Install Python from the official Python website and confirm it works:

```powershell
python --version
```

## 2. Clone the repository

```powershell
git clone <repository-url>
cd MentorinAja
```

## 3. Frontend setup

From the repository root:

```powershell
cd frontend
flutter pub get
```

Run the app:

```powershell
flutter run
```

You will need a connected device or an emulator.

## 4. Backend setup

From the repository root:

```powershell
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

Install the dependencies:

```bash
pip install -r requirements.txt
```

Run the backend:

```bash
uvicorn app.main:app --reload
```

The API should be available at `http://localhost:8000`.

## 5. QA workflow

If you are validating the app rather than developing it, you can:

- run the frontend with `flutter run`, or
- install an APK built from the frontend app

## 6. Troubleshooting

### Common Flutter issues

- Run `flutter doctor` to inspect missing SDKs, Android tools, or Java issues.
- Make sure your Android emulator is running before using `flutter run`.
- If a plugin fails to install, run `flutter pub get` again.

### Common Python issues

- If `pip` fails, upgrade it with `python -m pip install --upgrade pip`.
- If the backend cannot start, confirm that the virtual environment is active.
- If imports fail, reinstall the requirements with `pip install -r requirements.txt`.

### Virtual environment

Keep the backend virtual environment inside the repository so it stays isolated from the rest of your machine.

### Environment variables

If the repository includes example environment files, copy them to the expected `.env` location and fill in any required values before running the backend.

If a required value is missing, check the project documentation or ask the maintainers for the current local configuration.

## 13. Android and Windows notes

### Android

Before running the app on Android:

- Start an emulator from Android Studio, or
- Connect a physical Android device with USB debugging enabled

Then run:

```powershell
flutter run
```

### Windows

If you plan to build Windows artifacts, make sure the Windows build prerequisites are installed and then run the Flutter build command for your target.

## 14. Common troubleshooting

### `flutter` or `python` is not recognized

Make sure the relevant installation directory is on your PATH and restart PowerShell.

### Android SDK or Java tools are missing

Open Android Studio, install the Android SDK components, and confirm the SDK location is configured correctly.

### The frontend says no device is available

Start an Android emulator or connect a device with USB debugging enabled.

### The backend virtual environment is missing or stale

Create it again:

```powershell
cd backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

## 15. Next steps

Once setup is complete, the best next steps are:

1. Read the architecture overview in [../architecture/Architecture.md](../architecture/Architecture.md)
2. Review the product requirements in [../PRD.md](../PRD.md)
3. Review the implementation schema in [../SCHEMA.md](../SCHEMA.md)
4. Start development with the frontend and backend commands above
