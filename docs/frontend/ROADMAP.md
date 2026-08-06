# Engineering Review: MentorinAja Frontend Roadmap

==================================================
1. Executive Summary
==================================================

The current frontend roadmap captures the high-level product vision but fails as a production-grade engineering plan. It treats software development as a linear sequence of feature implementations, entirely omitting the non-functional requirements (NFRs), operational readiness, testing strategies, and cross-cutting concerns necessary to ship a stable, multi-platform Flutter application. 

Critical infrastructure components such as environment management (flavors), observability, feature flags, and automated deployment pipelines are missing. Furthermore, architectural dependencies are inverted; for example, offline caching and realtime synchronization are placed in Phase 5, despite these features fundamentally dictating the design of the data and repository layers which must be established in Phase 1. 

==================================================
2. Overall Score
==================================================

4 / 10

==================================================
3. Strengths
==================================================

- Identifies appropriate modern Flutter tooling (Riverpod, GoRouter).
- Adopts a logical product progression from onboarding to core learning, then advanced AI features.
- Aligns with the Clean Architecture and Feature-first structure mandated by the architecture documents.
- Recognizes the need for distinct engines (Course, Lesson, Quiz, Voice, Camera).

==================================================
4. Weaknesses
==================================================

- **Late Architectural Decisions:** Deferring offline caching and realtime sync to Phase 5 will require a massive rewrite of the repository and state management layers built in Phases 2 and 3.
- **Zero Observability:** No mention of crash reporting, performance monitoring, or analytics.
- **Missing CI/CD Depth:** Mentions GitHub actions for build and test, but lacks deployment automation (Fastlane), provisioning, and release management.
- **Lack of Defensive Engineering:** No tasks for handling degraded networks, expired tokens, permission denials, or API timeouts.
- **Missing Quality Gates:** QA is treated as an afterthought in Phase 6, rather than a continuous process utilizing Golden tests, integration tests, and accessibility checks throughout every sprint.

==================================================
5. Missing Engineering Work
==================================================

- **Environment Management:** Setup for Dev, Staging, and Production environments (Flutter Flavors, varying API base URLs, separate Firebase/Supabase projects).
- **Feature Flags:** Implementation of a remote config system to toggle risky features (like the Voice Engine or Camera Engine) without requiring an app update.
- **Security:** Implementation of Flutter Secure Storage for tokens, certificate pinning (if required), and code obfuscation (ProGuard/R8) for release builds.
- **Observability:** Integration of Sentry or Crashlytics for crash reporting, and Datadog or Firebase Performance for rendering and network latency monitoring.
- **State Restoration:** Engineering work to ensure the app recovers gracefully if killed by the OS while in the background.

==================================================
6. Missing Product Work
==================================================

- **Analytics Taxonomy:** Defining and implementing event tracking (e.g., "Lesson Started", "Voice Interaction Failed") to measure product success.
- **Legal and Compliance:** Implementation of Terms of Service, Privacy Policy, and data deletion requests (required for App Store/Play Store approval).
- **Feedback Loops:** In-app mechanisms for users to report bugs or provide feedback on AI tutor quality.

==================================================
7. Missing UX Work
==================================================

- **Error and Empty States:** Designing and implementing localized, user-friendly error screens, skeleton loaders for data fetching, and empty states for the dashboard.
- **Permission UX:** Pre-permission rationale screens (explaining *why* the app needs the microphone or camera before triggering the OS prompt).
- **Accessibility (a11y):** Ensuring Semantics widgets are used, contrast ratios are checked, and dynamic text scaling is supported across all screens.
- **Responsive Breakpoints:** Explicitly defining layout behavior for Windows (desktop) vs. Mobile, ensuring navigation patterns (e.g., Navigation Rail vs. Bottom Navigation) adapt correctly.

==================================================
8. Missing QA Work
==================================================

- **Test Data Management:** Creating mock data environments or interceptors to test UI without relying on a live backend.
- **Visual Regression Testing:** Implementing Golden tests for critical UI components to prevent layout regressions.
- **Performance Profiling:** Measuring UI jank, memory leaks, and app startup time on low-end Android devices.
- **Accessibility Audits:** Running automated and manual screen reader testing (TalkBack/VoiceOver).

