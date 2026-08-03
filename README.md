# MentorinAja

MentorinAja is a voice-first, AI-assisted learning platform designed to feel like a personal tutor rather than a generic chatbot. The repository combines a Flutter client, a Python FastAPI backend, and a shared documentation and tooling layer to support a modern cross-platform product experience.

## What this repository contains

- A cross-platform Flutter frontend for Android, iOS, and Windows
- A FastAPI backend for tutoring orchestration, API services, and business logic
- Product, architecture, schema, and design documentation for contributors
- Repository-level automation powered by Go Task for setup, quality checks, builds, and local development

## Architecture at a glance

The system is organized around a clear separation of concerns:

- Frontend: user experience, lesson flow, voice and camera interaction, and local state
- Backend: API orchestration, progress logic, tutoring coordination, and persistence
- Infrastructure and data: Supabase-backed auth, storage, and data services

For deeper context, start with the architecture and product documents in the documentation folder.

## Repository structure

- [frontend](frontend): Flutter application code and platform assets
- [backend](backend): Python backend service and API implementation
- [docs](docs): product requirements, architecture, schema, design, and contributor workflows
- [scripts](scripts) and [tools](tools): repository automation and development utilities

## Tech stack

- Flutter and Dart
- Python and FastAPI
- Supabase for auth, storage, and data services
- Go Task for repository automation
- VS Code and Android Studio for local development

## Key features

- Voice-first tutoring experience
- Structured course, lesson, practice, and quiz flow
- Progress tracking and learning state persistence
- Cross-platform delivery from a shared frontend codebase
- Contributor-focused tooling and documentation

## Getting started

New contributors should begin with [docs/development/GETTING_STARTED.md](docs/development/GETTING_STARTED.md).

For a deeper understanding of the product and implementation, review:

- [docs/development/RepositoryTooling.md](docs/development/RepositoryTooling.md)
- [docs/architecture/Architecture.md](docs/architecture/Architecture.md)
- [docs/PRD.md](docs/PRD.md)
- [docs/SCHEMA.md](docs/SCHEMA.md)
- [docs/ERD.md](docs/ERD.md)
- [docs/design/Design.md](docs/design/Design.md)

## Development workflow

The repository root commands are the recommended entry points for contributors:

- `task setup` to bootstrap the local environment
- `task doctor` to validate prerequisites and health
- `task dev` to start the full local stack
- `task frontend` and `task backend` for focused development
- `task analyze`, `task test`, `task format`, and `task build` for quality checks

## Contribution guide

Contributions should be small, focused, and well-documented. Before making substantial changes, review the relevant architecture and schema documents and keep the documentation aligned with any behavior change.

## License

This project is licensed under the terms of the repository license. See the LICENSE file for details.
