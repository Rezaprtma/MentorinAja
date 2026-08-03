# Nerove Tutor — Product Requirements Document

**Document type:** Engineering-grade PRD
**Status:** Draft v1.0
**Audience:** Founding engineering team (mobile, backend, AI, DevOps), design, and future contributors
**Scope:** Version 1 (Python course, Android/iOS/Windows) through architectural provisions for V2–V5

---

## Table of Contents

1. Executive Summary
2. Vision
3. Product Goals
4. Product Scope
5. User Personas
6. User Journey
7. Functional Requirements
8. Non-Functional Requirements
9. Complete System Architecture
10. Module Architecture
11. Voice Architecture
12. Camera Architecture
13. AI Tutor Architecture
14. Learning Engine
15. Database Design
16. API Overview
17. State Management
18. UI/UX Guidelines
19. Recommended Libraries
20. Folder Structure
21. Security
22. Performance Targets
23. Risks
24. Engineering Principles
25. Testing Strategy
26. Future Roadmap (V1–V5)
27. Appendix

---

## 1. Executive Summary

Nerove Tutor is an AI-powered, voice-first personal tutoring application. It is not a chat interface wrapped around a language model — it is a structured teaching system in which an LLM is constrained, prompted, and orchestrated to behave like a professional one-on-one tutor: it teaches in sequence, checks understanding, remembers what a student has and hasn't mastered, adapts its explanations, and proactively manages the pacing of a lesson.

Version 1 ships a single flagship course — **Python Programming** — across Android, iOS, and Windows, built on Flutter (client), FastAPI/Python (backend), and Supabase (database, auth, realtime). The system is deliberately scoped for a small initial user base, but every architectural decision in this document is made so that the platform can scale to millions of users and additional courses without a rewrite — not by pre-building infrastructure it doesn't need yet, but by keeping the seams (course content, LLM provider, storage, auth) cleanly abstracted from day one.

The two features that differentiate Nerove Tutor from a generic AI chatbot are:

- **Low-latency streaming voice conversation** — the primary interaction mode, designed so the AI begins speaking before it has finished "thinking."
- **A structured, gated learning engine** — Course → Chapter → Lesson → Practice → Quiz → Next Lesson — where progress is persisted, mastery is tracked, and the AI's behavior is shaped by exactly where the student is in that structure.

A secondary, strictly opt-in feature — camera-based attention/drowsiness detection — allows the AI to notice when a student is disengaged and respond like a human tutor would ("You look tired — want a short break?"), without recording or uploading video.

This document specifies the product, architecture, data model, libraries, UI/UX direction, and engineering standards required for a team to begin implementation.

## 2. Vision

**Nerove Tutor gives every student a private, patient, endlessly available teacher — not a search box.**

The test for every feature in this product is: *"Would a great human private tutor do this?"* A good tutor doesn't wait passively for the perfect question. They teach in order, notice confusion before it's voiced, revisit weak spots without being asked, and adjust their language to the student in front of them. Nerove Tutor's AI Tutor persona is designed against that bar, not against the bar of "answer the user's message well," which is the bar a generic chatbot is held to.

Long-term, the vision extends beyond Python: Nerove Tutor becomes a course-agnostic tutoring engine — the same structured-learning-plus-voice-plus-attention architecture applied to languages, math, test prep, and professional skills — but V1 proves the model end-to-end on a single course.

## 3. Product Goals

| # | Goal | Why it matters |
|---|------|-----------------|
| G1 | Deliver a tutoring experience distinguishable from a chatbot within the first 5 minutes of use | This is the core product bet; if a first-time user can't tell the difference, the product has failed regardless of technical quality |
| G2 | Voice interaction latency low enough to feel like a live conversation, not a walkie-talkie exchange | Voice is the primary interaction mode — high latency breaks the illusion entirely |
| G3 | Structured, non-skippable course progression with durable progress tracking | Enables real pedagogy (prerequisites, spaced review) instead of ad-hoc Q&A |
| G4 | Application remains lightweight and responsive on low-end Android devices | Target users are not guaranteed to own flagship hardware |
| G5 | Architecture supports additional courses and platforms without structural rewrites | V1 is one course by scope decision, not by architectural limitation |
| G6 | Privacy-first handling of any sensitive input (camera, voice, conversation history) | Camera and always-listening voice are trust-sensitive by nature; trust must be earned by design, not policy alone |
| G7 | Premium, calm, modern visual identity comparable to Duolingo/Khan Academy/Coursera-tier products | Perceived quality drives retention as much as functional quality in consumer edtech |

## 4. Product Scope

### 4.1 In Scope — Version 1

- Single course: **Python Programming**, structured as Chapters → Lessons → Practice → Quizzes
- Platforms: Android, iOS, Windows (single Flutter codebase)
- Voice-first conversational AI tutor (streaming STT → LLM → TTS)
- Text-based fallback/parallel interaction (typing is always available)
- Coding workspace with collapsible sidebar (example code, explanations, notes, syntax highlighting)
- Progress tracking, gated lesson unlocking, quiz evaluation
- Optional, off-by-default camera-based attention/drowsiness detection (no storage, no upload)
- Authentication (Supabase Auth) and user profiles
- Conversation history persistence
- Basic achievement/progress indicators
- Offline cache for downloaded lesson content
- Realtime sync of progress across devices

### 4.2 Out of Scope — Version 1

- Monetization, billing, subscription tiers (architecture must not preclude them later — see §26)
- Any course other than Python
- macOS, Linux, Web clients (architecture must not preclude them later)
- Multiplayer/social/classroom features
- Region-specific compliance certification (GDPR/COPPA/etc.) — general privacy-first practice only, not formal certification
- Video/audio recording storage of any kind
- Admin web dashboard (a minimal internal admin capability is assumed to exist for content management, but a polished admin product is out of scope)

### 4.3 Explicit Non-Goals

- Nerove Tutor will **not** attempt to be a general-purpose assistant. Off-syllabus questions are handled gracefully (see §13) but the product does not compete with ChatGPT/Gemini as a general chatbot.
- Nerove Tutor will **not** use camera data for proctoring, identity verification, or any surveillance-adjacent purpose.

---

## 5. User Personas

### Persona A — "The Career-Switcher" (primary)
- Adult, 22–35, learning Python to move into tech from a non-technical background.
- Studies in short, fragmented sessions (commute, lunch break, evening).
- Low tolerance for confusing error messages; needs analogies, not jargon.
- Motivated by visible progress; drops off quickly if stuck without help.
- Primary device: mid-range Android phone.

**Needs:** step-by-step pacing, patient re-explanation, low-friction voice interaction while multitasking, clear "what's next."

### Persona B — "The CS Student" (secondary)
- 18–24, enrolled in or adjacent to formal computer science education.
- Uses Nerove Tutor to supplement coursework — reinforcing concepts, practicing problems, getting unstuck.
- More tolerant of technical depth; wants faster pacing and the ability to skip material they already know (once unlocked).
- Primary device: laptop (Windows) or higher-end phone.

**Needs:** accurate technical depth, code-reading tools (coding workspace), quiz rigor, minimal hand-holding once competence is demonstrated.

### Persona C — "The Curious Returner" (secondary)
- 30–50, learning to code as a hobby or for a small project, highly intermittent usage (weekly or less).
- Forgets context between sessions; needs the tutor to re-orient them.
- Sensitive to feeling embarrassed by "dumb questions" — needs a warm, non-judgmental tone.

**Needs:** strong session-to-session memory/recap, encouragement, low-pressure pacing.

All three personas share one hard requirement: **the tutor must remember them.** A chatbot that starts from zero every session fails all three.

## 6. User Journey

### 6.1 First-Time Journey (Day 0)
1. Download app → sign up (Supabase Auth: email or OAuth).
2. Brief onboarding: name, learning goal, prior experience level (none/some/returning).
3. Onboarding answers seed initial pacing for Chapter 1, Lesson 1 (not a full placement test — see §26 for V2+).
4. App opens directly into Lesson 1 — no empty dashboard. The tutor greets the student and begins teaching immediately.
5. Student completes a first micro-lesson + practice + a short quiz (2–3 questions) within the first session, delivering an early "completion" moment.
6. Progress updates, next lesson unlocks, session ends naturally when the student stops responding or exits.

### 6.2 Returning Session Journey
1. App reopens directly to "Continue where you left off"; a full course map is available but not the default landing state.
2. Tutor opens with a short recap grounded in actual history ("Last time we covered functions, and you were mixing up return vs. print — want a 1-minute refresher?").
3. Student proceeds through the next lesson/practice/quiz, or asks to revisit a prior topic.
4. If camera is enabled and disengagement/drowsiness is detected, the tutor offers a break instead of continuing to push content.

### 6.3 Struggling Student Journey
1. Student repeatedly answers incorrectly or asks for re-explanation.
2. The AI Tutor detects the pattern via Practice/Quiz Engine signals (not sentiment guessing) and switches strategy — simpler analogy, smaller sub-steps, worked example — rather than repeating the same explanation verbatim.
3. If mastery still isn't reached, the lesson is flagged for spaced review; the gate does not unlock until a minimum competency threshold is met.

### 6.4 Session End
Student exits or goes idle. The Progress Engine persists lesson position, quiz results, mistake log, and a short session summary used to seed the next session's recap.

---

## 7. Functional Requirements

