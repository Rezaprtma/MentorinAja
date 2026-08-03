# Repository Tooling Standard for MentorinAja

**Document type:** Engineering standard
**Status:** Draft v1.0
**Audience:** Contributors, maintainers, reviewers, and future engineering leads
**Scope:** Official repository developer experience standard for the MentorinAja monorepo

---

## 1. Purpose

This document defines the official Developer Experience (DX) standard for the MentorinAja monorepo.

Its purpose is to establish one consistent repository workflow for all contributors, regardless of whether they are working on Flutter, Python, Supabase integration, automation, or future services. The standard is intentionally tool-agnostic at the workflow level and implementation-agnostic at the runner level.

The repository command surface is the stable contract. The underlying command runner may change in the future without changing the contributor workflow.

---

## 2. Source-of-Truth Alignment

This document is derived from the existing project-authoritative documentation and is designed to remain consistent with it:

- product intent: [docs/PRD.md](../PRD.md)
- data and schema contract: [docs/ERD.md](../ERD.md) and [docs/SCHEMA.md](../SCHEMA.md)
- architecture boundaries: [docs/architecture/Architecture.md](../architecture/Architecture.md)
- repository structure: [docs/architecture/FolderStructure.md](../architecture/FolderStructure.md) and [docs/architecture/ProjectStructure.md](../architecture/ProjectStructure.md)
- frontend structure: [docs/frontend/FlutterArchitecture.md](../frontend/FlutterArchitecture.md)
- developer setup baseline: [docs/development/Setup.md](Setup.md)

Where these documents define product, architecture, and repository shape, this document defines the repository command and developer workflow standard that supports them.

---

## 3. DX Standard

### 3.1 Core rule

MentorinAja must expose a single, repository-level command contract that abstracts away framework-specific details.

A contributor should be able to type the same high-level repository commands regardless of whether they are:

- running Flutter
- running Python backend services
- validating Supabase connectivity
- generating assets or code
- running tests and analysis
- cleaning or resetting local state

This command contract must remain stable even when the internal implementation changes.

### 3.2 Standard repository command namespace

The repository command namespace shall be expressed through the following stable command families.

- `setup`
- `doctor`
- `dev`
- `frontend`
- `backend`
- `clean`
- `reset`
- `generate`
- `analyze`
- `lint`
- `format`
- `test`
- `build`
- `release`

These are conceptual repository commands. They are not tied to any specific runner, shell, package manager, or task engine.

### 3.3 Command semantics

Each repository command must satisfy the following contract:

1. The command name must be stable and human-readable.
2. The command must be available from the repository root.
3. The command must be delegated to the appropriate implementation internally.
4. The command must fail clearly and predictably when prerequisites are missing.
5. The command must return a machine-readable and developer-readable outcome.
6. The command must avoid leaking framework-specific fundamentals into the contributor mental model.

The repository-level command surface is the product of the DX layer. It is not the source of truth for application behavior.

---

## 4. Engineering Principles

### 4.1 Separation of concerns

Repository tooling must be responsible only for repository orchestration, not for application business logic.

The repository command layer owns:

- environment validation
- dependency installation
- generation and scaffolding
- static analysis and linting
- build and test orchestration
- release automation
- developer convenience workflows

The repository command layer does not own:

- product logic
- business rules
- database business constraints
- Flutter rendering logic
- Python domain logic

### 4.2 Repository ownership

Repository tooling is owned by the repository itself.

That means:

- commands live in the repository and are versioned with it
- command semantics are documented in source control
- command behavior is reviewed through pull requests
- tool implementation may evolve, but the command contract must not drift casually

### 4.3 Tool independence

The workflow must remain independent from the choice of command runner.

The repository command namespace must not be tightly coupled to:

- a specific shell
- a specific package manager
- a specific OS session model
- a framework-specific launcher

Implementation details may change. The contributor workflow must not.

### 4.4 Cross-platform compatibility

MentorinAja supports Android, iOS, and Windows, and its contributor workflow must remain usable across the supported engineering environments.