==================================================
9. Missing Documentation
==================================================

- **Architecture Decision Records (ADRs):** Documenting why specific technical choices are made during development.
- **API Contracts:** Documenting the expected JSON structures and error codes from the FastAPI backend.
- **Release Runbooks:** Step-by-step guides for deploying to the App Store, Play Store, and Windows Store.

==================================================
Design Review
==================================================

The current roadmap allocates "Implementasi Design System (Tahap Awal)" inside Phase 1. This is fundamentally flawed for a professional team. 

Dedicated phases or explicit epics must exist for Branding, Splash Screen, Welcome Screen, Design Tokens, Theme System, Component Library, Responsive Design, Motion Design, App Icon, Logo, Typography, Color System, and Accessibility.

**Do these belong before authentication?**
Absolutely. You cannot build a production-grade Authentication flow without a finalized Component Library (text inputs, buttons, error banners), Design Tokens (spacing, colors), and Theme System (dark/light mode). Building UI before the design system is stabilized guarantees technical debt, requiring engineers to refactor raw Hex codes and hardcoded paddings into theme extensions later. The Splash Screen and Welcome Screen are chronologically the first things a user sees and the first routing states an app processes; they must be built before the login screen.

==================================================
Phase-by-Phase Evaluation
==================================================

### Phase 1: Pondasi & Infrastruktur Dasar
1. **Purpose:** Establish the technical foundation.
2. **Deliverables:** Flutter project, linting, routing, state management, basic UI components, HTTP client.
3. **Missing work:** Flutter Flavors (Environments), Feature Flags, Secure Storage, Observability setup, Localization (l10n) setup.
4. **Wrong priorities:** Trying to build UI components before establishing the Theme implementation and Design Tokens.
5. **Better ordering:** Setup CI/CD, Environments, and Observability first. Then Design Tokens. Then Component Library.
6. **Risks:** Hardcoding API URLs instead of using environment variables.
7. **Technical debt:** Skipping robust error handling interceptors in Dio.
8. **Dependencies:** Backend environments must be ready.
9. **Acceptance Criteria:** App compiles on iOS, Android, and Windows in Dev, Stg, and Prod flavors.
10. **Definition of Done:** CI pipeline successfully runs lint, unit tests, and builds artifacts for all platforms.
11. **Exit Criteria:** Core architecture is reviewed and approved by the Principal Architect.
12. **Recommended improvements:** Break this into two phases: "Project Initiation & DevOps" and "Design System & Core Architecture".

### Phase 2: Autentikasi, Profil & Onboarding
1. **Purpose:** User entry and personalization.
2. **Deliverables:** Supabase Auth, Sign In/Up UI, Onboarding flow, Settings.
3. **Missing work:** Token refresh logic, biometric login (optional but standard), offline handling for returning users, logout logic clearing secure storage.
4. **Wrong priorities:** Lumping Settings in with Auth. Settings rely heavily on local persistence which needs to be robust.
5. **Better ordering:** Implement Secure Storage and local caching first, then Auth state management, then UI.
6. **Risks:** Mishandling token expiration leading to silent API failures.
7. **Technical debt:** Storing tokens in SharedPreferences instead of Flutter Secure Storage.
8. **Dependencies:** Supabase Auth configuration.
9. **Acceptance Criteria:** User can register, login, close the app, and return without logging in again.
10. **Definition of Done:** Auth flows covered by integration tests. 
11. **Exit Criteria:** Auth state securely persists across app restarts.
12. **Recommended improvements:** Add specific tasks for handling deep links (e.g., password reset emails).

### Phase 3: Mesin Pembelajaran (Course, Lesson, & Quiz Engine)
1. **Purpose:** Core learning experience delivery.
2. **Deliverables:** Course map, active learning UI, coding workspace, practice/quiz UI.
3. **Missing work:** Skeleton loaders, error boundaries, state restoration, pagination for large course lists, syntax highlighting performance tuning.
4. **Wrong priorities:** Building the UI without integrating the offline caching strategy first.
5. **Better ordering:** Define the local database schema (Drift) for courses before building the UI, so the UI consumes the local cache reactively.
6. **Risks:** UI thread jank when rendering large Markdown files or syntax-highlighted code blocks.
7. **Technical debt:** Tightly coupling UI widgets directly to network calls instead of a repository pattern.
8. **Dependencies:** API contracts for Course/Lesson structures.
9. **Acceptance Criteria:** User can navigate a course, view code, and complete a quiz.
10. **Definition of Done:** Edge cases (network loss mid-quiz) are handled and tested.
11. **Exit Criteria:** Core learning loop is fully functional.
12. **Recommended improvements:** Add telemetry tracking for lesson start, completion, and drop-off points.