Each module below follows a consistent template: **Description, Purpose, Priority, Acceptance Criteria, Dependencies, Edge Cases, Failure Scenarios, Future Scalability, Engineering Notes.** Priority uses MoSCoW (Must/Should/Could/Won't — for V1).

### 7.1 Authentication
- **Description:** Sign up, sign in, sign out, session refresh, password reset, OAuth (Google/Apple).
- **Purpose:** Secure identity so progress and conversation history persist per user across devices.
- **Priority:** Must
- **Acceptance Criteria:** User can register with email/password or OAuth; session persists across app restarts; token refresh is transparent; sign-out clears local cache of sensitive data.
- **Dependencies:** Supabase Auth, Secure local token storage.
- **Edge Cases:** Expired refresh token mid-session; duplicate email sign-up attempt; OAuth provider returns partial profile data.
- **Failure Scenarios:** Auth service unreachable → app falls back to cached read-only mode with a clear banner, no silent failure.
- **Future Scalability:** Add SSO/enterprise auth (SAML) for Team/Enterprise tier without touching client auth interface (abstracted behind an `AuthRepository`).
- **Engineering Notes:** No custom credential storage or password handling — delegate entirely to Supabase Auth to minimize security surface area.

### 7.2 User Profile
- **Description:** Name, avatar, learning goal, experience level, preferences.
- **Purpose:** Personalization input for the AI Tutor and onboarding.
- **Priority:** Must
- **Acceptance Criteria:** Profile editable post-onboarding; changes reflected in next AI Tutor session context.
- **Dependencies:** Authentication, Database.
- **Edge Cases:** Incomplete onboarding (app closed mid-flow) — must resume, not restart.
- **Failure Scenarios:** Profile write fails — retry with local optimistic cache, sync on reconnect.
- **Future Scalability:** Extendable schema for multi-course goal-setting.
- **Engineering Notes:** Store as a flexible JSONB "preferences" column plus first-class columns for frequently-queried fields (see §15).

### 7.3 Course Engine
- **Description:** Manages course/chapter/lesson definitions and structure metadata.
- **Purpose:** Single source of truth for what content exists and how it's sequenced.
- **Priority:** Must
- **Acceptance Criteria:** Course structure loads correctly for Python V1; content model supports adding a second course with zero schema changes.
- **Dependencies:** Database, Content authoring (internal, out of polished-tooling scope for V1).
- **Edge Cases:** Chapter with zero lessons; lesson referencing a deleted quiz.
- **Failure Scenarios:** Malformed course JSON — validated at content-ingestion time, not at runtime, to prevent broken states reaching students.
- **Future Scalability:** Course is a top-level entity with a `subject` field from day one — multi-course support requires no migration, only new content rows.
- **Engineering Notes:** Course content is data, not code — never hardcode Python-specific logic into the Course Engine itself; language-specific behavior lives in lesson metadata (e.g., `language: python` for syntax highlighting).

### 7.4 Lesson Engine
- **Description:** Delivers individual lesson content, tracks position within a lesson, coordinates with AI Tutor for teaching flow.
- **Purpose:** The unit of teaching; bridges static content and dynamic AI explanation.
- **Priority:** Must
- **Acceptance Criteria:** Lesson state (not-started/in-progress/completed) persists; resuming mid-lesson restores AI conversational context correctly.
- **Dependencies:** Course Engine, AI Tutor, Progress Engine.
- **Edge Cases:** Student exits mid-explanation; network drop mid-lesson.
- **Failure Scenarios:** AI Tutor unavailable — lesson content (non-AI parts: text, examples) still viewable read-only.
- **Future Scalability:** Lesson types are pluggable (concept, code-along, discussion) to support non-Python subjects later.
- **Engineering Notes:** Lesson state transitions are explicit and persisted after every meaningful step, not just at lesson completion — protects against data loss on crash.

### 7.5 Practice Engine
- **Description:** Low-stakes exercises between teaching and quiz — coding prompts, fill-in-the-blank, prediction questions.
- **Purpose:** Active recall before formal evaluation; primary signal for "is this student ready for the quiz."
- **Priority:** Must
- **Acceptance Criteria:** Practice attempts are evaluated (AI or rule-based) with feedback in under the target latency (§22); repeated failure triggers AI strategy change (§6.3).
- **Dependencies:** AI Tutor, Coding Workspace, Progress Engine.
- **Edge Cases:** Ambiguous open-ended code answer with multiple valid solutions.
- **Failure Scenarios:** AI evaluation service down — queue attempt, show "checking..." rather than falsely marking incorrect.
- **Future Scalability:** Practice item types are schema-driven, enabling new exercise formats without client updates.
- **Engineering Notes:** Practice is never gating (doesn't block progression) — only quizzes gate. This keeps practice low-pressure by design.

### 7.6 Quiz Engine
- **Description:** Formal, gating assessment at the end of a lesson/chapter.
- **Purpose:** Objective checkpoint determining whether the next lesson unlocks.
- **Priority:** Must
- **Acceptance Criteria:** Quiz score computed deterministically; passing threshold configurable per lesson; failed quiz offers targeted review, not just "try again."
- **Dependencies:** Course Engine, Progress Engine, AI Tutor (for generated/varied questions).
- **Edge Cases:** Student retakes quiz immediately — question set should vary to avoid pure memorization where AI-generated question banks are used.
- **Failure Scenarios:** Grading service failure — do not silently pass or fail the student; block gate with a clear retry state.
- **Future Scalability:** Supports AI-generated question pools per lesson, seeded but not hardcoded, enabling infinite retakes without repetition.
- **Engineering Notes:** Quiz results are the primary structured signal fed back into the AI Tutor's context — treat as first-class data, not just a UI score.

### 7.7 AI Tutor
See §13 for full architecture. Functional summary:
- **Description:** Orchestration layer that turns LLM calls into tutoring behavior — teaching, evaluating, encouraging, adapting, recommending.
- **Purpose:** The product's core differentiator.
- **Priority:** Must
- **Acceptance Criteria:** Behaves per the tutor persona and behavioral contract (§13.2) in blind evaluation against a chatbot baseline.
- **Dependencies:** Voice Engine, Lesson/Practice/Quiz Engines, Conversation History, Progress Engine.
- **Edge Cases:** Off-syllabus question mid-lesson; student asks the AI to "just give the answer."
- **Failure Scenarios:** LLM provider outage — graceful degradation to cached lesson content + a clear "Tutor is temporarily unavailable" state, never a hard crash.
- **Future Scalability:** Provider-agnostic via an abstraction layer (§9.4) — swapping or multi-sourcing LLM providers requires no changes above that layer.
- **Engineering Notes:** System prompt + retrieved student context is reconstructed per-turn from structured state (Progress Engine, mistake log), not from replaying raw chat history — keeps context accurate and bounded regardless of session length.

### 7.8 Voice Engine (orchestration layer)
See §11 for full architecture.
- **Description:** Coordinates microphone capture, VAD, STT, LLM streaming, TTS, and audio playback as one low-latency pipeline.
- **Purpose:** Primary interaction modality.
- **Priority:** Must
- **Acceptance Criteria:** End-to-end perceived latency (silence-to-first-audio) meets targets in §22.
- **Dependencies:** STT, TTS, AI Tutor, device microphone/speaker permissions.
- **Edge Cases:** Background noise triggering false VAD positives; student interrupts AI mid-response ("barge-in").
- **Failure Scenarios:** Network degradation mid-utterance — buffer and resume rather than drop; fallback to text mode if voice pipeline repeatedly fails.
- **Future Scalability:** Pipeline stages are independently swappable (e.g., on-device STT for offline mode in a later version).
- **Engineering Notes:** Barge-in (interrupting the AI) must be supported from V1 — it is core to feeling like a real conversation, not a nice-to-have.

### 7.9 Speech-to-Text (STT)
- **Description:** Converts streamed microphone audio into text incrementally.
- **Purpose:** Input half of the voice pipeline.
- **Priority:** Must
- **Acceptance Criteria:** Partial transcripts stream with low incremental latency; final transcript corrects partials without visible jank.
- **Dependencies:** VAD, chosen STT provider/library (§19).
- **Edge Cases:** Accented speech, technical vocabulary ("def", "lambda", "boolean") misrecognized.
- **Failure Scenarios:** STT provider timeout — surface a retry affordance, don't hang silently.
- **Future Scalability:** Domain-adapted vocabulary/boosting for programming terms as a V2 refinement.
- **Engineering Notes:** Feed a custom vocabulary/boost list of Python keywords to the STT provider where supported to reduce technical-term misrecognition.

### 7.10 Text-to-Speech (TTS)
- **Description:** Converts streaming LLM text output into streamed audio.
- **Purpose:** Output half of the voice pipeline; must start speaking before generation completes.
- **Priority:** Must
- **Acceptance Criteria:** Audio begins playing within target latency (§22) of first sentence-worth of text; voice is natural and non-robotic.
- **Dependencies:** AI Tutor streaming output, chosen TTS provider/library (§19).
- **Edge Cases:** Code snippets read aloud (should be summarized/described, not character-by-character spelled out, unless asked).
- **Failure Scenarios:** TTS failure mid-response — fall back to text display of the remaining response.
- **Future Scalability:** Swappable voice profiles/personas per future course or user preference.
- **Engineering Notes:** Sentence-boundary chunking (not fixed-token chunking) for TTS input to avoid mid-word audio artifacts; see §11.

### 7.11 Camera Engine
See §12 for full architecture.
- **Description:** On-device face/eye/attention analysis from live camera frames.
- **Purpose:** Detect drowsiness/disengagement to let the AI proactively offer breaks, like a human tutor would notice.
- **Priority:** Should (V1: functional but explicitly optional and off by default)
- **Acceptance Criteria:** Off by default; explicit opt-in required; no frame or video ever leaves the device or touches disk.
- **Dependencies:** Device camera permission, on-device CV library (§19).
- **Edge Cases:** Multiple faces in frame; poor lighting; camera occluded.
- **Failure Scenarios:** CV pipeline failure — degrade silently to "camera off" state, never crash the lesson.
- **Future Scalability:** Pipeline abstracted so detection models can be upgraded independently of the rest of the app.
- **Engineering Notes:** Frame sampling rate must be throttled (not full framerate inference) — see §12.6 for battery/performance approach.

### 7.12 Sleep/Attention Detection
- **Description:** Derives a drowsy/distracted signal from Camera Engine outputs (eye aspect ratio, blink rate, head pose) and emits an event to the AI Tutor.
- **Purpose:** Converts raw CV signal into an actionable, rate-limited tutoring event.
- **Priority:** Should
- **Acceptance Criteria:** Sustained (not momentary) signal required before triggering; AI response is natural, not repeated nagging.
- **Dependencies:** Camera Engine, AI Tutor.
- **Edge Cases:** Student legitimately looks away to think — must not misfire on brief gaze shifts.
- **Failure Scenarios:** Over-triggering — mitigated via debounce/cooldown window (§12.7).
- **Future Scalability:** Signal contributes to a broader engagement score usable by future analytics.
- **Engineering Notes:** This is a wellbeing nudge, not a discipline mechanism — copy and AI tone must always read as supportive, never as being "caught."

### 7.13 Progress Engine
- **Description:** Tracks lesson/chapter completion, quiz scores, mistake log, mastery state, gating logic.
- **Purpose:** Source of truth for "where is this student and what do they know."
- **Priority:** Must
- **Acceptance Criteria:** Progress persists durably and syncs across devices in near-real-time; gating logic is enforced server-side, not just client-side.
- **Dependencies:** Database, Realtime Sync, Quiz Engine.
- **Edge Cases:** Same account active on two devices concurrently.
- **Failure Scenarios:** Sync conflict — last-write-wins at the field level with server timestamps, documented explicitly (not silently arbitrary).
- **Future Scalability:** Mastery model can evolve from simple pass/fail to spaced-repetition scoring without schema upheaval (score/timestamp fields already present).
- **Engineering Notes:** Gating must be enforced in the backend, never trusted from client state alone — prevents trivial client-side bypass.

### 7.14 Achievement Engine
- **Description:** Streaks, badges, milestones.
- **Purpose:** Motivation and retention.
- **Priority:** Could (V1: minimal set — streak counter, chapter-completion badges)
- **Acceptance Criteria:** Achievements computed from Progress Engine events, not duplicated state.
- **Dependencies:** Progress Engine.
- **Edge Cases:** Timezone edge cases for streak calculation.
- **Failure Scenarios:** Achievement compute failure never blocks core learning flow.
- **Future Scalability:** Rule-based engine can expand to a full achievement catalog without redesign.
- **Engineering Notes:** Keep decoupled from Progress Engine (event-driven) so it can be disabled/AB-tested independently.

### 7.15 Coding Workspace
See §18.4 for UI detail.
- **Description:** Collapsible sidebar with example code, explanation, notes, and syntax highlighting, synchronized with the live conversation.
- **Purpose:** Programming needs a visual code surface — voice/text alone is insufficient for teaching syntax.
- **Priority:** Must
- **Acceptance Criteria:** AI can reference specific line numbers verbally/textually and the workspace highlights the referenced line; sidebar state persists per lesson.
- **Dependencies:** AI Tutor, Lesson Engine, code editor/highlighting library (§19).
- **Edge Cases:** Very long code examples on small screens.
- **Failure Scenarios:** Highlighting sync failure — code still displays correctly, just without line-following.
- **Future Scalability:** Same component reusable for future non-Python languages via language-mode configuration.
- **Engineering Notes:** The AI's structured output includes explicit line references (not inferred from free text) — see §13.4.

### 7.16 Conversation History
- **Description:** Persisted log of tutoring conversations, retrievable per lesson/session.
- **Purpose:** Enables session recap, review, and AI long-term memory grounding.
- **Priority:** Must
- **Acceptance Criteria:** History is searchable/scrollable per lesson; used to generate accurate "last time" recaps.
- **Dependencies:** Database, AI Tutor.
- **Edge Cases:** Very long-running students accumulating large history — must not degrade query performance.
- **Failure Scenarios:** History write failure — never blocks the live conversation; write is asynchronous with retry.
- **Future Scalability:** History summarization pipeline (V2+) compresses old sessions into durable "memory" records rather than growing an unbounded transcript (see §13.5).
- **Engineering Notes:** Raw transcript and derived "memory summary" are stored as separate structures from day one to avoid a costly migration later.

### 7.17 Notification Engine
- **Description:** Local/push reminders (streak at risk, "continue your lesson").
- **Priority:** Could
- **Acceptance Criteria:** Opt-in, configurable frequency, respects OS-level notification permissions.
- **Dependencies:** Progress Engine, platform push services.
- **Edge Cases:** Notification permission denied — feature degrades silently, no repeated prompting.
- **Failure Scenarios:** Push service outage — non-critical, no retry storm.
- **Future Scalability:** Rule-based triggers extendable for future course-specific nudges.
- **Engineering Notes:** V1 can ship with local notifications only (no server push infrastructure required) if timeline is tight.

### 7.18 Offline Cache
- **Description:** Local cache of downloaded lesson content (text, code examples) for offline viewing.
- **Priority:** Should
- **Acceptance Criteria:** Previously visited lessons viewable without network (AI conversation itself requires connectivity — this covers static content only in V1).
- **Dependencies:** Local storage library (§19), Course Engine.
- **Edge Cases:** Stale cached content after a content update — cache versioned and invalidated on course content version bump.
- **Failure Scenarios:** Cache corruption — falls back to network fetch, cache rebuilt.
- **Future Scalability:** Full offline AI tutoring (on-device LLM) is an explicit V4+ consideration (§26), not assumed here.
- **Engineering Notes:** Cache is read-through and versioned per course content release, not per individual lesson edit, to keep invalidation logic simple.

### 7.19 Realtime Synchronization
- **Description:** Cross-device sync of progress, settings, and conversation state via Supabase Realtime (WebSocket).
- **Priority:** Must
- **Acceptance Criteria:** Progress made on one device reflects on another within a few seconds of reconnect.
- **Dependencies:** Supabase Realtime, Progress Engine.
- **Edge Cases:** Prolonged offline period with local changes — reconciled on reconnect via server-timestamp resolution.
- **Failure Scenarios:** WebSocket disconnect — falls back to polling/pull-on-resume; never blocks local usage.
- **Future Scalability:** Same channel model extends to future collaborative/classroom features.
- **Engineering Notes:** Realtime is an enhancement layer over a REST-first backend — the app must be fully functional if the WebSocket connection never establishes.

### 7.20 Settings
- **Description:** Voice on/off, camera on/off, notification preferences, TTS voice selection, appearance.
- **Priority:** Must
- **Acceptance Criteria:** All privacy-relevant toggles (camera, voice) default to the most private/off state.
- **Dependencies:** User Profile.
- **Edge Cases:** Settings change mid-session (e.g., disabling camera while active) takes effect immediately.
- **Failure Scenarios:** Settings write failure — retried, with local value as source of truth until confirmed.
- **Future Scalability:** Schema supports future per-course settings.
- **Engineering Notes:** Every privacy-relevant default is opt-in, never opt-out — see §21.

### 7.21 Analytics
- **Description:** Product usage analytics (lesson completion rates, drop-off points, latency metrics) — not behavioral surveillance of individuals for non-product purposes.
- **Priority:** Should
- **Acceptance Criteria:** Aggregate, privacy-respecting event tracking; no raw camera/voice content ever included in analytics events.
- **Dependencies:** Analytics/event pipeline (§19).
- **Edge Cases:** Analytics outage never affects core app function (fire-and-forget events).
- **Failure Scenarios:** Event loss under network failure is acceptable (best-effort, not transactional).
- **Future Scalability:** Event schema versioned from day one to support future dashboards without reprocessing.
- **Engineering Notes:** Analytics events are structured and typed, not free-text logging, to keep them queryable at scale.

### 7.22 Administration
- **Description:** Minimal internal tooling for content management (courses/chapters/lessons/quizzes) and basic user support lookups.
- **Priority:** Should (minimal, non-polished for V1)
- **Acceptance Criteria:** Content team can add/edit lessons without engineering involvement; support can look up a user's progress state to debug issues.
- **Dependencies:** Database, Authentication (role-based access).
- **Edge Cases:** Accidental destructive edit to live course content — mitigated via versioned content and soft-deletes.
- **Failure Scenarios:** Admin tool outage never affects the student-facing app (fully decoupled).
- **Future Scalability:** Foundation for a full admin web product in a later version.
- **Engineering Notes:** V1 admin can be a thin internal CLI/Supabase Studio usage rather than a bespoke UI — do not over-invest here before product-market signal exists.

---

## 8. Non-Functional Requirements

| Category | Requirement | Target / Notes |
|---|---|---|
| **Performance** | Voice round-trip latency | See §22 targets; this is the single most scrutinized NFR in the product |
| **Scalability** | Stateless backend services | FastAPI services must be horizontally scalable behind a load balancer with no in-process session state; session/context lives in Supabase/Redis, not process memory |
| **Reliability** | Graceful degradation | Every AI-dependent feature has a defined non-AI fallback state (see §7 failure scenarios); the app must never hard-crash due to an LLM/voice/camera provider outage |
| **Security** | Least-privilege data access | Row-Level Security (RLS) enforced in Supabase for all user data; no client ever reads another user's rows |
| **Maintainability** | Clean Architecture + feature-first structure | See §10, §20; a new engineer should be able to locate and modify a single feature without touching unrelated modules |
| **Accessibility** | WCAG-aligned baseline | Text scaling support, sufficient color contrast, screen-reader labels on interactive elements, captions/transcripts for AI speech (text is always shown alongside voice, never voice-only) |
| **Offline Capability** | Static content available offline | See §7.18; live AI tutoring requires connectivity in V1 |
| **Cross-Platform Compatibility** | Single Flutter codebase, platform-specific adapters isolated | Platform channels/plugins isolated behind interfaces (§9.5) so Android/iOS/Windows differences don't leak into feature code |
| **Energy Efficiency** | Camera/voice pipelines throttled | Frame sampling and audio buffer sizes tuned to avoid continuous full-rate inference (§11, §12) |
| **Memory Usage** | Responsive on low-end Android | Target: smooth operation on devices with 3GB RAM class hardware; lazy-load course content, avoid retaining full conversation history in memory |
| **Network Optimization** | Streaming over polling | WebSocket/streaming used for voice and realtime sync; REST elsewhere; payloads minimized (no full-object re-fetches for small updates) |

## 9. Complete System Architecture

### 9.1 High-Level Topology

```
┌────────────────────────┐
│   Flutter Client        │  Android / iOS / Windows
│  (Clean Architecture)   │
└───────────┬─────────────┘
            │ HTTPS (REST) + WebSocket (streaming/realtime)
┌───────────▼─────────────┐
│   FastAPI Backend        │  Stateless, horizontally scalable
│  ┌─────────────────────┐ │
│  │ Auth Middleware      │ │  Validates Supabase JWT
│  │ Tutor Orchestrator   │ │  AI Tutor logic (§13)
│  │ Voice Session Mgr    │ │  WS voice pipeline coordination (§11)
│  │ Learning Engine API  │ │  Course/Lesson/Practice/Quiz/Progress
│  └─────────────────────┘ │
└───────┬─────────┬────────┘
        │         │
        │         └────────────┐
┌───────▼────────┐   ┌─────────▼─────────┐
│   Supabase       │   │  External AI Providers │
│ (Postgres, Auth,│   │  LLM / STT / TTS         │
│  Realtime, RLS) │   │  (abstracted, §9.4)      │
└──────────────────┘   └───────────────────────┘
```

### 9.2 Why This Topology

A thin, stateless FastAPI layer sits between the Flutter client and both Supabase and external AI providers rather than letting the client talk to either directly, for three reasons:

1. **Provider abstraction.** LLM/STT/TTS vendors can be swapped or load-balanced without a client release.
2. **Business logic centralization.** Gating, quiz grading, and mistake-log construction must not be trusted to client-side logic (trivially bypassable). They live server-side.
3. **Secret custody.** API keys for AI providers never touch the client.

The client *does* talk to Supabase directly for simple CRUD/read operations protected by Row-Level Security (profile reads, course content reads, realtime subscriptions) — routing 100% of traffic through the backend would add latency and operational load for no security benefit, since Supabase RLS already enforces per-user isolation at the database layer. The backend is reserved for anything requiring orchestration, external AI calls, or gating logic.

### 9.3 Clean Architecture on the Client

Each Flutter feature is structured in three layers:

- **Presentation** — widgets, view state, no business logic.
- **Domain** — use cases, entities, repository interfaces. Pure Dart, no Flutter/Supabase imports. This is the layer that stays stable when infrastructure changes.
- **Data** — repository implementations, API clients, local cache. Implements domain interfaces.

This mirrors the same layering on the backend: **API routes → Service/use-case layer → Repository layer → External integrations (Supabase, LLM providers).** The rule in both codebases is the same: dependencies point inward: infrastructure depends on domain, domain never depends on infrastructure. This is what makes swapping Supabase, an LLM provider, or a UI toolkit later a bounded change rather than a rewrite.

### 9.4 AI Provider Abstraction

All LLM/STT/TTS calls go through a `ProviderGateway` interface with concrete implementations per vendor. Reasons this is a hard requirement, not a nice-to-have:

- Voice provider quality/cost trade-offs will need revisiting post-launch based on real usage data.
- A single point to add caching, rate limiting, retries, and cost tracking.
- Enables provider failover (secondary provider on primary outage) as a V2+ reliability upgrade without redesigning callers.

### 9.5 Platform Abstraction

Camera and microphone access differ meaningfully across Android/iOS/Windows. These are isolated behind Dart interfaces (`CameraSource`, `AudioSource`) with platform-specific implementations selected at compile/runtime, so feature code (Camera Engine, Voice Engine) never branches on platform directly.

### 9.6 Event-Driven Elements

Most of the system is request/response (REST) for simplicity and debuggability. Event-driven patterns are used specifically where they reduce coupling and match the natural shape of the problem:

- **Camera Engine → AI Tutor:** drowsiness detection emits an event rather than the AI Tutor polling camera state.
- **Progress Engine → Achievement Engine:** achievements react to progress events rather than duplicating progress-tracking logic.
- **Quiz completion → Course Engine gating:** gate unlocks are event-triggered, not polled.

Event-driven architecture is deliberately **not** applied everywhere (e.g., not for basic CRUD) — over-applying it would add indirection without benefit at V1 scale.

---

## 10. Module Architecture

Modules are organized **feature-first**, not layer-first, at the top level — each functional module from §7 is a self-contained feature package containing its own presentation/domain/data layers, plus a small set of shared "core" packages for cross-cutting concerns (networking, DI, theming, error handling). This means:

- A developer working on the Quiz Engine touches one directory tree, not five scattered ones.
- Features can be extracted, disabled, or replaced (e.g., replacing Achievement Engine wholesale) with minimal blast radius.
- New courses/features are added by adding new feature packages, not by modifying shared core logic.

**Dependency rule between modules:** feature modules may depend on `core/` packages, and may depend on other feature modules **only through their domain-layer interfaces** (never reaching into another feature's data or presentation layers). Cross-feature communication for reactive cases (e.g., Camera Engine → AI Tutor) goes through a lightweight app-level event bus rather than direct module-to-module calls, keeping modules independently testable.

Backend modules mirror this: each of Course/Lesson/Practice/Quiz/Progress/AI Tutor/Voice Session is its own FastAPI router + service + repository set, sharing only `core` (auth middleware, config, provider gateway, logging).

## 11. Voice Architecture

### 11.1 Pipeline

```
Microphone
   │  raw audio frames (small chunks, e.g. 20–100ms)
   ▼
Voice Activity Detection (VAD)
   │  speech / silence classification, on-device
   ▼
Speech-to-Text (streaming)
   │  incremental partial transcripts + final transcript
   ▼
LLM (streaming completion)
   │  token stream, chunked at sentence boundaries
   ▼
Text-to-Speech (streaming)
   │  audio chunks generated per sentence, not per full response
   ▼
Speaker (streaming playback)
```

### 11.2 Latency Optimization Strategy

The perceived-latency budget is attacked at every stage rather than relying on one fast component to compensate for slow ones:

- **VAD runs on-device**, not server-side, so silence/end-of-utterance detection doesn't wait on a network round trip.
- **STT streams partial transcripts** to the backend as the student speaks, rather than waiting for the full utterance — the LLM call can begin composing a response the instant a final transcript is available, and in some architectures even before, for low-risk turn-taking.
- **LLM output is chunked at sentence boundaries**, not token-by-token or full-response. TTS synthesis begins on the first complete sentence while the LLM continues generating the rest — this is the single largest perceived-latency win, since it decouples "time to full answer" from "time to first sound."
- **TTS audio streams to the client in chunks** and playback begins on receipt of the first chunk, not after the full audio file is synthesized.
- **Barge-in support:** if VAD detects the student speaking while TTS is playing, playback is interrupted immediately and the new utterance is captured — this is essential for natural conversation and must not be an afterthought.

### 11.3 Buffering & Packet Sizing

- **Microphone capture:** small frame sizes (target 20–100ms per frame) balance responsiveness against per-frame overhead; frames are batched into slightly larger chunks (e.g., ~200–300ms) before transmission to avoid excessive network overhead from too-small packets.
- **STT streaming:** partial results are debounced client-side for UI display (to avoid flickering transcript text) but sent to the backend as available — UI debounce and backend processing are decoupled.
- **TTS playback buffer:** a small jitter buffer (roughly one sentence's worth of audio) is maintained to absorb network variance without introducing perceptible playback delay; too small risks stutter, too large defeats the purpose of streaming.

### 11.4 Streaming Transport

WebSocket is used for the full voice session (bidirectional, low overhead per message, avoids repeated HTTP handshake cost of chunked REST). The Voice Session Manager on the backend owns the WebSocket connection lifecycle, coordinating STT/LLM/TTS provider calls and streaming results back over the same connection, so the client integrates against a single stream rather than juggling three provider connections directly (which would also leak provider API keys client-side — see §9.4).

### 11.5 Failure Handling

- STT/LLM/TTS timeouts on any single stage trigger a bounded retry (one retry, short timeout) before falling back to a text-mode prompt ("I'm having trouble hearing/responding right now — let's continue in text").
- Voice session reconnects automatically on transient network loss, resuming rather than restarting the tutoring turn where possible.

## 12. Camera Architecture

### 12.1 Principles

Camera is **off by default**, requires explicit opt-in, exists solely to improve tutoring (not surveillance), and **no frame or video is ever stored or transmitted off-device** in V1. This is a hard architectural constraint, not just a policy statement — the pipeline is designed so that raw frames never leave the device's memory.

### 12.2 Pipeline

```
Camera Frame (sampled, not every frame)
   │
   ▼
Face Detection
   │
   ▼
Eye Detection → Eye Aspect Ratio (EAR) calculation
   │
   ▼
Blink Detection (EAR pattern over time)
   │
   ▼
Head Pose Estimation (looking away detection)
   │
   ▼
Attention/Drowsiness Classifier (rule-based, on sustained signal)
   │
   ▼
Event → App Event Bus → AI Tutor context (§9.6)
```

### 12.3 Face & Eye Detection

Lightweight on-device face landmark detection (see §19 for library recommendation) locates facial landmarks including eye contours each sampled frame. No cloud-based face detection API is used — this would require transmitting frames off-device, violating the privacy principle in §12.1.

### 12.4 Eye Aspect Ratio (EAR) & Blink Detection

EAR is a standard, computationally cheap geometric ratio derived from eye landmark positions (ratio of eye height to width) that drops sharply when eyes close. Blink detection watches for short EAR dips; sustained low EAR beyond a normal-blink duration is the core drowsiness signal.

### 12.5 Head Pose & Attention

Head pose (yaw/pitch estimated from landmark geometry) detects sustained "looking away" distinct from normal glancing (e.g., glancing at the code sidebar). Attention classification requires **sustained** deviation over a multi-second window, not instantaneous frames, to avoid false positives from natural head movement.

### 12.6 Performance & Battery Optimization

- **Frame sampling, not full-framerate inference:** the pipeline runs on a throttled interval (e.g., a few frames per second) rather than every camera frame — sufficient for drowsiness detection, which is a slow-changing signal, while drastically reducing CPU/battery cost.
- **Lightweight models only:** classical CV/geometric techniques (EAR, head pose from landmarks) are prioritized over heavy deep-learning inference per frame — "efficient computer vision techniques" per the product requirement, not a full neural drowsiness-detection model in V1.
- **Pause when app backgrounded** or lesson not actively in a voice/practice state — no reason to run camera inference during static reading, for example.

### 12.7 Debounce & Event Rate-Limiting

Detected drowsiness/distraction must persist over a cooldown-gated window before an event fires, and once fired, a cooldown period (e.g., several minutes) prevents repeated nagging for the same underlying state — the AI should offer a break once, not every 30 seconds.

### 12.8 Cross-Platform Abstraction

A `CameraSource` interface (§9.5) abstracts platform camera APIs (CameraX-equivalent on Android, AVFoundation on iOS, Windows Media Capture); the CV pipeline (face/eye/head-pose logic) operates on a common frame format so detection logic is written once and shared across platforms, with only frame-acquisition code being platform-specific.

---

## 13. AI Tutor Architecture

### 13.1 Design Problem

An LLM given a system prompt saying "you are a tutor" and the raw chat history will still, over a long enough conversation, drift toward generic chatbot behavior: it forgets to check understanding, answers off-topic tangents at length, and doesn't proactively pace the lesson. Nerove Tutor addresses this with **structured orchestration**, not prompt engineering alone: the backend constructs a bounded, structured context every turn and constrains what the model is allowed to do next.

### 13.2 Behavioral Contract

Every AI Tutor turn is built from:

1. **Static persona instructions** — tone, teaching style, constraints (never just "give the answer" on a practice/quiz item without the student attempting it first, etc.).
2. **Structured student state** (not raw history replay): current lesson position, this lesson's learning objective, the student's mistake log for this topic, quiz/practice results so far, and a short rolling summary of recent turns.
3. **The current turn's input** (transcribed speech or typed text).
4. **An explicit "next allowed actions" frame** — e.g., during a quiz, the model is instructed to evaluate against a specific expected-answer rubric rather than freely conversing.

This is what makes the AI "never behave like a generic chatbot" a testable, engineered property rather than a hope: the orchestrator, not the raw model, enforces lesson pacing, mistake tracking, and gating.

### 13.3 Responsibilities Mapped to Mechanisms

| Responsibility | Mechanism |
|---|---|
| Teach step-by-step | Lesson content broken into micro-steps server-side; AI is prompted per-step, not given the whole lesson at once |
| Remember previous lessons/mistakes | Structured state injection (§13.2), not reliance on model's implicit memory |
| Adapt explanations | Practice/Quiz Engine failure signals trigger an explicit "retry strategy" instruction to the model (simpler analogy, smaller step) |
| Generate quizzes | AI generates question variants from a lesson's objective + question schema, validated against expected-answer structure before being shown |
| Evaluate answers | Structured rubric-based evaluation prompt, not open-ended judgment, for anything gating (quizzes) |
| Encourage / correct misconceptions | Persona-level tone instructions + explicit "acknowledge effort before correcting" behavioral rule |
| Real-world analogies / coding examples | Standard teaching-prompt techniques, informed by lesson metadata (topic, difficulty) |
| Summarize lessons / review material | Triggered at lesson-end and session-start (recap) using stored lesson objectives + mistake log |
| Recommend next lesson | Deterministic from Course Engine gating state — the AI states the system's decision, it does not decide gating itself |
| Track improvement | Progress Engine is the source of truth; AI references it, does not maintain its own parallel notion of progress |

### 13.4 Structured Output for the Coding Workspace

When teaching code, the AI Tutor's response is generated with a structured component alongside natural language — specifically, explicit references (e.g., line numbers, code identifiers) that the client uses to highlight the corresponding line in the Coding Workspace (§7.15). This is enforced via response schema/function-calling style output, not parsed from free text, to keep the sync reliable.

### 13.5 Memory Strategy

- **Short-term (within session):** recent turns kept in full for coherence.
- **Medium-term (within lesson):** mistake log and practice/quiz results, structured, not prose.
- **Long-term (across sessions):** a periodically generated summary per lesson/chapter (not the full transcript) is what's injected into future sessions' context — keeps context bounded regardless of how long a student has been using the app, and is what powers the "last time we covered X" recap (§6.2). Full raw transcripts remain stored (§7.16) for user-facing history/review, but are not what's fed back into the model by default.

### 13.6 Off-Syllabus Handling

If a student asks something unrelated to the current lesson, the AI Tutor is instructed to answer briefly if reasonable and low-risk, then explicitly steer back ("Good question — quick answer: ... Now, back to functions..."). It does not refuse to engage (that would feel robotic and unhelpful) nor does it fully abandon the lesson structure to chase the tangent indefinitely.

### 13.7 Provider & Model Considerations

The AI Tutor is built against the `ProviderGateway` abstraction (§9.4). Model selection is not fixed in this document as a permanent decision — it is a configuration/ops decision revisited based on real cost/latency/quality data post-launch — but the orchestration pattern above (structured context injection, not raw-history reliance) is provider-agnostic and is the actual architectural commitment.

## 14. Learning Engine

### 14.1 Structure

```
Course
 └── Chapter
      └── Lesson
           ├── Teaching content (AI-guided)
           ├── Practice (non-gating)
           └── Quiz (gating)
                └── unlocks → Next Lesson
```

### 14.2 Gating Rules

- A lesson is **locked** until its chapter-prerequisite lessons are completed (quiz passed at or above threshold).
- Practice is always accessible within an unlocked lesson and never blocks progression on its own — it exists to build readiness for the quiz, not as a second gate.
- Gating state is computed and enforced server-side (§7.13) using the Progress Engine as source of truth; the client reflects, never decides, gate state.

### 14.3 Content Model Principles

- Course content (chapters/lessons/quiz question banks/practice items) is stored as structured data, versioned, and language-tagged (`language: python` today) rather than hardcoded — this is what makes multi-course support in future versions a content-authoring task, not an engineering one (§4.1 architectural goal).
- Lessons declare an explicit **learning objective** (machine-readable, not just a title) — this objective is what the AI Tutor references when teaching, generating quiz variants, and building recap summaries (§13.3, §13.5).

### 14.4 Progression & Review

- Passing a quiz unlocks the next lesson immediately.
- Failing a quiz below threshold does not lock the student out — it surfaces a targeted review flow (AI re-teaches the specific missed objective, not the whole lesson) before allowing a retake.
- A lightweight spaced-review mechanism (e.g., periodically resurfacing a past lesson's key objective in a new session's warm-up) is included in V1 as a simple rule (e.g., "surface one older weak topic per N sessions"), with a more sophisticated spaced-repetition scheduling algorithm deferred to V2+ (§26).

---

## 15. Database Design

Postgres via Supabase. All tables use UUID primary keys, `created_at`/`updated_at` timestamps, and Row-Level Security policies scoping rows to `auth.uid()` where user-owned.

### 15.1 Core Tables (conceptual schema)

**users** (managed by Supabase Auth + a `profiles` extension table)
- `id` (PK, = auth user id), `display_name`, `experience_level`, `learning_goal`, `preferences` (JSONB), `created_at`

**courses**
- `id` (PK), `slug` (e.g., `python`), `title`, `subject`, `description`, `content_version`, `is_published`

**chapters**
- `id` (PK), `course_id` (FK → courses), `order_index`, `title`, `description`

**lessons**
- `id` (PK), `chapter_id` (FK → chapters), `order_index`, `title`, `learning_objective` (structured/machine-readable), `content` (JSONB — teaching steps, examples), `language` (e.g., `python`), `prerequisite_lesson_id` (nullable FK → lessons)

**practice_items**
- `id` (PK), `lesson_id` (FK → lessons), `type` (code/fill-blank/predict), `prompt`, `expected_answer_schema` (JSONB)

**quizzes**
- `id` (PK), `lesson_id` (FK → lessons), `pass_threshold`, `question_bank` (JSONB, seed for AI-variant generation)

**quiz_results**
- `id` (PK), `user_id` (FK → users), `quiz_id` (FK → quizzes), `score`, `passed` (bool), `answers` (JSONB), `attempted_at`

**progress**
- `id` (PK), `user_id` (FK → users), `lesson_id` (FK → lessons), `status` (not_started/in_progress/completed), `mastery_score`, `last_position` (JSONB — resume point), `updated_at`
- Unique constraint on (`user_id`, `lesson_id`)

**mistake_log**
- `id` (PK), `user_id` (FK → users), `lesson_id` (FK → lessons), `objective_tag`, `mistake_summary`, `occurred_at`
- Feeds AI Tutor adaptive-strategy behavior (§13.3)

**achievements**
- `id` (PK), `user_id` (FK → users), `type` (streak/badge/milestone), `metadata` (JSONB), `earned_at`

**conversation_sessions**
- `id` (PK), `user_id` (FK → users), `lesson_id` (FK → lessons, nullable), `started_at`, `ended_at`, `summary` (text — long-term memory input, §13.5)

**conversation_messages**
- `id` (PK), `session_id` (FK → conversation_sessions), `role` (user/assistant), `content`, `created_at`
- Partitioned/archived by age at scale (§15.3) since this is the highest-growth table

**bookmarks**
- `id` (PK), `user_id` (FK → users), `lesson_id` (FK → lessons), `note` (nullable), `created_at`

**study_statistics**
- `id` (PK), `user_id` (FK → users), `date`, `minutes_studied`, `lessons_completed`, `quizzes_passed`
- Daily rollup table, populated from `learning_sessions` — avoids expensive aggregate queries over raw session data for dashboards

**learning_sessions**
- `id` (PK), `user_id` (FK → users), `lesson_id` (FK → lessons, nullable), `started_at`, `ended_at`, `device_type`

**notifications**
- `id` (PK), `user_id` (FK → users), `type`, `payload` (JSONB), `sent_at`, `read_at`

**settings**
- `user_id` (PK, FK → users), `camera_enabled` (default `false`), `voice_enabled` (default `true`), `tts_voice`, `notification_prefs` (JSONB)

### 15.2 Key Relationships

- `courses 1—N chapters 1—N lessons` — the core content hierarchy; `subject` on `courses` and `language` on `lessons` are what make this multi-course-ready without schema change.
- `lessons 1—N practice_items`, `lessons 1—1 quizzes` (a lesson has at most one gating quiz in V1; modeled as 1–N to allow chapter-level quizzes later without migration).
- `users 1—N progress`, one row per (user, lesson) — the gating source of truth.
- `users 1—N mistake_log`, tagged by `objective_tag` (not free-text lesson reference) so the AI Tutor and future spaced-review logic can query "which objectives is this student weak on" directly.
- `conversation_sessions 1—N conversation_messages` — raw transcript; `conversation_sessions.summary` is the compressed long-term-memory artifact (§13.5), deliberately a separate field rather than requiring re-summarization of the full message table on every read.

### 15.3 Scalability Notes

- `conversation_messages` is the fastest-growing table by orders of magnitude; it is designed from V1 for time-based partitioning/archival (e.g., move sessions older than N months to cold storage) even though this isn't operationally necessary at V1 scale — retrofitting partitioning onto a live, huge table is far more painful than defining it early.
- `study_statistics` exists specifically so dashboards and streak calculations never require scanning `learning_sessions` directly at read time.
- All foreign keys are indexed; `progress` and `mistake_log` additionally indexed on `user_id` alone, since "get everything for this student" is the single most common query shape (used every AI Tutor turn).

## 16. API Overview

The backend exposes a REST API for standard operations and a WebSocket endpoint for the voice session. Representative endpoint groups (not exhaustive):

```
POST   /auth/session/refresh
GET    /profile
PATCH  /profile

GET    /courses/{course_id}/structure          # chapters + lessons + gate state for current user
GET    /lessons/{lesson_id}
POST   /lessons/{lesson_id}/progress            # update position/status

POST   /practice/{practice_item_id}/attempt     # submit + AI-evaluate
POST   /quizzes/{quiz_id}/attempt               # submit + grade + gate update

GET    /conversations/{lesson_id}/history
GET    /conversations/session/{session_id}/recap

WS     /voice/session                           # bidirectional streaming: audio in, transcript+audio out

GET    /achievements
GET    /settings
PATCH  /settings
```

Direct Supabase client access (bypassing the FastAPI layer, protected by RLS) is used for simple reads that don't require orchestration or AI provider calls — e.g., reading course structure content, subscribing to realtime progress updates — per the rationale in §9.2.

All backend endpoints require a valid Supabase-issued JWT, validated by shared auth middleware; gating and grading endpoints additionally re-verify server-side state (never trusting client-submitted "I passed" claims).

---

## 17. State Management

**Recommendation: Riverpod** (see §19 for full library evaluation).

Rationale specific to this product's shape:

- The app has several long-lived, cross-cutting streams of state that many widgets need simultaneously and reactively: voice session status, camera/attention state, progress/gating state, current lesson position. Riverpod's provider graph handles this without prop-drilling or a single monolithic store.
- Compile-time safety (no runtime "provider not found" class of bugs) matters for a codebase expected to grow across many feature modules built by different engineers.
- Providers compose naturally with the feature-first module structure (§10) — each feature exposes its own providers without a central registration file becoming a bottleneck.
- Good testability: providers can be overridden in tests without a DI container.

**State categories:**
- **Ephemeral UI state** (e.g., sidebar collapsed/expanded) — local widget state, not global providers.
- **Session state** (voice connection status, current turn) — `StateNotifierProvider`/`AsyncNotifierProvider` scoped to the active lesson session.
- **Persistent/server state** (progress, profile, settings) — repository-backed providers with optimistic updates and cache invalidation on write.
- **Realtime-driven state** (cross-device progress sync) — a stream provider subscribed to the relevant Supabase Realtime channel, feeding into the same progress state consumed elsewhere, so the UI reacts uniformly regardless of whether an update originated locally or from another device.

## 18. UI/UX Guidelines

### 18.1 Design Philosophy: Soft Minimalism

The product must read as a **calm, premium educational tool**, not a flashy consumer app and not a utilitarian developer tool. Concretely:

- **Generous whitespace/spacing** — content never feels cramped; this matters specifically because sessions can run long (studying is not a quick-glance use case like checking a notification).
- **Rounded corners** across cards, buttons, and the coding workspace panel — soft, approachable geometry rather than sharp technical edges, deliberately balancing the "this teaches code" seriousness with warmth.
- **Calm, restrained color palette** — a small set of muted primary/accent colors; color is used to communicate state (progress, correctness) purposefully, not decoratively.
- **Professional typography** — a clean, highly legible typeface for body/teaching text, with a distinct monospace typeface reserved for code, so the two content types are instantly visually distinguishable without relying on color alone (accessibility benefit too).
- **No visual clutter** — every screen has a clear single primary action; secondary controls (settings, history) are tucked away, not competing for attention with the active teaching content.

### 18.2 Core Screens

- **Active Lesson Screen** — the primary screen; voice/text conversation area, collapsible Coding Workspace sidebar, subtle progress indicator, minimal chrome.
- **Course Map** — chapter/lesson list with clear locked/unlocked/completed states; secondary to the "continue" flow, not the landing screen (§6.2).
- **Profile/Progress** — study statistics, achievements, mistake areas — a calm dashboard, not a gamified overload.
- **Settings** — voice, camera, notifications, appearance; privacy-relevant toggles clearly labeled with their off-by-default state visible.

### 18.3 Voice Interaction UI

Because text is always shown alongside voice (§8 accessibility requirement), the active lesson screen always displays a live transcript of both sides of the conversation, not just an abstract "listening" animation. The listening/speaking/thinking states are communicated through a single, subtle, non-distracting visual indicator — this is a teaching tool, not a voice-assistant showcase, so the animation should not compete with the code/content on screen.

### 18.4 Coding Workspace (Discord-style Sidebar)

- Collapsible panel, default open during code-focused lessons, collapsed during discussion-only steps.
- Contains: current example code (syntax-highlighted), a short explanation panel, and persistent lesson notes.
- When the AI references a specific line (§13.4), that line is visually highlighted in the sidebar in sync with the conversation — this is the single most important interaction in the coding workspace and should be tested explicitly (§25).

### 18.5 Long-Session Comfort

Given study sessions can run 20+ minutes, the UI avoids high-contrast pure white backgrounds by default (favoring a slightly warm off-white or an optional calm dark mode), avoids autoplay animations beyond functional state indicators, and keeps information density low on the primary teaching screen specifically (secondary screens like Course Map can be denser).

---

## 19. Recommended Libraries

All recommendations are free/open-source (no paid SDK tiers required for core function). Versions are "recommended baseline as of this writing" — pin exact versions at implementation time and verify current maintenance status, since library ecosystems move faster than this document.

### 19.1 Flutter — State Management

**Riverpod (`flutter_riverpod` / `riverpod`)**
- Purpose: App-wide reactive state management (§17).
- Advantages: Compile-time provider safety, excellent testability, no BuildContext dependency for logic, scales well across large feature-first codebases.
- Disadvantages: Steeper learning curve than Provider; codegen variant adds a build-runner step.
- Community/Maintenance: Very actively maintained, large community, official Flutter-adjacent ecosystem.
- Cross-platform: Full.
- Recommended version: 2.x

*Alternative considered:* **Bloc** — more boilerplate and ceremony for this app's shape (many small cross-cutting streams); Riverpod's provider composition fits better here without sacrificing testability.

### 19.2 Flutter — Routing

**go_router**
- Purpose: Declarative navigation, deep linking, gated routes (useful for lesson-lock redirects).
- Advantages: Official Flutter team package, strong deep-link support, integrates cleanly with Riverpod via `refreshListenable`.
- Disadvantages: Some verbosity for deeply nested route hierarchies.
- Community/Maintenance: Actively maintained by the Flutter team.
- Cross-platform: Full.
- Recommended version: 14.x

### 19.3 Flutter — Dependency Injection

**riverpod (as DI)**, supplemented by **get_it** only if a non-widget-tree DI need arises (e.g., background service singletons).
- Purpose: Riverpod's provider graph doubles as DI for most needs; avoids introducing a second DI system.
- Advantages: One mental model for both state and dependency wiring.
- Disadvantages: Providers are Flutter/Dart-ecosystem-coupled; pure background isolate code may prefer plain constructor injection.
- Recommendation: Do not add a separate DI framework unless a concrete gap appears — avoids the "over-engineering" failure mode explicitly called out in scope.

### 19.4 Flutter — Networking

**dio**
- Purpose: HTTP client for REST calls to FastAPI backend.
- Advantages: Interceptors (auth token attach/refresh), request cancellation, good error typing, widely used.
- Disadvantages: Heavier than `http` for very simple needs (not a concern here given interceptor requirements).
- Community/Maintenance: Actively maintained, very large community.
- Cross-platform: Full.
- Recommended version: 5.x

**web_socket_channel**
- Purpose: WebSocket transport for the voice session and realtime fallback handling.
- Advantages: Official Dart team package, simple stream-based API.
- Community/Maintenance: Actively maintained.
- Recommended version: 2.x

### 19.5 Flutter — Animation

**flutter's built-in animation framework (implicit/explicit animations)**, supplemented by **rive** only for specific designed illustrations (e.g., a tutor "speaking" indicator) if design calls for it.
- Advantages: No extra dependency for the majority of UI motion needs; Rive adds designer-authored motion without hand-coding complex curves, if/when needed.
- Disadvantages: Rive adds a runtime dependency and an external design tool workflow — only justified if the "speaking indicator" or similar needs bespoke motion design.
- Recommendation: Ship V1 with built-in animations only; evaluate Rive if design requirements exceed what's easily hand-built.

### 19.6 Flutter — Offline Storage

**drift** (SQLite wrapper) for structured offline lesson cache; **shared_preferences** for simple key-value settings.
- Advantages (drift): Type-safe queries, reactive streams (pairs naturally with Riverpod), handles the structured lesson-content cache well (§7.18).
- Disadvantages: More setup than a pure key-value store; unnecessary if offline needs were trivial (they aren't — structured lesson content needs querying).
- Community/Maintenance: Actively maintained, strong Flutter-specific community.
- Cross-platform: Full (including Windows).
- Recommended version: drift 2.x, shared_preferences 2.x

*Alternative considered:* **Hive** — simpler API but weaker query capability and a less active maintenance trajectory recently; drift's SQL-backed model fits the structured course content better.

### 19.7 Flutter — Image Caching

**cached_network_image**
- Purpose: Avatar/course-art image loading and caching.
- Advantages: Battle-tested, simple API, disk+memory caching out of the box.
- Community/Maintenance: Actively maintained, extremely widely used.
- Cross-platform: Full.
- Recommended version: 3.x

### 19.8 Flutter — Markdown Rendering

**flutter_markdown**
- Purpose: Rendering lesson explanation text (which may contain formatting, lists, inline code) authored as Markdown.
- Advantages: Official-adjacent package, simple integration, extensible custom builders (useful for inline code styling matching the coding workspace theme).
- Disadvantages: Less actively updated than some alternatives; verify current maintenance status at implementation time and consider `markdown_widget` as a fallback if so.
- Cross-platform: Full.
- Recommended version: 0.7.x (verify current status before committing)

### 19.9 Flutter — Code Editor / Syntax Highlighting

**flutter_highlight** (based on `highlight.js` grammars) for read-only syntax-highlighted code display in the Coding Workspace; **re_editor** or **code_text_field** evaluated if any future version requires an *editable* in-app code editor (not required for V1's read-along/example-code use case).
- Advantages (flutter_highlight): Lightweight, broad language grammar support (useful for future multi-language courses), sufficient for V1's display-only sidebar.
- Disadvantages: Not a full editor (no in-line editing, autocomplete) — acceptable since V1's Coding Workspace displays examples rather than requiring students to write/run code in-app.
- Cross-platform: Full.
- Recommended version: 0.7.x
- **Engineering note:** if a future version adds in-app code execution/editing, this is a deliberate scope expansion requiring a real code-editor component and sandboxed execution — explicitly deferred (§26).

### 19.10 Python — Backend Framework

**FastAPI** (given) + **uvicorn** (ASGI server) + **pydantic v2** (validation).
- Advantages: Async-native (essential for streaming voice/LLM calls), automatic request validation and OpenAPI docs, strong typing story.
- Community/Maintenance: Very actively maintained, large and growing community.
- Recommended versions: FastAPI 0.11x, pydantic 2.x, uvicorn 0.3x

### 19.11 Python — Voice Activity Detection

**silero-vad**
- Purpose: On-device/on-server lightweight VAD for speech/silence detection.
- Advantages: Small model, fast CPU inference, no GPU required, permissive license, strong accuracy for its size.
- Disadvantages: Not as configurable as some commercial VAD offerings for edge-case noise environments.
- Community/Maintenance: Actively maintained, widely adopted in open-source voice pipelines.
- Cross-platform: Runs anywhere Python/ONNX runs; also portable to on-device inference in later versions.
- Recommended version: latest stable (verify at implementation time)

### 19.12 Speech-to-Text

Given the requirement to recommend only free/open libraries, and acknowledging most production-grade *hosted* STT is commercial: recommend building the `ProviderGateway` STT interface against **Whisper**-family open-source models (e.g., via `faster-whisper`) as the default/free-tier-compatible option, with the gateway architecture (§9.4) allowing a hosted provider to be configured instead if streaming-latency needs at scale exceed what self-hosted Whisper inference can deliver.
- Advantages (faster-whisper): Open-source, no per-request cost, good accuracy, active community (CTranslate2-based, efficient inference).
- Disadvantages: Self-hosting requires GPU/CPU capacity planning; naive Whisper is not natively streaming — requires chunked-inference engineering to approximate streaming behavior (a real implementation cost called out explicitly here, not glossed over).
- Community/Maintenance: Actively maintained.
- Recommendation: Prototype against faster-whisper for cost control; re-evaluate against a hosted streaming-native STT provider once real latency numbers are measured against §22 targets — flag this as a decision point, not a settled choice.

### 19.13 Text-to-Speech

Similarly, recommend evaluating **Piper** (open-source, fast, good quality neural TTS, runs efficiently on CPU) as the free/self-hostable default behind the `ProviderGateway`.
- Advantages: Open-source, low-latency CPU inference, multiple voices, permissive license, designed for streaming-friendly short-utterance synthesis.
- Disadvantages: Voice quality is good but not at the level of top commercial neural TTS; fewer expressive/emotional voice options.
- Community/Maintenance: Actively maintained, growing adoption.
- Recommendation: Same as STT — ship V1 behind the gateway abstraction so voice quality/cost can be revisited with real usage data without an architecture change.

### 19.14 Computer Vision (Camera Engine)

**Google ML Kit (Face Detection API)** via Flutter plugin (`google_mlkit_face_detection`) for on-device face/landmark detection powering EAR and head-pose calculation (§12).
- Advantages: Free, fully on-device (no data leaves device — critical per §12.1), fast, officially supported on Android/iOS, actively maintained by Google.
- Disadvantages: Windows support is not native (ML Kit is Android/iOS-focused) — requires a separate approach for Windows (see below).
- Community/Maintenance: Actively maintained.
- Recommended version: latest stable plugin release (verify at implementation time)

**For Windows:** recommend **MediaPipe** (Google, open-source, cross-platform including desktop) as the Windows-specific implementation behind the same `CameraSource`/detection interface (§12.8), since ML Kit does not target Windows. This is flagged explicitly as a platform-specific implementation detail rather than glossed over — it is the one place where V1's "single pipeline" claim requires two concrete implementations behind one interface.
- Advantages: Cross-platform, on-device, free, provides face landmark models suitable for EAR/head-pose calculation.
- Disadvantages: Different integration path than ML Kit — engineering effort to maintain two implementations of the same logical detector.

### 19.15 Logging

**loguru** (Python backend), **logging** package with structured output (Flutter, via a thin wrapper).
- Advantages (loguru): Simple API, structured/JSON output support (useful for log aggregation later), good defaults.
- Community/Maintenance: Actively maintained, widely used.
- Recommendation: Structure logs as JSON from day one even at V1 scale — negligible cost now, saves a migration when log aggregation tooling is introduced later.

### 19.16 Testing

- **Flutter:** built-in `flutter_test` + `mocktail` (mocking, null-safety-friendly) + `integration_test` (end-to-end).
- **Python:** `pytest` + `pytest-asyncio` (async endpoint testing) + `httpx` (async test client for FastAPI).
- Advantages: All are the de facto standard, well-documented, actively maintained tools in their respective ecosystems — no exotic choices needed here.

### 19.17 CI/CD

**GitHub Actions**
- Advantages: Free tier sufficient for V1 team scale, native integration with GitHub-hosted repos, mature Flutter and Python action ecosystems, no separate CI infrastructure to operate.
- Disadvantages: Cost scales with usage at larger team/build-volume scale (a later-version consideration, not a V1 blocker).
- Recommendation: Separate pipelines for Flutter (build/test per platform) and backend (test/lint/deploy), triggered on PR and merge to main.

---

## 20. Folder Structure

### 20.1 Flutter Client (feature-first, Clean Architecture per feature)

```
lib/
├── core/
│   ├── network/            # dio client, interceptors
│   ├── di/                 # riverpod provider composition roots
│   ├── theme/               # design tokens, typography, color
│   ├── error/               # shared failure/exception types
│   ├── platform/            # CameraSource, AudioSource interfaces + platform impls
│   └── event_bus/           # cross-feature event bus (§9.6)
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   ├── profile/
│   ├── course_engine/
│   ├── lesson_engine/
│   ├── practice_engine/
│   ├── quiz_engine/
│   ├── ai_tutor/
│   ├── voice_engine/
│   ├── camera_engine/
│   ├── progress_engine/
│   ├── achievements/
│   ├── coding_workspace/
│   ├── conversation_history/
│   ├── notifications/
│   ├── offline_cache/
│   ├── settings/
│   └── analytics/
├── app.dart                # root widget, router config
└── main.dart
```

Each `features/<name>/` directory contains its own `presentation/`, `domain/`, `data/` subfolders per §9.3 — no feature reaches into another feature's `data/` or `presentation/` layer directly.

### 20.2 Backend (FastAPI)

```
app/
├── core/
│   ├── config.py            # env/config loading
│   ├── auth_middleware.py
│   ├── provider_gateway/    # LLM/STT/TTS abstraction (§9.4)
│   └── logging.py
├── modules/
│   ├── course_engine/
│   │   ├── router.py
│   │   ├── service.py
│   │   └── repository.py
│   ├── lesson_engine/
│   ├── practice_engine/
│   ├── quiz_engine/
│   ├── ai_tutor/
│   │   ├── router.py
│   │   ├── orchestrator.py  # §13.2 structured context construction
│   │   └── prompts/
│   ├── voice_session/
│   │   ├── ws_router.py
│   │   └── pipeline.py      # §11 pipeline coordination
│   ├── progress_engine/
│   ├── achievements/
│   └── notifications/
├── db/
│   ├── models.py
│   └── migrations/
└── main.py
```

Backend modules mirror the client's feature-first structure (§10) for conceptual consistency across the stack — an engineer who understands the client's module boundaries already understands the backend's.

## 21. Security

### 21.1 Principles

- **Least privilege by default.** Every privacy-relevant setting (camera, voice recording indicators) defaults to off/most-private; nothing sensitive is opt-out.
- **No unnecessary data retention.** Camera frames are never persisted, in memory only for the duration of inference (§12.1). Voice audio is not retained beyond what's needed to produce a transcript; the transcript, not the audio, is what's stored (see §21.4).
- **Server-side enforcement of anything gating or graded.** Client state is a reflection of server truth, never authoritative (§7.13, §14.2).

### 21.2 Authentication & Authorization

- Supabase Auth issues short-lived JWTs; refresh handled transparently by the client's auth interceptor.
- Row-Level Security policies on every user-owned table (§15) ensure a user can only read/write their own rows, enforced at the database layer as a second line of defense independent of application-layer checks.
- Backend endpoints validate the JWT and re-derive `user_id` server-side — never trust a client-submitted user identifier in a request body.

### 21.3 Data in Transit

- All client-backend and client-Supabase traffic over TLS.
- WebSocket voice sessions use WSS.
- API keys for LLM/STT/TTS providers live only in backend environment configuration, never shipped in client binaries.

### 21.4 Data at Rest

- Database encryption at rest (Supabase-managed).
- Conversation transcripts (text) are stored as normal user data, protected by RLS like any other user-owned table — no special sensitivity beyond standard user-data handling in V1, since no camera/voice recordings are stored alongside them.
- No raw audio or video is stored anywhere in the system in V1 — only derived text (transcripts) and derived events (attention signals), consistent with §12.1 and §21.1.

### 21.5 Privacy-First Design (General, Not Region-Specific)

Per product scope, V1 does not target specific regional compliance certification (GDPR/COPPA/etc.), but follows the practices that underpin most such frameworks as good general hygiene:
- Explicit opt-in for sensitive capabilities (camera).
- Clear, accessible settings showing exactly what's enabled and why.
- Data minimization (don't collect/store what isn't used).
- A defined account-deletion path (deletes user rows across owned tables) is a V1 requirement even without formal compliance certification — it's baseline good practice and straightforward given RLS-scoped ownership.

### 21.6 Application Security

- Standard input validation via Pydantic on every backend endpoint.
- Rate limiting on AI-provider-calling endpoints (cost and abuse protection) — implemented at the API gateway/middleware layer, configurable per endpoint.
- Dependency vulnerability scanning as part of CI (§25.4).
- Secrets managed via environment configuration/secret manager, never committed to source control.

---

## 22. Performance Targets

These are engineering targets to design and measure against, not guaranteed SLAs at V1 launch — they should be validated with real infrastructure and revised based on measured data.

| Metric | Target | Rationale |
|---|---|---|
| Voice: silence-to-first-audio-response latency | Perceptually "conversational" — sub-second to low-single-digit-second range, with sentence-boundary TTS streaming (§11.2) being the primary lever to hit this | Anything that feels like a walkie-talkie exchange breaks the core product bet (G2) |
| STT partial transcript update | Near-real-time, visibly incremental as the student speaks | Confirms to the student they're being heard, reduces perceived latency even before a response begins |
| App cold start | Fast enough that onboarding/resume doesn't feel sluggish on mid-range Android hardware | G4 — lightweight on low-end devices |
| Lesson content load (cached) | Near-instant | Static content should never be the bottleneck; only AI responses should carry latency |
| Realtime progress sync | Reflected on a second device within a few seconds of reconnect | Supports the "same account, multiple devices" journey without feeling broken |
| Camera inference overhead | Minimal, throttled sampling (§12.6), not full-framerate | Battery/thermal impact must be negligible for an optional feature — a feature that drains the battery will simply be disabled by users |
| Memory footprint | Responsive on ~3GB RAM class Android devices | G4 |

**Engineering note:** latency is a whole-pipeline property, not any single component's responsibility — the team should instrument and measure each stage of the voice pipeline (§11.1) independently so regressions can be attributed to a specific stage, not just an aggregate "voice feels slow" bug report.

## 23. Risks

| Risk | Impact | Likelihood | Mitigation |
|---|---|---|---|
| Voice pipeline latency doesn't hit conversational targets with chosen open-source STT/TTS (§19.12–19.13) | High — undermines core differentiator | Medium | Provider abstraction (§9.4) allows swapping to hosted providers without redesign; prototype and measure early, before committing to self-hosted infra at scale |
| AI Tutor "feels like a chatbot" despite orchestration | High — undermines core product bet (G1) | Medium | Behavioral contract (§13.2) is testable; include qualitative blind-comparison testing against a plain-chatbot baseline as an explicit acceptance gate, not just automated tests |
| Camera feature perceived as creepy/surveillance despite privacy design | Medium — could suppress adoption of camera feature or damage trust in the product broadly | Medium | Off-by-default, explicit opt-in, no storage/transmission, transparent settings copy (§21.5); consider a short in-product explanation the first time it's offered |
| Self-hosted STT/TTS infra cost/ops burden at even modest scale | Medium | Medium | Gateway abstraction keeps hosted-provider fallback cheap to add; revisit build-vs-buy after V1 usage data (§19.12–19.13) |
| Course content authoring bottleneck (single Python course still requires substantial structured content) | Medium — delays launch | Medium | Content is structured data from day one (§14.3); content authoring can proceed in parallel with engineering once the schema is stable |
| Cross-platform camera implementation divergence (ML Kit vs. MediaPipe, §19.14) | Medium — inconsistent detection quality across platforms | Medium | Shared detection-logic interface (§12.8) isolates the divergence to acquisition/inference glue code; test each platform's implementation against the same EAR/head-pose acceptance criteria |
| Scope creep toward "just add a general chatbot mode" | Medium — dilutes the core positioning (explicit non-goal, §4.3) | Low–Medium | Off-syllabus handling (§13.6) is deliberately bounded; product decisions should be checked against the vision test in §2 |
| Realtime sync conflicts (multi-device usage) | Low–Medium | Low | Documented last-write-wins-by-field resolution (§7.13); acceptable given progress data is low-conflict by nature (mostly append-forward) |

## 24. Engineering Principles

- **Clean Architecture, enforced by directory structure, not just convention.** Domain layers never import Flutter/Supabase/FastAPI-framework types directly (§9.3) — this is checked in code review, not left to memory.
- **Feature-first over layer-first.** A feature can be understood, tested, and modified by looking at one directory tree (§10, §20).
- **Repository pattern everywhere infrastructure is touched.** Domain/use-case code depends on repository interfaces, never on concrete Supabase/HTTP clients directly — this is what makes provider swaps (§9.4) and future platform additions (§4.2/§26) bounded changes.
- **SOLID as a working discipline, not a slogan** — in particular Single Responsibility (each Engine in §7 does one job) and Dependency Inversion (§9.3, §9.4) are the two principles most load-bearing in this architecture; Open/Closed is achieved through the schema-driven content model (§14.3) rather than conditional branching on course/language.
- **Server-side enforcement of anything that matters.** Gating, grading, and mastery state are never trusted from the client (§7.13, §21.2) — a recurring theme applied consistently rather than case-by-case.
- **Graceful degradation over hard failure, everywhere AI/network is involved.** Every AI-dependent feature has a defined fallback (§7, per-module Failure Scenarios) — this is treated as a first-class requirement, not error-handling as an afterthought.
- **Don't over-engineer for scale that doesn't exist yet — but don't foreclose it either.** The recurring pattern in this document is: keep V1 scope small and simple (single course, no polished admin UI, no monetization), while keeping the *seams* (course/subject field, provider gateway, event bus, partition-ready transcript table) in place so growth doesn't require a rewrite. This is the specific, practical meaning of "design for scalability, not over-engineering" applied throughout, not just asserted once.

---

## 25. Testing Strategy

### 25.1 Unit Testing
- Domain layer (use cases, entities) on both client and backend: high coverage expected, since this is pure logic with no framework dependencies (§9.3) — cheapest and most valuable tests to write.
- Repository implementations tested against mocked infrastructure clients.

### 25.2 Integration Testing
- FastAPI endpoints tested with `httpx` async test client against a test database instance.
- Voice pipeline stages (VAD → STT → LLM → TTS) tested independently with recorded fixture audio, in addition to full end-to-end pipeline tests — isolates regressions to a specific stage (§22 engineering note).
- Gating logic (§14.2) specifically tested for the server-side enforcement property: attempt to bypass via crafted client requests, confirm rejection.

### 25.3 End-to-End / Widget Testing
- `integration_test` covering the critical path: onboarding → first lesson → practice → quiz → next lesson unlock.
- Coding Workspace line-highlight sync (§18.4) tested explicitly given its centrality to the coding-teaching experience.

### 25.4 AI Behavior Testing (qualitative, not purely automated)
- Blind comparison testing: transcripts of Nerove Tutor sessions vs. a plain-chatbot baseline, evaluated against the behavioral contract (§13.2) criteria — this is the acceptance test for G1 and cannot be fully captured by unit tests alone.
- Regression fixtures for known-good tutoring behaviors (e.g., "does the AI check understanding before advancing," "does it reference the mistake log when appropriate") re-run when prompts/orchestration logic change.

### 25.5 Performance Testing
- Voice pipeline latency measured per-stage under realistic network conditions (§22), not just on developer machines on fast wifi.
- Camera pipeline battery/CPU profiling on representative low/mid-range Android hardware (§12.6, G4).

### 25.6 Security Testing
- RLS policy tests: attempt cross-user data access for every user-owned table, confirm denial.
- Dependency vulnerability scanning integrated into CI (§19.17).

### 25.7 CI Gates
All of the above (excluding manual qualitative AI behavior review) run on every PR via GitHub Actions; merges to main are blocked on failing tests. Qualitative AI behavior review is a recurring, scheduled process (not a per-PR gate) given its manual nature.

## 26. Future Roadmap (V1 → V5)

**V1 — Foundation (this document's scope)**
Single course (Python), Android/iOS/Windows, voice-first tutoring, structured learning engine, optional camera attention detection, no monetization.

**V2 — Depth & Retention**
- Second course added, validating the multi-course architecture built in V1 (§14.3).
- Proper spaced-repetition scheduling replacing the simple V1 review rule (§14.4).
- Adaptive placement/diagnostic assessment at onboarding (replacing the light onboarding-goal signal, §6.1).
- Provider failover/multi-sourcing for LLM/STT/TTS (§9.4, §23) based on real cost/latency data.
- Expanded achievement system.

**V3 — Platform Expansion**
- macOS, Linux, Web clients — enabled by the platform-abstraction work already done in V1 (§9.5); primarily a client-surface effort, not a backend redesign.
- Polished internal admin/content-authoring web tool (V1 shipped with minimal tooling by design, §7.22).
- Push notification infrastructure (beyond V1's local notifications, §7.17).

**V4 — Monetization & Scale**
- Premium/Pro/Team/Enterprise tiers — the architecture (stateless backend, RLS-scoped data, provider gateway) was designed from V1 to not preclude this, but billing/entitlement logic is new work, deliberately deferred per scope (§4.2).
- Infrastructure scaling work informed by real usage: horizontal backend scaling, STT/TTS infra scaling or migration to hosted providers at volume.
- Conversation history summarization pipeline maturation (§13.5) as transcript volume grows.

**V5 — Advanced Intelligence & Offline**
- On-device/offline AI tutoring for constrained-connectivity contexts (explicitly out of scope for V1, §7.18).
- More sophisticated mastery modeling (beyond pass/fail quiz thresholds) feeding lesson pacing.
- Deeper personalization drawing on the by-then-larger cross-session memory corpus.

Each version is scoped so that it builds on architectural seams already present in V1, rather than requiring rework of decisions made in this document — this is the practical test applied throughout: does the V1 decision foreclose the later capability, or just defer building it.

## 27. Appendix

### 27.1 Glossary
- **Gating** — the mechanism preventing a student from accessing a lesson until prerequisite lessons are completed at a passing threshold.
- **EAR (Eye Aspect Ratio)** — a geometric ratio derived from eye landmark positions used to detect blinks/eye closure cheaply, without deep-learning inference.
- **Barge-in** — the ability for a student to interrupt the AI's spoken response mid-playback, as in natural human conversation.
- **ProviderGateway** — the backend abstraction layer isolating LLM/STT/TTS vendor integrations from calling code (§9.4).
- **Structured context injection** — the AI Tutor orchestration technique of reconstructing bounded, structured student state each turn rather than relying on raw chat-history replay (§13.2).

### 27.2 Open Questions for Engineering Kickoff
- Final STT/TTS provider decision (self-hosted per §19.12–19.13 vs. hosted) pending early latency prototyping.
- Exact quiz pass-threshold default (e.g., 80%) — a product/pedagogy decision, not purely engineering.
- Windows camera implementation (MediaPipe, §19.14) timeline relative to Android/iOS — may ship as a fast-follow if V1 timeline is tight, given camera is a "Should," not "Must" (§7.11).

### 27.3 Document History
- v1.0 — Initial engineering-grade PRD authored from product brief and scope clarifications; supersedes any prior draft, which was explicitly not reused per project instruction.

---

*End of document.*