The repository must prefer command pathways that are cross-platform by default. On Windows, the workflow must be first-class. On future contributor environments, the same command names and command outcomes should remain consistent.

### 4.5 Maintainability

Repository tooling must be small, readable, and predictable.

A contributor should not need to inspect five different script systems to understand how the repository works. The repository should expose one clear entry point and route work to the appropriate implementation underneath.

### 4.6 Future extensibility

The repository command contract must support future growth without redesigning the developer workflow.

A new service, tool, or platform should add new command implementations behind the same stable command surface rather than forcing contributors to learn new entrypoints.

---

## 5. Recommended Developer Workflow

### 5.1 Standard contributor flow

The standard repository workflow is:

1. `task setup`
2. `task doctor`
3. `task dev`
4. `task frontend` or `task backend` when focused on a subsystem
5. `task analyze`, `task lint`, `task format`, `task test` during implementation
6. `task build` for verification
7. `task clean` when restoring a healthy local state

This workflow is intentionally simple and stable.

### 5.2 Command behavior expectations

The repository command layer should behave as follows:

- `setup`: bootstrap the repository and install all required local dependencies
- `doctor`: validate installed tools, environment variables, project layout, and service connectivity
- `dev`: launch the standard local development workflow
- `frontend`: run or target the Flutter client workflow
- `backend`: run or target the Python backend workflow
- `clean`: remove generated or temporary local artifacts
- `reset`: restore a known-good local state, including cache and local environment recovery
- `generate`: run repository-supported code generation or scaffolding
- `analyze`: run static analysis for the relevant projects
- `lint`: run linting rules for the codebase
- `format`: normalize formatting for the codebase
- `test`: execute repository tests at the appropriate scope
- `build`: run build validation for the current target or release workflow
- `release`: prepare or publish the repository release package, if applicable

### 5.3 Stable output contract

Repository commands should report:

- whether prerequisites are satisfied
- which toolchain or service was invoked
- whether dependencies were installed or skipped
- whether the command completed successfully or failed
- the next recommended action if the command fails

The repository runtime should never silently hide an environment or dependency failure.

---

## 6. Public Task Command Reference

The repository root task commands are the public developer contract. Contributors should use these commands from the repository root rather than invoking framework tools directly whenever possible.

| Task            | What it does                                                                       | When to use it                                             | Expected result                                           |
| --------------- | ---------------------------------------------------------------------------------- | ---------------------------------------------------------- | --------------------------------------------------------- |
| `task setup`    | Bootstraps frontend and backend dependencies and validates the initial environment | First-time setup or after resetting local state            | The repository is ready for development                   |
| `task doctor`   | Runs the frontend and backend environment checks and returns a combined summary    | After setup and whenever you want to verify health         | A clear pass/fail report for the repository               |
| `task status`   | Prints installed versions, environment state, branch, and repository readiness     | When you want a quick snapshot of local health             | Version and readiness information appears in the terminal |
| `task frontend` | Starts the Flutter frontend                                                        | When working on UI, screens, or mobile workflows           | The frontend launches on an available device or emulator  |
| `task backend`  | Starts the FastAPI backend                                                         | When working on API routes, business logic, or services    | The backend serves locally on port 8000                   |
| `task dev`      | Starts both frontend and backend together                                          | For full-stack local development                           | Both services launch from the repository root             |
| `task analyze`  | Runs frontend and backend analysis                                                 | Before review, before build, or after significant changes  | Static analysis results are reported                      |
| `task test`     | Runs the frontend and backend test suites                                          | Before opening a PR or after meaningful changes            | Test results are reported for both projects               |
| `task format`   | Formats frontend and backend source files                                          | Before committing or requesting review                     | Source files are formatted consistently                   |
| `task clean`    | Removes generated caches and temporary artifacts                                   | When local state appears stale or builds fail unexpectedly | Temporary and generated files are removed                 |
| `task build`    | Builds the repository artifacts that are configured for the current workflow       | Before release or for a verification pass                  | Build outputs are produced where supported                |
| `task release`  | Prepares release-oriented artifacts                                                | Before packaging or release review                         | Release build artifacts are prepared                      |