### Phase 4: Tutor AI & Interaksi Suara (Voice Engine)
1. **Purpose:** Implement the AI differentiator.
2. **Deliverables:** Chat UI, Mic permissions, VAD, STT, TTS, Barge-in.
3. **Missing work:** Audio focus management (interruptions from phone calls), handling permission denials gracefully, optimizing audio buffer sizes, fallback to text mode on slow networks.
4. **Wrong priorities:** Attempting Barge-in before solidifying basic STT/TTS latency handling.
5. **Better ordering:** Build robust text chat first. Then add TTS. Then add STT. Finally, implement Barge-in.
6. **Risks:** Unacceptable latency destroying the conversational UX; OS killing the audio process.
7. **Technical debt:** Putting audio processing logic in UI controllers instead of isolated background services.
8. **Dependencies:** ProviderGateway backend endpoints for streaming audio.
9. **Acceptance Criteria:** User can hold a continuous voice conversation with sub-second perceived latency.
10. **Definition of Done:** Graceful degradation to text is verified.
11. **Exit Criteria:** Voice engine is stable across all target platforms.
12. **Recommended improvements:** Wrap this entire feature in a remote Feature Flag.

### Phase 5: Fitur Opsional & Peningkatan UX
1. **Purpose:** Add secondary features and polish.
2. **Deliverables:** Camera Engine, Progress/Badges, Offline Cache, Realtime Sync.
3. **Missing work:** Analytics integration, performance profiling, responsive layout audits.
4. **Wrong priorities:** Offline Cache and Realtime Sync cannot be retrofitted in Phase 5. They dictate the data architecture and must be in Phase 1/3.
5. **Better ordering:** Move Offline Cache to Phase 1/3. Move Camera Engine to a post-launch epic (it is too risky for V1 stabilization).
6. **Risks:** Camera ML models causing severe battery drain or thermal throttling.
7. **Technical debt:** Rewriting repositories to support Drift/SQLite late in the project.
8. **Dependencies:** Supabase Realtime setup.
9. **Acceptance Criteria:** Progress synchronizes across two devices in real-time.
10. **Definition of Done:** Memory profiling shows no leaks from the camera stream.
11. **Exit Criteria:** Features are functional and do not degrade core app performance.
12. **Recommended improvements:** Drop Camera Engine from V1 MVP to focus on stability.

### Phase 6: Stabilisasi & Peluncuran V1
1. **Purpose:** Launch preparation.
2. **Deliverables:** QA, Performance optimization, Build configuration, Launch.
3. **Missing work:** Code obfuscation, store asset generation, privacy manifests (iOS), app signing, Fastlane setup, UAT (User Acceptance Testing).
4. **Wrong priorities:** QA should not begin here. QA must be continuous. This phase should only be for UAT and Hardening.
5. **Better ordering:** Setup CI/CD deployment pipelines earlier.
6. **Risks:** App Store rejection due to missing privacy disclosures regarding AI and microphone usage.
7. **Technical debt:** Manual deployment processes.
8. **Dependencies:** Developer accounts (Apple, Google, Microsoft).
9. **Acceptance Criteria:** App passes App Store and Play Store review.
10. **Definition of Done:** Production builds are signed, obfuscated, and uploaded to stores.
11. **Exit Criteria:** App is live.
12. **Recommended improvements:** Rename to "Release Preparation & Launch". Include a phased rollout strategy.

==================================================
10. Suggested New Phase Order
==================================================

