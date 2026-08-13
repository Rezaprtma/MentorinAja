# MentorinAja — Product Requirements

This document defines what MentorinAja is as a product: the problem it solves, who it serves, and the scope of the current version. It describes the product as it exists and the near-term direction it is headed.

- **Status:** Authoritative for product intent
- **Last updated:** 2026-08-12
- **Companion docs:** design (`docs/design/`), architecture (`docs/architecture/`)

---

## 1. Product Summary

MentinorinAja is a **course-based learning app** for Indonesian learners. It helps users discover programming courses, resume where they left off, and track their learning progress in a modern, encouraging interface.

- **Name:** MentorinAja
- **Tagline:** *Teman Belajar yang Memahami Kamu* (A learning companion that understands you).
- **Language:** Bahasa Indonesia for all user-facing copy; English for code and technical terms.
- **Platforms:** Android, iOS, Windows.

### Current product state

The current version is **frontend-first**. The app runs end-to-end on local mock data:

- Splash → onboarding → authentication → learning shell
- Four main tabs: **Home**, **Explore**, **Progress**, **Profile**
- Course discovery and progress tracking are fully realized in UI
- Course detail, lesson playback, quizzes, practice, and AI tutor surfaces are **planned, not implemented**

---

## 2. Problem and Vision

### Problem

Indonesian learners face scattered, intimidating paths into technical education. Existing tools are either too heavy, too expensive, or not tailored to how Indonesian learners speak and learn.

### Vision

A world where every Indonesian learner has a patient, colorful, encouraging learning companion in their pocket — one that adapts to their pace, speaks their language, and makes learning feel like progress, not pressure.

### Goals for V1

1. Onboard a new learner from first launch to first course in under three minutes.
2. Make discovering courses effortless and enjoyable.
3. Make progress visible and motivating (streaks, completion, summaries).
4. Establish a design language that feels modern, colorful, and premium — not a generic education template.

---

## 3. Users

### Personas

| Persona | Description | Core need |
|---|---|---|
| **Fresh learner** | Someone new to programming who needs a friendly, structured starting point. | Guided discovery, low intimidation, clear next step. |
| **Career switcher** | Working adult building practical tech skills. | Efficient browsing, visible progress, resume anytime. |
| **Self-driven student** | Student supplementing school/college material. | Broad catalog, progress tracking, encouragement. |

### Key user flows

1. **First launch:** splash → onboarding (3 pages) → create account / sign in → home.
2. **Returning user:** splash → sign in → home with resume card ("Progres Saya").
3. **Discovery:** Explore tab → browse categories → popular courses → course detail (planned).
4. **Progress:** Progress tab → review stats, active courses, completed courses.

---

## 4. Scope

### In scope (current implementation)

| Area | Status |
|---|---|
| Splash, onboarding (3 pages) | ✅ Implemented |
| Authentication: sign in, create account, OTP verification, Google (mock) | ✅ Implemented |
| Home tab: greeting, hero carousel, resume card, recommended rail | ✅ Implemented |
| Explore tab: category discovery, popular courses, "Untuk Kamu" | ✅ Implemented |
| Progress tab: stats panel, active/completed courses, pull-to-refresh | ✅ Implemented |
| Profile tab | ⚠️ Placeholder |
| Indonesian UI copy | ✅ |
| Light + dark theme | ✅ |

### In scope (planned)

- Course catalog browsing with real course data.
- Course detail, enrollment, lesson viewer.
- Quiz and practice surfaces.
- Persistent authentication and data via a backend API.
- Profile and settings completion.

### Out of scope (V1)

- Voice / camera interaction.
- AI conversation tutoring.
- Payments, subscriptions, or marketplace.
- Community, leaderboards, or social features.

---

## 5. Functional Requirements

### 5.1 Onboarding

- Present exactly three illustrated pages that introduce the app.
- Provide a primary CTA ("Mulai Belajar") that routes into authentication.
- The flow must not block returning users from reaching the shell.

### 5.2 Authentication

- Email/password sign in and account creation with validation (valid email, matching password confirmation).
- OTP verification screen for the confirmation code flow.
- Google sign-in surfaced as an option (mock-backed today).
- All strings in Bahasa Indonesia, human and encouraging (no raw error jargon).

### 5.3 Home

- Greet the user by name with a time-appropriate greeting (e.g. "Selamat siang").
- Surface a hero carousel with promotional/streak content.
- Show a dominant **"Progres Saya"** resume card: current course, lesson label, progress bar, continue action.
- Recommend courses in a horizontal rail.
- Provide clear paths to Explore ("Jelajahi Kursus", "Lihat Semua").

### 5.4 Explore

- Show a searchable catalog ("Jelajahi") with category discovery cards.
- Include a "Kursus Populer" (popular courses) horizontal rail.
- Include a "Untuk Kamu" (for you) personalized section.
- Use real technology brand logos for courses to signal concrete skills (Python, PHP, Java, etc.).

### 5.5 Progress

- Show a "Progres Belajar" page with a learning summary panel (Ringkasan Belajar).
- List active courses (with progress) and completed courses separately.
- Support pull-to-refresh.
- Provide an empty state that guides the user to explore courses.

### 5.6 Profile

- Show the account surface (currently a placeholder empty state).

---

## 6. Non-Functional Requirements

### UI copy and tone

- All user-facing text is Bahasa Indonesia.
- Tone is warm, direct, encouraging, never punitive or technical.
- Error and empty states must explain what happened and offer a next step.

### Visual direction

- **Modern, colorful, expressive, clean, premium.** Orange primary + purple secondary (exact tokens: `docs/design/brandidentity.md`).
- No "soft minimalism", muted-template look; the interface is deliberate and energetic while staying readable.

### Accessibility

- WCAG 2.1 AA: 4.5:1 text contrast, 48×48 px touch targets, keyboard/screen-reader labels, text scaling without overflow.
- Information is never conveyed by color alone.

### Responsiveness

- Screens must work from 320 px phones to tablet/desktop widths.
- Use the responsive container/padding helpers from the design system.

### Performance

- Screens render immediately from local data; no placeholder jank.
- Assets are lazy where practical (icons, illustrations).

---

## 7. Future Direction (Planned, Not Implemented)

These are documented as intent only. They are **not** built and are not to be documented as existing:

- **Backend API** (FastAPI) for authentication, courses, and progress.
- **Course detail + enrollment** and **lesson viewer**.
- **Quiz** and **practice** surfaces.
- **AI tutor** conversation assistant.
- **Voice and camera** interaction.

None of these should be described as implemented until they exist in the codebase. Architecture for future backend work belongs in `docs/architecture/`, not in this product document.
