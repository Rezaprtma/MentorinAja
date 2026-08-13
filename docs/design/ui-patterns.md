# UI Patterns — Screens

This document describes the recurring UI patterns and screen layouts used across MentorinAja. It is the reference for how any screen should be composed, including states, navigation, and responsiveness.

- **Status:** Authoritative
- **Last updated:** 2026-08-12
- **Companion docs:** design rules (`design-system.md`), brand (`brandidentity.md`)

---

## 1. Screen Taxonomy

Every screen fits one of three families:

| Family | Pattern | Examples |
|---|---|---|
| **Flow screens** | Full-screen, single focus, forward CTA | Splash, Onboarding, Auth |
| **Shell tabs** | Scrollable content, sectioned, tab shell | Home, Explore, Progress, Profile |
| **Detail/utility screens** | Pushed onto a tab, back affordance, focused task | Course detail (planned), settings (planned) |

---

## 2. Flow Screens

### Splash

- Full-bleed solid brand-orange surface (`AppColors.primary`), centered logo mark.
- No CTA; auto-advances to onboarding (first run) or shell (returning run).
- Duration ≈ 1.2 s with a subtle fade to the next screen.

### Onboarding

- One page per value proposition, three pages total.
- Pattern: illustration (top, ~55%) → title → body copy → progress indicator (dots).
- CTA "Mulai Belajar" advances; last page routes to authentication.
- Support "Lewati" (skip) in the top-right for returning first-run viewers.

### Authentication

- Split layout on desktop; single column on mobile.
- Pattern: brand lockup + tagline → form card → primary CTA → secondary link.
- Sign in and create account share one scaffold with different fields.
- OTP verification: label + 4–6 digit OTP field + resend countdown + verify CTA.
- Errors appear inline (field-level and banner-level for network/auth failures).

---

## 3. Shell Tabs

The app shell (`MainShell`) hosts four tabs via `IndexedStack`, preserving scroll state. Floating bottom navigation switches tabs.

### Home

Structure (top → bottom):

1. **Page header** — greeting ("Selamat siang, [Nama]") + avatar.
2. **Hero carousel** — horizontally swipeable promotional cards (page indicator, auto-height).
3. **"Progres Saya" resume card** — dominant card: course title, lesson label, progress bar, "Lanjutkan" CTA.
4. **"Jelajahi Kursus" section header** with "Lihat Semua" → Explore.
5. **Recommended course rail** — horizontal list of course cards.

States: loading (skeleton rail), error (banner + retry), empty (encourage explore).

### Explore

Structure:

1. **Page header** "Jelajahi" + search field (filters catalog).
2. **"Kursus Populer" rail** — horizontal course cards with tech logos.
3. **"Untuk Kamu" section** — responsive grid of full-bleed technology-brand category cards (each card identifies a learning area with its technology colors); switches to a filtered course grid while searching.

Behaviors: search filters category/courses; tapping a course card routes to course detail (planned).

### Progress

Structure:

1. **Page header** "Progres Belajar".
2. **Summary panel** ("Ringkasan Belajar") — stat cards: total courses, lessons done, completion %, streak.
3. **Active courses** — list of course cards with progress bars.
4. **Completed courses** — subdued list with completion badge.

Behaviors: pull-to-refresh; empty state when no courses started → CTA to Explore.

### Profile

Structure:

1. **Page header** "Profil".
2. Avatar + name/email block.
3. Settings rows: account, preferences, help, about (planned).
4. Currently a placeholder surface with an empty-state pattern until account data exists.

---

## 4. Common Patterns

### Course card (reused everywhere)

```
┌───────────────────────────────┐
│  [tech logo badge]  [level]   │
│  Course title (1–2 lines)     │
│  Meta: lessons · duration     │
│  [progress bar] [CTA chevron] │
└───────────────────────────────┘
```

- Renders real tech logos via `TechLogo`.
- Progress bar only when enrolled/in-progress.

### Stat card

```
┌──────────────┐
│  [icon]      │
│  12          │  <- display number
│  Kursus      │
└──────────────┘
```

### Section header

- Title (left) + optional "Lihat Semua" (right).
- Consistent bottom margin `AppSpacing.md`–`lg`.

### Empty state

- Illustration, title, one sentence, one primary CTA.
- Never dead content.

### Error / offline

- Inline banner at top of content + retry.
- Keep the page header visible; only the affected section fails.

---

## 5. Navigation Patterns

| Pattern | Rule |
|---|---|
| Tab switch | Preserves state (`IndexedStack`); no full-screen transition |
| Push (detail) | Slide-forward transition, back affordance in header |
| Flow (auth/onboarding) | Full-screen push, no bottom nav |
| Back gesture | Android predictive back supported |

- Route names are centralized (`route_names.dart`); screens never hardcode paths.
- Deep-linking (planned) will map URLs → routes through the same table.

---

## 6. Responsive Behavior per Pattern

| Pattern | Compact | Medium | Expanded |
|---|---|---|---|
| Flow screens | 1 column, card-centered | Same, wider form | Split layout (brand + form) |
| Course rails | Horizontal scroll | Horizontal scroll | Horizontal scroll or grid |
| Course grids | 1 col | 2 cols | 3–4 cols |
| Summary stats | 2×2 stat grid | 4 across | 4 across, larger |
| Bottom nav | Floating bar | Floating bar | Floating bar (or side rail, future) |

---

## 7. Copy Conventions in Patterns

- Greetings: time-aware ("Selamat pagi / siang / malam").
- CTAs: "Mulai", "Lanjutkan", "Lihat Semua", "Jelajahi Kursus", "Mulai Belajar".
- Section titles: "Progres Saya", "Kursus Populer", "Untuk Kamu", "Ringkasan Belajar".
- Errors: plain-language, action-oriented ("Coba lagi sebentar lagi").