### Command usage notes

- Use `task setup` first when you are new to the repository or after a fresh clone.
- Use `task doctor` whenever you want to confirm the workspace is healthy before continuing.
- Use `task frontend`, `task backend`, or `task dev` depending on whether you are focusing on the UI, the API, or the full stack.
- Use `task analyze`, `task test`, and `task format` as part of the normal implementation loop.

---

## 7. Onboarding Experience

### 6.1 Goal

A new contributor should be able to go from a fresh repository clone to a running local application through a single, documented sequence.

### 6.2 End-to-end setup flow

The repository onboarding flow is defined as follows.

#### Step 1 — Verify repository prerequisites

Before running any project-specific work, verify:

- Git is installed and the repository can be cloned
- Python is installed and matches the supported backend version
- Flutter SDK is installed and compatible with the project
- Dart SDK is available through the Flutter toolchain
- the required platform tools are installed for the target work
- the relevant Supabase access path is available to the contributor

#### Step 2 — Clone and enter the repository

The repository must be cloned using the standard Git flow and then entered in the expected working directory.

#### Step 3 — Run repository setup

A contributor should run the repository-level setup command as the canonical entrypoint.

This step must perform all repository bootstrap responsibilities, including:

- creating or activating the standard Python environment for the repository
- installing backend dependencies
- installing or refreshing frontend dependencies
- validating the expected repository structure
- preparing local environment files or configuration placeholders where required
- checking whether generated artifacts are missing
- validating service dependencies that the local workflow depends on

#### Step 4 — Validate the environment

The repository must provide a robust environment validation step that confirms:

- required SDKs are present
- required environment variables are defined
- required secrets or local configuration are not missing in a way that blocks development
- expected repository folders exist
- local service endpoints are reachable where required

A `doctor` command must identify failures before the contributor starts changing code.

#### Step 5 — Generate or verify required repository artifacts

The repository must support a safe generation phase for anything that is expected to be derived rather than hand-authored.

Examples include:

- generated or synced assets
- typed models or contract assets where required
- local environment scaffolding for development
- repository tooling artifacts needed by the command layer

This step must be deterministic and repeatable.

#### Step 6 — Validate local services

The project depends on Supabase and possibly other supporting services. Local validation must confirm that the repository’s service integration can be reached from the local developer environment.

This includes validating:

- Supabase configuration availability
- authentication and database access path
- service and endpoint reachability
- required local configuration values

#### Step 7 — Run the repository health workflow

The repository health workflow should be the final readiness gate before the contributor starts the app.

This command should verify all major onboarding prerequisites and return either a healthy local state or a list of concrete remediation steps.

#### Step 8 — Start local development

Once the health check passes, the contributor runs the standard local development command.

The development command should start the repository in a stable, documented way and must provide one obvious path for the contributor to begin implementing work.

### 6.3 Onboarding principle

The developer experience is successful only when a contributor can move from clone to running app without memorizing framework-specific commands.

---

## 7. Repository Automation Design

### 7.1 Automation responsibilities

The repository automation layer must centralize the following responsibilities:

- dependency installation
- code generation
- formatting
- linting
- testing
- static analysis
- cleaning
- building
- releasing
- local development
- environment validation

This automation layer belongs in repository-owned locations such as `scripts/` and `tools/` and must remain separate from application logic.

### 7.2 Dependency installation

The dependency installation workflow must be repository-defined and repository-owned.

Responsibilities:

- install backend Python dependencies into the repository’s standard environment
- install frontend package dependencies for Flutter
- handle environment-specific prerequisites consistently
- avoid requiring contributors to learn multiple package managers for the same outcome

The repository command contract must present the dependency installation step as a single repository command rather than a set of ad-hoc framework commands.

### 7.3 Code generation

The repository generation workflow must support repeatable, deterministic generation of code, assets, or structured repository artifacts.

This should include:

- repository-owned generators
- consistent output locations
- explicit generation contracts
- idempotent behavior where possible

Generators must not be hidden in arbitrary developer shells or isolated personal scripts.