- **Phase 0:** Project Initiation, Tooling, Environments & CI/CD
- **Phase 1:** Design System, Component Library & Core Architecture (including Offline Strategy)
- **Phase 2:** Authentication, Security & User Onboarding
- **Phase 3:** Core Learning Engine (Course, Lesson, Quiz) & Telemetry
- **Phase 4:** AI & Voice Integration (Feature Flagged)
- **Phase 5:** Hardening, Observability, QA & A11y Audits
- **Phase 6:** Release Preparation, App Store Compliance & Launch
- **Post-V1 Epic:** Camera Engine & Realtime Collaboration

==================================================
11. Suggested Milestones
==================================================

- **Milestone 1 (Architecture Complete):** End of Phase 1. CI/CD flows, all environments provisioned, Design System implemented.
- **Milestone 2 (Alpha):** End of Phase 3. Core text-based learning loop is functional. Internal team testing begins.
- **Milestone 3 (Beta):** End of Phase 4. Voice AI integrated. Distributed to external beta testers via TestFlight/Firebase App Distribution.
- **Milestone 4 (Release Candidate):** End of Phase 5. Zero P1/P2 bugs. Feature freeze.
- **Milestone 5 (General Availability - GA):** End of Phase 6. Live in stores.

==================================================
12. Suggested Sprint Breakdown
==================================================

Assuming 2-week sprints:
- **Sprint 1-2:** Phase 0 & 1 (DevOps, Architecture, Design System)
- **Sprint 3-4:** Phase 2 (Auth, Secure Storage, Onboarding)
- **Sprint 5-7:** Phase 3 (Course Engine, Offline Caching, Quiz Logic)
- **Sprint 8-10:** Phase 4 (AI Voice Pipeline, Audio Focus, Permissions)
- **Sprint 11-12:** Phase 5 (Hardening, Golden Tests, Observability)
- **Sprint 13:** Phase 6 (App Store Submission, Phased Rollout)

==================================================
13. Suggested MVP Scope
==================================================

To ensure a successful and stable V1 launch, the MVP scope must be aggressively reduced:
- **Include:** Auth, Python Course rendering, Code Workspace, Text-based AI Chat, Voice AI Pipeline (Core interaction), Offline Cache for static content.
- **Exclude (Move to V1.x or V2):** Camera Engine (Attention detection), Realtime Sync across multiple active devices, Social Login (launch with Email/Password only), Complex Badging systems.

==================================================
14. Suggested Versioning Plan
==================================================

Utilize strict Semantic Versioning (SemVer):
- `0.1.0 - 0.4.0`: Alpha builds (Internal distribution, core features).
- `0.5.0 - 0.8.0`: Beta builds (External testing, voice engine integration).
- `0.9.0 - 0.9.9`: Release Candidates (Hardening, bug fixes only).
- `1.0.0`: Initial Launch.
- `1.1.0`: Introduction of Realtime Sync.
- `1.2.0`: Introduction of Camera Engine.

==================================================
15. Suggested Release Plan
==================================================

1. **Internal Dogfooding:** App distributed to the development team via Firebase App Distribution.
2. **Closed Beta:** Distributed via Apple TestFlight and Google Play Console Internal Testing to a selected group of students.
3. **App Store Review:** Submit 2 weeks prior to planned launch to accommodate inevitable rejections regarding AI moderation or microphone usage privacy policies.
4. **Phased Rollout:** Launch at 10% adoption on Google Play to monitor crash rates (Crashlytics) and voice latency (Firebase Performance) before expanding to 100%.
5. **Windows Launch:** Follow mobile launch by 2-4 weeks to allow stabilization of the primary mobile platforms.

==================================================
16. Final Recommendations
==================================================

1. **Mandate a Definition of Done (DoD):** No feature is complete without unit tests, widget tests, localized strings, error states, and telemetry tracking implemented.
2. **Shift-Left Architecture:** Move the data caching strategy and state restoration out of Phase 5 and into the core architecture phase immediately. You cannot bolt-on offline persistence to a reactive Flutter application late in the lifecycle.
3. **Embrace Feature Flags:** The Voice Engine is a high-risk feature. Implement a remote feature flag immediately so that if STT/TTS latency is unacceptable in production, the app can instantly degrade to text-only mode without a store update.
4. **Prioritize Observability:** Do not write a single UI widget until Crashlytics and custom logging (e.g., `Talker` or `Logger`) are implemented and forwarding to the backend. You cannot fix voice latency or state bugs if you cannot measure them in the wild.