### 7.4 Formatting

Formatting must be enforced consistently across languages and files.

The repository should define a standard formatting entrypoint that delegates to the appropriate formatter for each part of the codebase, without requiring contributors to remember each formatter invocation.

### 7.5 Linting and static analysis

The repository should expose one repository-level lint and analysis contract that can delegate to:

- Flutter analysis
- Python linting and static analysis
- repository-level checks for configuration drift and structure

A `lint` command should validate edit quality. An `analyze` command should validate architecture, type safety, or deeper correctness where appropriate.

### 7.6 Testing

Testing must have one stable repository-level command surface.

The repository-level test command must support a sensible default that can be scoped as needed. It should not force contributors to know the entire test matrix by memory.

The command layer should be responsible for:

- selecting the right test scope
- surfacing failures clearly
- allowing deterministic pass/fail outcomes
- avoiding hidden environment coupling

### 7.7 Cleaning and reset

A clean and reset workflow is required because the repository spans runtime, generated, cached, and tool-specific state.

The repository should clearly distinguish between:

- `clean`: remove temporary or generated artifacts
- `reset`: re-establish a healthy working state, including dependency and environment recovery when appropriate

This distinction reduces ambiguity and prevents accidental local state damage.

### 7.8 Building and release

The repository build and release flows should also be abstracted behind repository commands.

This ensures that:

- build behavior remains stable across language and package boundaries
- release steps remain repeatable
- internal tool changes do not break the contributor mental model

Build and release commands must remain explicit, reviewable, and version-controlled.

### 7.9 Local development

The repository must define one local development path that can be started from the root without requiring a contributor to remember multiple underlying commands.

The local development contract should expose:

- the standard local app startup sequence
- service validation expectations
- a healthy local state signal
- a predictable failure path

---

## 8. Recommended Directory Structure for Tooling

The repository tooling should live in the repository-owned structure defined by the architecture documentation.

### 8.1 Recommended locations

- `scripts/` — repository orchestration entrypoints and root-level automation scripts
- `tools/` — internal repository utilities, generators, helper scripts, and local engineering support code
- `.github/` — CI, validation, automation, and release workflows

These locations are the standard home for repository automation.

### 8.2 Ownership rules

- `scripts/` owns high-level developer workflows and command entrypoints
- `tools/` owns reusable engineering support utilities
- `.github/` owns CI and release automation contracts
- application code must not own repository command orchestration

### 8.3 Design principle

Tooling should be discoverable from the repository root, but should not live inside product feature folders. Repository automation is a cross-cutting concern and must remain distinct from runtime product code.

---

## 9. Command Runner Evaluation

The command runner must be selected after the workflow has been designed.

The repository now uses Go Task as the official root-level command runner. The repository command contract remains stable through `task <command>` at the repo root, and the `Taskfile.yml` in the repository root is the source of truth for the command implementation.

The following options are evaluated below.

### 9.1 Option comparison

| Option               | Advantages                                                                                                                                      | Disadvantages                                                                                                                  | Cross-platform support                                                                                                  | Learning curve | Scalability | Maintainability | Assessment                                                                                                         |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- | -------------- | ----------- | --------------- | ------------------------------------------------------------------------------------------------------------------ |
| Taskfile             | Clear task model, readable commands, easy to document                                                                                           | Requires a separate tool dependency; not universal across all contributor environments                                         | Good on Unix-like environments, weaker on Windows-first experience unless well-abstracted                               | Low            | Good        | Good            | Viable but not the best fit for a repo that must remain platform-neutral and not assume external ecosystem tooling |
| Makefile             | Very common in many engineering environments                                                                                                    | Not natively ideal for Windows-first workflow; less expressive for modern cross-platform orchestration                         | Weak to moderate                                                                                                        | Low            | Moderate    | Moderate        | Not recommended as the primary DX contract for this repo                                                           |
| Justfile             | Clean task syntax and good readability                                                                                                          | Still another tool dependency; not every contributor environment will use or trust it                                          | Good on Unix-style workflows, weaker as the repository’s primary default for Windows-first development                  | Low            | Good        | Good            | Possible secondary option, but not ideal as the single source of truth                                             |
| package.json scripts | Familiar to many teams, easy to wire into CI                                                                                                    | Assumes Node.js and npm, which the project should not require as a repository-level dependency just to run developer workflows | Good in Node environments, but not a good fit for a Flutter + Python monorepo with a Windows-first contributor baseline | Low            | Moderate    | Moderate        | Not recommended as the primary repository command system                                                           |
| Custom CLI           | Full control over repository contract; stable command namespace; tool-independent; can be implemented with Python or another repo-owned runtime | Requires repository-owned implementation maintenance                                                                           | Excellent if implemented using a cross-platform runtime                                                                 | Moderate       | Excellent   | Excellent       | Recommended                                                                                                        |
| Shell scripts        | Lightweight and easy to start                                                                                                                   | Often brittle across Windows/macOS/Linux; script portability becomes a maintenance burden                                      | Poor to moderate                                                                                                        | Low            | Moderate    | Low to moderate | Acceptable only as an implementation detail, not the primary contract                                              |
| PowerShell scripts   | Strong on Windows; good for local developer experience on Windows                                                                               | Not the default for cross-platform shell parity; more awkward in Linux/macOS scenarios                                         | Moderate                                                                                                                | Low            | Moderate    | Moderate        | Useful as a secondary implementation layer, not as the single repository command standard                          |

### 9.2 Evaluation summary

The repository should not rely on a runner that imposes a new ecosystem dependency for contributors unless that dependency is already a project requirement.

The project already has a strong Python backend and Flutter client alignment. The repository now standardizes on Go Task as the official root-level command runner because it provides a readable, versioned, cross-platform task model and produces a consistent `task <command>` entrypoint for contributors.

### 9.3 Recommended implementation

The repository’s official implementation is now the repo-owned `Taskfile.yml` at the root, driven by Go Task. This provides a stable command contract and cross-platform orchestration without requiring Node.js for contributor workflows.

Recommended design characteristics:

- stable repository command names from the repository root
- implementation hidden behind the command namespace
- repo-owned entrypoint
- cross-platform runtime as the default execution model
- optional shell wrappers or platform adapters only where needed for convenience

The implementation is intentionally placed in the repository root `Taskfile.yml` and delegates to the underlying Flutter, Python, and platform tooling as needed.

### 9.4 Why this is the best fit

This matches the project’s architecture and constraints:

- the repository is a monorepo spanning Flutter and Python
- the backend already uses Python and should remain a first-class platform in the developer workflow
- the project is cross-platform and must remain Windows-friendly
- the command namespace must remain stable even if the runner changes
- the workflow should be simple for multiple contributors and future engineers

### 9.5 Trade-offs of the recommended approach

Advantages:

- complete control over the repository command contract
- no forced dependency on Node.js
- easy to keep the command interface stable and highly opinionated
- straightforward to add future services later
- reduces contributor cognitive load

Disadvantages:

- requires the repository to own a small amount of tooling code
- implementation must be maintained as part of the repo
- additional governance is required to keep the command layer from drifting

This is a worthwhile trade-off because the repository command contract is a critical developer product surface.

---

## 10. Recommended Repository Command Contract

The repository command surface should have a stable shape like the following.

### 10.1 Required commands

The repository command surface is versioned through the root `Taskfile.yml` and is accessed as `task <command>`.

- `task setup` — bootstrap the repository environment and install current dependencies
- `task doctor` — validate toolchain, environment, and service configuration
- `task dev` — start the default local development workflow
- `task frontend` — run or target the Flutter client workflow
- `task backend` — run or target the Python backend workflow
- `task clean` — remove transient generated state
- `task analyze` — run static analysis
- `task lint` — run lint checks
- `task format` — normalize code formatting
- `task test` — execute the appropriate test scope
- `task build` — validate build readiness
- `task release` — run the repository release workflow

### 10.2 Command contract properties

Each command must:

- be root-level and discoverable
- be documented in repository engineering documentation
- be supported by CI in the same high-level form where appropriate
- fail with actionable diagnostics
- preserve stable naming even if the backend runner changes

---

## 11. Implementation Guidance

### 11.1 Workflow-first design

The command namespace must be designed before writing any script or runner-specific implementation.

This is the most important governance decision in the repository workflow standard.

If the repository defines the workflow first, then the chosen implementation can be swapped later without rewriting the contributor experience.

### 11.2 Repository implementation layers

A sensible layered model is:

1. stable repository command namespace
2. repository-owned command dispatcher
3. tool-specific adapters for Flutter, Python, Supabase, and future services
4. CI orchestration using the same command contract where possible

This keeps the architecture clean and allows the repository to evolve without breaking the contributor interface.

### 11.3 Tooling placement

Repository tooling should live in the following pattern:

- `scripts/` for user-visible root commands and orchestration entrypoints
- `tools/` for lower-level helper logic and shared automation components
- `.github/` for CI validation and automation that mirrors the repo command contract

This avoids scattering developer workflow logic across feature code and keeps repository ownership explicit.

---

## 12. Best Practices

### 12.1 Recommended workflow

The recommended contribution workflow for MentorinAja is:

1. run `task setup`
2. run `task doctor`
3. run `task dev`
4. use `task frontend` and `task backend` only when narrowing scope
5. run `task analyze`, `task lint`, `task format`, and `task test` during implementation
6. run `task build` before submitting high-impact changes
7. use `task clean` when the local state is uncertain

This is the repository’s standard engineering rhythm.

### 12.2 Common mistakes

Common mistakes to avoid:

- teaching contributors framework-specific commands instead of repository commands
- placing repository automation inside feature folders
- letting the implementation runner leak into the contributor workflow
- creating OS-specific scripts without a cross-platform replacement
- allowing different teams to define their own private command aliases
- letting local setup drift from the documented repository flow

### 12.3 Anti-patterns

The following are explicitly discouraged:

- one-off personal scripts that become unofficial repository standards
- hidden environment assumptions within the repo command layer
- different commands for the same operation across teams
- special-casing Windows, macOS, and Linux with diverging contributor flows
- reducing the repository workflow to a set of ad-hoc manual instructions

### 12.4 Migration strategy

The repository should migrate to this standard in a controlled manner.

Recommended migration steps:

1. define the stable repository command namespace
2. implement the central dispatcher
3. adapt current setup and automation steps behind the new contract
4. preserve any legacy commands as compatibility aliases for a limited transition period
5. deprecate direct framework-specific commands in contributor-facing documentation
6. remove duplicated or unowned automation after CI and contributor guidance have switched

### 12.5 Repository governance

Repository tooling is governed as part of the repository’s engineering contract.

Changes to the command contract must be reviewed and documented. The repository command namespace is not a personal convenience layer. It is part of the engineering standard of the monorepo.

---

## 13. Production-Grade DX Standard

A production-grade DX standard for MentorinAja must do the following:

- reduce cognitive load for all contributors
- scale across multiple engineers and time
- remain stable as internal implementations evolve
- avoid framework-specific memorization
- support modern cross-platform development
- keep the repository workflow understandable and reviewable

The repository command layer is the mechanism that turns the engineering architecture into a contributor-friendly operating model.

The repository command workflow is therefore not merely a convenience feature. It is a core engineering standard for the codebase.

---

## 14. Final Recommendation

The MentorinAja repository should standardize on a repository-owned custom CLI as the official developer command interface, with a stable command namespace exposed at the repository root.

This is the best fit because it:

- keeps the contributor workflow stable
- avoids assuming Node.js or any single shell/runtime ecosystem
- works well with a Flutter + Python monorepo
- aligns with the project’s existing `scripts/` and `tools/` repository structure
- supports future service growth without rewriting the developer workflow

The consolidated command surface should be the single source of truth for repository operations, while the implementation underneath may evolve over time.

The repository must never ask contributors to remember different commands for Flutter, Python, Supabase, and future services. The repository command layer is the official abstraction boundary that makes that possible.
