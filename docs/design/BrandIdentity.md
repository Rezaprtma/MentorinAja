# MentorinAja — Brand Identity Specification

**Status:** Authoritative v1.0
**Phase:** 5 — Brand Identity
**Scope:** Visual identity, design language, and brand standards
**Audience:** Designers, Flutter engineers, product managers, brand stakeholders
**Last updated:** 2026-08-04

---

This document is the permanent source of truth for the MentorinAja brand. Every future screen, illustration, animation, and piece of copy must conform to the standards defined here. This document does not implement anything — it defines the rules that implementation follows.

---

## Table of Contents

1. Brand Vision
2. Brand Personality
3. Color Strategy
4. Typography Strategy
5. Logo Strategy
6. Mascot Strategy
7. Illustration System
8. Icon System
9. Motion Design Guidelines
10. Asset Strategy
11. Accessibility Standards
12. Future Screen Direction
13. Design Consistency Rules
14. Scalability Review
15. Staff Engineer Review

---

## 1. Brand Vision

### Mission

MentorinAja exists to make quality education accessible, personal, and encouraging for every learner in Indonesia and beyond. We replace intimidation with companionship, confusion with clarity, and isolation with guided progress.

### Vision

A world where every student has a patient, intelligent tutor in their pocket — one that adapts to their pace, speaks their language, and makes learning feel like progress, not punishment.

### Personality

MentorinAja is:

- **A knowledgeable friend**, not a strict teacher. The product speaks with warmth and clarity, never condescension.
- **Calm under pressure**, not anxious. When a student struggles, the interface stays composed and supportive.
- **Quietly confident**, not loud. Premium quality is communicated through restraint, not excess.
- **Forward-looking**, not nostalgic. The design language signals intelligence and modernity without chasing trends.

### Brand Values

| Value             | What it means in product                                            |
| ----------------- | ------------------------------------------------------------------- |
| **Clarity**       | Every screen has one obvious next action. No confusion.             |
| **Encouragement** | Every interaction reinforces progress. Errors are learning moments. |
| **Calm**          | Visual noise is eliminated. Long sessions don't cause fatigue.      |
| **Intelligence**  | The AI tutor feels capable and responsive, not gimmicky.            |
| **Accessibility** | Every learner, regardless of ability, can use the product fully.    |
| **Trust**         | The product feels reliable, secure, and professional.               |

### Emotional Goals

When a student opens MentorinAja, they should feel:

1. **Safe** — "This won't judge me for not knowing."
2. **Capable** — "I can do this, one step at a time."
3. **Curious** — "I want to see what's next."
4. **Calm** — "This is a comfortable space to learn."

When a parent or teacher sees the product, they should feel:

1. **Confident** — "This is a serious, high-quality educational tool."
2. **Reassured** — "My student/child is in good hands."

### User Perception

The product should be perceived as:

- Premium but not expensive
- Smart but not intimidating
- Friendly but not childish
- Modern but not trendy
- Simple but not simplistic

---

## 2. Brand Personality

### Tone

The tone is **warm, direct, and encouraging**. It speaks like a trusted tutor who genuinely cares about the learner's progress.

| Context                           | Tone                             |
| --------------------------------- | -------------------------------- |
| Explaining a concept              | Patient, clear, uses analogies   |
| Giving feedback on a wrong answer | Constructive, never punitive     |
| Celebrating a correct answer      | Genuine, brief, motivating       |
| Error states                      | Apologetic but solution-oriented |
| Onboarding                        | Welcoming, sets expectations     |
| Settings / technical              | Precise, minimal, no jargon      |

### Voice

The voice is:

- **First-person plural** when referring to the learning journey: "Let's work through this together."
- **Second-person** when addressing the learner: "You're making great progress."
- **Never third-person** about the learner: Never "The user should..." in UI copy.

### Writing Style

- Short sentences. Maximum 15 words per sentence in UI copy.
- Active voice. "Tap to continue" not "The button should be tapped."
- Present tense. "This lesson covers..." not "This lesson will cover..."
- No jargon unless explaining a technical concept (then define it immediately).
- Bahasa Indonesia for primary UI. English for code, technical terms, and proper nouns.

### Microcopy Direction

| Element           | Example                                                                                              |
| ----------------- | ---------------------------------------------------------------------------------------------------- |
| Primary CTA       | "Mulai Belajar" (Start Learning)                                                                     |
| Secondary CTA     | "Nanti Saja" (Later)                                                                                 |
| Loading           | "Bentar ya, tutor sedang menyiapkan..." (Hold on, tutor is preparing...)                             |
| Success           | "Keren! Kamu sudah menguasai ini." (Awesome! You've mastered this.)                                  |
| Error (retryable) | "Yuk coba lagi." (Let's try again.)                                                                  |
| Error (fatal)     | "Ups, ada yang salah. Kita coba sekali lagi?" (Oops, something went wrong. Try once more?)           |
| Empty state       | "Belum ada pelajaran di sini. Mulai yang pertama!" (No lessons here yet. Start the first one!)       |
| Skeleton loading  | "Memuat..." (Loading...)                                                                             |
| Pull to refresh   | "Tarik untuk memperbarui" (Pull to refresh)                                                          |
| No internet       | "Sepertinya kamu offline. Cek koneksi internetmu ya." (Seems you're offline. Check your connection.) |

### Loading Messages

Loading messages should be:

- Brief (2-4 words maximum for inline loaders)
- Human, not robotic
- Occasionally playful (but never during error states)

Examples:

- "Bentar ya..." (Hold on...)
- "Tutor sedang berpikir..." (Tutor is thinking...)
- "Sebentar..." (One moment...)
- "Mempersiapkan..." (Preparing...)

### Error Messages

Error messages should:

1. Acknowledge the issue without blame
2. Explain what happened in plain language
3. Offer a clear next step

Never:

- "Error 500: Internal Server Error"
- "Something went wrong" (too vague)
- "Failed to load" (blames the network)

Always:

- "Koneksi internetmu terputus. Coba sambung ulang ya." (Your internet connection dropped. Try reconnecting.)
- "Ups, server sedang istirahat. Coba beberapa menit lagi." (Oops, server is resting. Try again in a few minutes.)

### Empty State Tone

Empty states should:

- Explain what's missing
- Explain why it matters
- Provide a clear action

Never: blank screen with just "No data."

Always: illustration + "Belum ada kursus yang kamu ikuti. Jelajahi katalog untuk memulai!" (No courses you're enrolled in yet. Browse the catalog to start!)

### AI Assistant Personality

The AI tutor ("Tutor") should feel:

- **Patient** — never rushes the learner
- **Encouraging** — celebrates small wins
- **Honest** — admits when something is tricky
- **Adaptive** — adjusts explanation depth based on learner responses
- **Concise** — respects the learner's time

Tutor should never:

- Lecture at length without checking understanding
- Use condescending language ("It's easy" / "Obviously...")
- Pretend to be human
- Make promises it can't keep

---

## 3. Color Strategy

### Foundation

The MentorinAja palette is built on a **warm primary orange** and a **cool electric indigo secondary**. This combination creates strong visual contrast while maintaining a clean, modern, energetic, and technology-focused identity.

The orange represents energy, action, and the core brand identity. The indigo represents learning, technology, intelligence, and supporting visual elements. Warm neutrals maintain readability and prevent the interface from becoming overly colorful.

### Color Architecture

| Role                | Token                | Hex       | Usage                                                |
| ------------------- | -------------------- | --------- | ---------------------------------------------------- |
| Primary             | `primary`            | `#F97316` | Primary actions, CTAs, active states, brand identity |
| Primary Container   | `primaryContainer`   | `#FFF7ED` | Cards, highlighted sections, badges                  |
| Primary Hover       | `primaryHover`       | `#EA580C` | Hover state for primary buttons                      |
| Primary Pressed     | `primaryPressed`     | `#C2410C` | Pressed/active state                                 |
| Primary Subtle      | `primarySubtle`      | `#FFFBF7` | Soft backgrounds and tinted surfaces                 |
| Secondary           | `secondary`          | `#514AF8` | Secondary actions, illustrations, informational UI   |
| Secondary Container | `secondaryContainer` | `#EEEDFF` | Information cards, secondary surfaces                |
| Secondary Hover     | `secondaryHover`     | `#4338CA` | Hover state for secondary buttons                    |
| Secondary Pressed   | `secondaryPressed`   | `#3730A3` | Pressed/active state                                 |
| Secondary Subtle    | `secondarySubtle`    | `#F5F3FF` | Soft indigo backgrounds and tinted surfaces          |
| Success             | `success`            | `#22C55E` | Success feedback, completed lessons                  |
| Success Container   | `successContainer`   | `#DCFCE7` | Success backgrounds                                  |
| Warning             | `warning`            | `#EAB308` | Attention needed, partial progress                   |
| Warning Container   | `warningContainer`   | `#FEFCE8` | Warning backgrounds                                  |
| Error               | `error`              | `#EF4444` | Errors, destructive actions                          |
| Error Container     | `errorContainer`     | `#FEF2F2` | Error backgrounds                                    |
| Neutral 900         | `neutral900`         | `#171717` | Primary text                                         |
| Neutral 800         | `neutral800`         | `#262626` | Headings, emphasis text                              |
| Neutral 700         | `neutral700`         | `#404040` | Body text                                            |
| Neutral 600         | `neutral600`         | `#525252` | Secondary text, captions                             |
| Neutral 500         | `neutral500`         | `#737373` | Placeholder text, muted labels                       |
| Neutral 400         | `neutral400`         | `#A3A3A3` | Disabled text, disabled icons                        |
| Neutral 300         | `neutral300`         | `#D4D4D4` | Borders, dividers                                    |
| Neutral 200         | `neutral200`         | `#E5E5E5` | Card borders, subtle surfaces                        |
| Neutral 100         | `neutral100`         | `#F5F5F5` | Page backgrounds                                     |
| Neutral 50          | `neutral50`          | `#FAFAFA` | Elevated surfaces                                    |
| White               | `white`              | `#FFFFFF` | Cards, dialogs, overlays                             |

### Brand Accent

| Role         | Token         | Hex       | Usage                                             |
| ------------ | ------------- | --------- | ------------------------------------------------- |
| Accent       | `accent`      | `#FDBA74` | Decorative highlights, gradients, subtle emphasis |
| Accent Light | `accentLight` | `#FED7AA` | Soft backgrounds, chips                           |
| Accent Dark  | `accentDark`  | `#EA580C` | Strong emphasis, premium highlights               |

### Secondary Accent

| Role                   | Token                  | Hex       | Usage                                    |
| ---------------------- | ---------------------- | --------- | ---------------------------------------- |
| Secondary Accent       | `secondaryAccent`      | `#818CF8` | Secondary highlights and illustrations   |
| Secondary Accent Dark  | `secondaryAccentDark`  | `#4338CA` | Strong secondary emphasis                |
| Secondary Accent Light | `secondaryAccentLight` | `#C7D2FE` | Soft decorative elements and backgrounds |

### Recommended Gradients

| Gradient           | Colors              | Usage                                      |
| ------------------ | ------------------- | ------------------------------------------ |
| Primary Gradient   | `#F97316 → #FDBA74` | Primary branded surfaces                   |
| Hero Gradient      | `#EA580C → #FB923C` | Hero sections and major visual elements    |
| Accent Gradient    | `#C2410C → #FDBA74` | Premium highlights                         |
| Brand Gradient     | `#F97316 → #514AF8` | Special brand moments, onboarding, hero UI |
| Secondary Gradient | `#514AF8 → #818CF8` | Secondary visual elements                  |

### Illustration Color Strategy

Illustrations should use the orange and indigo colors as complementary visual elements rather than distributing both colors equally.

#### Orange Background

| Element              | Color     |
| -------------------- | --------- |
| Background           | `#F97316` |
| Primary Illustration | `#FFFFFF` |
| Secondary Detail     | `#514AF8` |
| Outline              | `#171717` |
| Soft Detail          | `#FFF7ED` |

#### White Background

| Element              | Color     |
| -------------------- | --------- |
| Background           | `#FFFFFF` |
| Primary Illustration | `#514AF8` |
| Secondary Detail     | `#F97316` |
| Outline              | `#171717` |
| Soft Detail          | `#EEEDFF` |

#### Indigo Background

| Element              | Color     |
| -------------------- | --------- |
| Background           | `#514AF8` |
| Primary Illustration | `#FFFFFF` |
| Secondary Detail     | `#F97316` |
| Outline              | `#171717` |
| Soft Detail          | `#EEEDFF` |

### Splash Palette

| Element         | Color                  |
| --------------- | ---------------------- |
| Background      | `#FFFFFF`              |
| Logo            | `assets/icon/icon.svg` |
| Title           | `#171717`              |
| Dark Background | `#171717`              |
| Dark Title      | `#FFFFFF`              |

### Semantic Color Mapping

| Semantic Role         | Light Mode           | Dark Mode    |
| --------------------- | -------------------- | ------------ |
| Primary Interactive   | `primary`            | `#FB923C`    |
| Primary Container     | `primaryContainer`   | `#7C2D12`    |
| Secondary Interactive | `secondary`          | `#818CF8`    |
| Secondary Container   | `secondaryContainer` | `#312E81`    |
| Text Primary          | `neutral900`         | `neutral50`  |
| Text Secondary        | `neutral600`         | `neutral300` |
| Text Disabled         | `neutral400`         | `neutral600` |
| Text Inverse          | `white`              | `neutral900` |
| Background            | `neutral100`         | `neutral900` |
| Surface               | `white`              | `neutral800` |
| Surface Elevated      | `white`              | `neutral700` |
| Border                | `neutral300`         | `neutral600` |
| Border Subtle         | `neutral200`         | `neutral700` |
| Divider               | `neutral200`         | `neutral700` |
| Success               | `success`            | `#4ADE80`    |
| Warning               | `warning`            | `#FACC15`    |
| Error                 | `error`              | `#F87171`    |
| Info                  | `secondary`          | `#818CF8`    |

### Color Ratio Rules

The interface should remain primarily neutral, with orange and indigo used strategically.

| Color Category   | Recommended Usage |
| ---------------- | ----------------- |
| Neutrals         | 70–80%            |
| Primary Orange   | 10–15%            |
| Secondary Indigo | 5–10%             |
| Feedback Colors  | 2–5%              |

### Color Usage Principles

- `primary` (`#F97316`) is the dominant brand color.
- `secondary` (`#514AF8`) replaces the previous blue `#0EA5E9`.
- Orange should dominate primary interactions and brand identity.
- Indigo should support secondary actions, illustrations, information, and technology-related elements.
- Do not distribute orange and indigo equally across the interface.
- Use neutral colors for most backgrounds, surfaces, text, and structural elements.
- Use indigo more heavily in onboarding illustrations and secondary visual components.
- Use orange backgrounds with white and indigo illustrations for strong onboarding screens.
- Use white backgrounds with indigo illustrations and orange details for clean onboarding screens.
- Reserve the `#F97316 → #514AF8` gradient for special brand moments rather than general UI components.

### Contrast Rules

**Text contrast (WCAG 2.1 AA):**

| Background | Text Color | Usage                       |
| ---------- | ---------- | --------------------------- |
| `#FFFFFF`  | `#171717`  | Primary text                |
| `#FFFFFF`  | `#404040`  | Headings and body text      |
| `#FFFFFF`  | `#525252`  | Secondary text              |
| `#FFFFFF`  | `#C2410C`  | Small orange text           |
| `#FFFFFF`  | `#3730A3`  | Small indigo text           |
| `#171717`  | `#FFFFFF`  | Inverse text                |
| `#FFF7ED`  | `#C2410C`  | Text on primary container   |
| `#EEEDFF`  | `#3730A3`  | Text on secondary container |

Do not use `primary` (`#F97316`) or `secondary` (`#514AF8`) as small body text on light backgrounds when sufficient contrast is not achieved.

Use darker variants such as `primaryPressed` (`#C2410C`) and `secondaryPressed` (`#3730A3`) for small text.

### Dark Mode Adaptation

Dark mode uses `AppTheme.dark()` built from the same brand palette.

- Background shifts from `neutral100` to `neutral900`.
- Surface shifts from `white` to `neutral800`.
- Text colors invert for readability.
- Primary brightens from `#F97316` to `#FB923C`.
- Secondary brightens from `#514AF8` to `#818CF8`.
- Primary container shifts to `#7C2D12`.
- Secondary container shifts to `#312E81`.
- Feedback colors use lighter variants for accessibility.
- Elevation relies on subtle borders and tonal surfaces instead of heavy shadows.

### Animation on Color Change

When colors transition between states:

- Use `AppDurations.fast` (150ms) for color transitions.
- Use `AppEasing.standard` for natural motion.
- Do not animate page background colors.
- Animate button fills, progress indicators, tab indicators, toggles, and interactive surfaces only.

## 4. Typography Strategy

### Type System Architecture

MentorinAja uses a **dual-family type system**:

| Family                | Role                                 | Weight Range                          | Source       |
| --------------------- | ------------------------------------ | ------------------------------------- | ------------ |
| **Plus Jakarta Sans** | Headings, display, brand elements    | 400 (Regular) through 800 (ExtraBold) | Google Fonts |
| **Inter**             | Body text, UI labels, captions, code | 400 (Regular) through 700 (Bold)      | Google Fonts |
| **JetBrains Mono**    | Code snippets, technical content     | 400, 700                              | Google Fonts |

### Type Scale

| Token            | Size | Line Height | Weight | Family            | Usage                        |
| ---------------- | ---- | ----------- | ------ | ----------------- | ---------------------------- |
| `displayLarge`   | 32px | 40px        | 700    | Plus Jakarta Sans | Hero headings, splash screen |
| `displayMedium`  | 28px | 36px        | 700    | Plus Jakarta Sans | Section heroes               |
| `displaySmall`   | 24px | 32px        | 700    | Plus Jakarta Sans | Card hero headings           |
| `headlineLarge`  | 20px | 28px        | 600    | Plus Jakarta Sans | Page titles                  |
| `headlineMedium` | 18px | 26px        | 600    | Plus Jakarta Sans | Section titles               |
| `headlineSmall`  | 16px | 24px        | 600    | Plus Jakarta Sans | Card titles                  |
| `titleLarge`     | 16px | 24px        | 500    | Inter             | Subsection titles            |
| `titleMedium`    | 14px | 20px        | 600    | Inter             | List item titles, labels     |
| `titleSmall`     | 13px | 18px        | 500    | Inter             | Small titles, badges         |
| `bodyLarge`      | 16px | 24px        | 400    | Inter             | Primary body text            |
| `bodyMedium`     | 14px | 20px        | 400    | Inter             | Secondary body text          |
| `bodySmall`      | 12px | 16px        | 400    | Inter             | Captions, helper text        |
| `labelLarge`     | 14px | 20px        | 600    | Inter             | Button text, tab labels      |
| `labelMedium`    | 12px | 16px        | 500    | Inter             | Chip labels, small buttons   |
| `labelSmall`     | 11px | 14px        | 500    | Inter             | Badges, overlines            |
| `codeLarge`      | 16px | 24px        | 400    | JetBrains Mono    | Code blocks                  |
| `codeMedium`     | 14px | 20px        | 400    | JetBrains Mono    | Inline code                  |
| `codeSmall`      | 12px | 16px        | 400    | JetBrains Mono    | Code captions                |

### Hierarchy Rules

1. **Maximum 4 type styles per screen.** Excessive variety creates visual noise.
2. **Headings use Plus Jakarta Sans.** This creates instant brand recognition.
3. **Body uses Inter.** Optimized for reading at small sizes on screens.
4. **Code uses JetBrains Mono.** Always. No exceptions.
5. **Minimum body size is 14px.** Below this, readability degrades on mobile.
6. **Line height = font size + 8px for body, +6px for display.** This ensures comfortable reading.
7. **Letter spacing** — headings at `-0.01em`, body at `0`, small text at `+0.01em`.

### Weight Usage

| Weight | Name      | Usage                                           |
| ------ | --------- | ----------------------------------------------- |
| 400    | Regular   | Body text, captions, descriptions               |
| 500    | Medium    | Secondary headings, labels, emphasis            |
| 600    | SemiBold  | Primary headings, button text, important labels |
| 700    | Bold      | Display text, hero headings, brand elements     |
| 800    | ExtraBold | Splash screen brand name only                   |

### Color Assignment

| Text Role                       | Light Mode Color | Dark Mode Color            |
| ------------------------------- | ---------------- | -------------------------- |
| Heading                         | `neutral900`     | `neutral50`                |
| Body primary                    | `neutral700`     | `neutral300`               |
| Body secondary                  | `neutral600`     | `neutral400`               |
| Caption/helper                  | `neutral500`     | `neutral500`               |
| Disabled                        | `neutral400`     | `neutral600`               |
| Interactive (links)             | `primary`        | `primaryLight` (`#FF8A4D`) |
| Success feedback                | `success`        | `successLight` (`#22C55E`) |
| Error feedback                  | `error`          | `errorLight` (`#F87171`)   |
| On-primary (text on primary bg) | `white`          | `white`                    |
| On-success (text on success bg) | `white`          | `white`                    |
| On-error (text on error bg)     | `white`          | `white`                    |

### Responsive Typography

Typography scales based on screen width:

| Screen Width | Display | Headline | Body |
| ------------ | ------- | -------- | ---- |
| < 360px      | 24px    | 18px     | 14px |
| 360-599px    | 28px    | 20px     | 14px |
| 600-904px    | 32px    | 20px     | 16px |
| 905px+       | 32px    | 20px     | 16px |

This is implemented via `AppTypography.bodyLargeFrom(context)` which uses `MediaQuery.textScaleFactorOf(context)` and `LayoutBuilder`.

### Accessibility: Text Scaling

- All text sizes in the type scale are defined in logical pixels (dp)
- The system respects the user's device text scale factor
- No text element should use `fontSize` smaller than 11px (labelSmall minimum)
- When text scales up, layouts must not overflow — use `Flexible`/`Expanded` widgets
- Test at 1.0x, 1.3x, and 2.0x text scale factors

---

## 5. Logo Strategy

### Logo Anatomy

The MentorinAja logo consists of:

1. **Logomark** — A stylized "M" that subtly incorporates a graduation cap motif
2. **Logotype** — "MentorinAja" in Plus Jakarta Sans ExtraBold
3. **Tagline** (optional) — "Tutor AI untuk Semua" in Inter Regular

### Logo Variants

| Variant                    | When to Use                     | Format                              |
| -------------------------- | ------------------------------- | ----------------------------------- |
| **Primary (Light)**        | Light backgrounds               | Full color on white/neutral         |
| **Primary (Dark)**         | Dark backgrounds                | White logomark + white logotype     |
| **Logomark only**          | App icon, favicon, small spaces | Just the "M" symbol                 |
| **Monochrome (Black)**     | Print, single-color contexts    | Black on white                      |
| **Monochrome (White)**     | Reversed, dark backgrounds      | White on dark                       |
| **Adaptive (Android 13+)** | Android app icon                | Simplified "M" for mask             |
| **Splash**                 | Loading/splash screen           | Logomark centered with brand orange |

### Logo Clear Space

The minimum clear space around the logo is **1x the height of the logomark** on all sides. No text, images, or other elements may enter this zone.

```
┌───────────────────────────┐
│                           │
│     ┌───┐                 │
│     │ M │ ← clear space   │
│     └───┘   = 1x mark H   │
│                           │
└───────────────────────────┘
```

### Minimum Sizes

| Variant                 | Minimum Width | Minimum Height |
| ----------------------- | ------------- | -------------- |
| Full logo (mark + type) | 120px         | 32px           |
| Logomark only           | 24px          | 24px           |
| App icon                | 48px          | 48px           |
| Splash                  | 120px         | 120px          |

### Logo Don'ts

- Do not rotate the logo
- Do not stretch or distort the logo
- Do not change the logo colors (except switching between approved variants)
- Do not add effects (drop shadows, glows, outlines)
- Do not place the logo on busy photographic backgrounds without sufficient contrast
- Do not animate the logo (except splash screen entrance)
- Do not recreate the logo manually — always use the provided asset files

### Logo Files

All variants are available in:

- **SVG** — Scalable, for screens and digital
- **PNG** — Rasterized at 1x, 2x, 3x for specific sizes
- **WebP** — Optimized raster for web delivery

Stored in `frontend/assets/brand/` following the naming convention:

```
logo-primary-light.svg
logo-primary-dark.svg
logo-mark-only.svg
logo-mono-black.svg
logo-mono-white.svg
logo-adaptive.svg
logo-splash.png
```

### Logo on Backgrounds

| Background         | Logo Variant                                       |
| ------------------ | -------------------------------------------------- |
| White / neutral50  | Primary (light)                                    |
| Neutral900 / black | Primary (dark)                                     |
| Primary orange     | White mono                                         |
| Photography        | Primary (light) with semi-transparent overlay      |
| Gradient           | Primary (light) with subtle shadow for readability |

---

## 6. Mascot Strategy

### Concept

The MentorinAja mascot is a **friendly, wise owl** named **"Tutor"**. The owl represents wisdom, patience, and the ability to see clearly in the dark — a metaphor for guiding students through confusing material.

### Personality

- **Curious** — Tutor tilts head when thinking, shows genuine interest in the student's questions
- **Encouraging** — Tutor smiles, gives thumbs up, celebrates small wins
- **Patient** — Tutor never looks frustrated, even when explaining the same concept multiple times
- **Playful** — Tutor has subtle animations (blinking, bouncing) during loading states

### Visual Design

| Attribute    | Specification                                            |
| ------------ | -------------------------------------------------------- |
| Style        | Flat, geometric, modern — not cartoonish or childish     |
| Colors       | Uses brand palette: orange primary, neutral accents      |
| Proportions  | Slightly abstracted — large eyes, small body, expressive |
| Outlines     | None — flat fill style                                   |
| Detail level | Medium — recognizable at 48px, expressive at 120px+      |

### Mascot States

| State           | Expression                         | Usage                                  |
| --------------- | ---------------------------------- | -------------------------------------- |
| **Neutral**     | Calm, friendly, slight smile       | Default avatar, profile picture        |
| **Thinking**    | Head tilt, one eye slightly closed | Loading states, "Tutor is thinking..." |
| **Happy**       | Wide smile, bright eyes            | Success states, correct answers        |
| **Encouraging** | Thumbs up, warm expression         | Positive feedback, progress milestones |
| **Confused**    | Question mark above head, tilted   | When tutor doesn't understand input    |
| **Sleeping**    | Eyes closed, zzz                   | Idle state, inactive tutor             |
| **Waving**      | One wing raised                    | Greeting, onboarding, welcome back     |

### Size Guide

| Size   | Dimensions | Detail Level               | Usage                         |
| ------ | ---------- | -------------------------- | ----------------------------- |
| **XS** | 24x24px    | Silhouette only            | Inline avatar, list items     |
| **S**  | 32x32px    | Basic features visible     | Chat avatar, small cards      |
| **M**  | 48x48px    | Full expression            | Profile, section headers      |
| **L**  | 96x96px    | Detailed, animated capable | Empty states, loading screens |
| **XL** | 160x160px  | Full detail, animations    | Splash, onboarding hero       |

### Animation Principles

| Animation | Duration | Easing    | Usage                         |
| --------- | -------- | --------- | ----------------------------- |
| Blink     | 150ms    | standard  | Idle every 3-5 seconds        |
| Head tilt | 300ms    | standard  | Thinking state                |
| Bounce    | 400ms    | bouncy    | Success celebration           |
| Wave      | 600ms    | standard  | Greeting                      |
| Float     | 2000ms   | easeInOut | Loading idle (gentle up/down) |

### Where Tutor Appears

| Location             | State             | Size |
| -------------------- | ----------------- | ---- |
| Splash screen        | Neutral, animated | XL   |
| Onboarding           | Waving            | L    |
| Chat avatar          | Neutral/Thinking  | S    |
| Empty states         | Encouraging       | L    |
| Loading states       | Thinking          | M    |
| Profile picture      | Neutral           | M    |
| Error states         | Confused          | M    |
| Achievement unlocked | Happy + bounce    | M    |

### Where Tutor Does NOT Appear

- Settings screens (too functional)
- Payment/checkout (too sensitive)
- Legal text (too formal)
- Error logs/technical screens

### Mascot Don'ts

- Do not use Tutor in aggressive or negative contexts
- Do not distort Tutor's proportions
- Do not add accessories or clothing not in the approved design
- Do not use Tutor to replace error icons or status indicators
- Do not animate Tutor during reading-focused screens (distracting)

---

## 7. Illustration System

### Style

Illustrations follow a **flat, geometric, modern** style consistent with the mascot:

- **Flat fills** — no gradients within illustration elements (gradients only for backgrounds)
- **Brand palette** — illustrations use the MentorinAja color palette exclusively
- **Rounded forms** — friendly, approachable shapes
- **Minimal detail** — communicate concept clearly without visual overload
- **No outlines** — flat fill style, no stroked edges
- **Diverse representation** — when showing people, represent diverse backgrounds

### Illustration Categories

| Category         | Purpose                                  | Style Notes                               |
| ---------------- | ---------------------------------------- | ----------------------------------------- |
| **Empty States** | Explain missing content + provide action | Tutor character + minimal scene           |
| **Onboarding**   | Welcome, explain features                | Hero illustrations, larger, more detail   |
| **Success**      | Celebrate achievements                   | Confetti, progress bars, happy characters |
| **Error**        | Explain problems + solutions             | Tutor confused, simple visual metaphor    |
| **Subject**      | Represent academic subjects              | Abstract representations, not literal     |
| **Loading**      | Progress indication                      | Tutor thinking, gears turning             |

### Subject Illustrations

| Subject             | Visual Metaphor                       | Colors              |
| ------------------- | ------------------------------------- | ------------------- |
| Mathematics         | Geometric shapes, equations floating  | Primary + neutral   |
| Science             | Beaker, atoms, molecules              | Secondary + primary |
| Indonesian Language | Book, letters, pen                    | Primary + neutral   |
| English Language    | Globe, speech bubbles                 | Secondary + neutral |
| History             | Timeline, ancient building silhouette | Primary + neutral   |
| Geography           | Map contours, compass                 | Secondary + primary |
| Economics           | Chart, coins, graph                   | Primary + neutral   |

### Empty State Illustrations

Every empty state must include:

1. **Illustration** — Tutor character in relevant context (max 160x160px)
2. **Title** — What's missing (2-4 words, headlineSmall)
3. **Description** — Why it matters + what to do (1-2 sentences, bodyMedium)
4. **Action** — Primary CTA button to resolve

### Size Guide

| Size          | Dimensions | Detail             | Usage                          |
| ------------- | ---------- | ------------------ | ------------------------------ |
| **Thumbnail** | 64x64px    | Minimal, icon-like | Inline placeholders            |
| **Card**      | 120x120px  | Medium detail      | Card empty states              |
| **Section**   | 160x160px  | Full detail        | Page-level empty states        |
| **Hero**      | 240x240px  | Maximum detail     | Onboarding, splash backgrounds |

### Illustration File Format

All illustrations stored as SVG (scalable) in `frontend/assets/illustrations/`:

```
empty-state/
  no-courses.svg
  no-results.svg
  no-notifications.svg
  no-chat-history.svg
  offline.svg
onboarding/
  welcome.svg
  ai-tutor.svg
  progress-tracking.svg
  personalized-learning.svg
success/
  achievement.svg
  milestone.svg
  completion.svg
error/
  not-found.svg
  server-error.svg
  connection-lost.svg
subjects/
  mathematics.svg
  science.svg
  indonesian.svg
  english.svg
  history.svg
  geography.svg
  economics.svg
```

### Illustration Don'ts

- Do not use photographic images as illustrations
- Do not use gradients within illustration elements
- Do not add text to illustrations (text goes in the UI)
- Do not use illustrations larger than 240x240px in content areas
- Do not animate illustrations (except loading spinners)
- Do not use more than 2 illustration categories on one screen

---

## 8. Icon System

### Icon Library

MentorinAja uses **Material Symbols Rounded** for all UI icons. This provides:

- Consistent visual language across the app
- Automatic optical size adjustment
- Variable weight support for emphasis control
- Wide coverage of common UI patterns

### Icon Sizes

| Token        | Size | Usage                                 |
| ------------ | ---- | ------------------------------------- |
| `iconXs`     | 12px | Inline badges, superscript indicators |
| `iconSmall`  | 16px | Compact UI, chip icons                |
| `iconMedium` | 20px | Standard UI, list item icons          |
| `iconLarge`  | 24px | Default interactive icons             |
| `iconXl`     | 32px | Feature icons, card headers           |
| `iconXxl`    | 48px | Hero icons, empty state icons         |

### Icon Weights

| Weight        | Usage                               |
| ------------- | ----------------------------------- |
| 300 (Light)   | Decorative, large hero icons        |
| 400 (Regular) | Default for all UI icons            |
| 500 (Medium)  | Emphasized icons, active states     |
| 600 (Bold)    | Important indicators, notifications |

### Icon Colors

Icons inherit color from their parent `DefaultTextStyle` or use explicit `color` parameter:

| Context               | Color        |
| --------------------- | ------------ |
| Default               | `neutral700` |
| Active/Selected       | `primary`    |
| Disabled              | `neutral400` |
| On primary background | `white`      |
| Success state         | `success`    |
| Error state           | `error`      |
| Info state            | `secondary`  |

### Custom Icons

For icons not available in Material Symbols, create custom SVG icons in `frontend/assets/icons/`:

```
custom/
  tutor-avatar.svg
  graduation-cap.svg
  ai-sparkle.svg
  streak-flame.svg
  achievement-badge.svg
```

Custom icons follow the same size and color rules as Material Symbols.

### Icon + Text Pairing

| Pattern              | Icon Position    | Spacing        |
| -------------------- | ---------------- | -------------- |
| Leading icon + text  | Left of text     | 8px gap        |
| Trailing icon + text | Right of text    | 8px gap        |
| Icon-only button     | Centered         | N/A            |
| Stacked icon + label | Above text       | 4px gap        |
| Inline icon in text  | Baseline-aligned | 4px horizontal |

### Icon Don'ts

- Do not mix icon styles (e.g., Material Symbols with FontAwesome)
- Do not use icon-only buttons without tooltips or semantic labels
- Do not animate icons (except loading spinners and progress indicators)
- Do not use icons smaller than 12px
- Do not use more than 2 icons per list item
- Do not replace text with icons in critical UI (accessibility)

---

## 9. Motion Design Guidelines

### Motion Philosophy

Motion in MentorinAja serves three purposes:

1. **Orientation** — helping users understand where they are and how they got there
2. **Feedback** — confirming that an action was received and processed
3. **Delight** — adding personality without distraction

Motion must always feel **purposeful, smooth, and calm**. Never gratuitous.

### Easing Curves

| Token                  | Curve                               | Usage                                 |
| ---------------------- | ----------------------------------- | ------------------------------------- |
| `standard`             | `cubic-bezier(0.2, 0.0, 0, 1.0)`    | Default for most transitions          |
| `emphasized`           | `cubic-bezier(0.2, 0.0, 0, 1.0)`    | Page transitions, major state changes |
| `emphasizedDecelerate` | `cubic-bezier(0.05, 0.7, 0.1, 1.0)` | Entering elements                     |
| `emphasizedAccelerate` | `cubic-bezier(0.3, 0.0, 0.8, 0.15)` | Exiting elements                      |
| `standardDecelerate`   | `cubic-bezier(0.0, 0.0, 0, 1.0)`    | Entering non-critical elements        |
| `standardAccelerate`   | `cubic-bezier(0.3, 0.0, 1, 1.0)`    | Exiting non-critical elements         |

### Duration Scale

| Token     | Duration | Usage                               |
| --------- | -------- | ----------------------------------- |
| `fastest` | 75ms     | Micro-interactions (ripple, toggle) |
| `faster`  | 150ms    | Button press, icon transforms       |
| `fast`    | 200ms    | Simple opacity/color changes        |
| `normal`  | 300ms    | Standard transitions (cards, lists) |
| `medium`  | 400ms    | Page transitions, modals            |
| `slow`    | 500ms    | Complex choreography                |
| `slower`  | 600ms    | Splash screen, onboarding sequences |

### Transition Presets

| Preset           | Duration | Easing             | Properties                  |
| ---------------- | -------- | ------------------ | --------------------------- |
| `fadeIn`         | 200ms    | standardDecelerate | opacity: 0→1                |
| `fadeOut`        | 150ms    | standardAccelerate | opacity: 1→0                |
| `slideUp`        | 300ms    | emphasized         | offset: +20→0, opacity: 0→1 |
| `slideDown`      | 300ms    | emphasized         | offset: -20→0, opacity: 0→1 |
| `slideLeft`      | 300ms    | emphasized         | offset: +30→0, opacity: 0→1 |
| `slideRight`     | 300ms    | emphasized         | offset: -30→0, opacity: 0→1 |
| `scaleIn`        | 200ms    | emphasized         | scale: 0.95→1, opacity: 0→1 |
| `expandCollapse` | 300ms    | standard           | height: 0→auto              |

### Page Transitions

| Transition     | Direction         | Duration |
| -------------- | ----------------- | -------- |
| Push (forward) | Slide from right  | 300ms    |
| Pop (back)     | Slide from left   | 300ms    |
| Modal open     | Slide from bottom | 400ms    |
| Modal close    | Slide to bottom   | 300ms    |
| Tab switch     | Cross-fade        | 200ms    |
| Drawer open    | Slide from left   | 300ms    |

### Loading Animations

| Type             | Style                     | Duration            |
| ---------------- | ------------------------- | ------------------- |
| Skeleton shimmer | Horizontal gradient sweep | 1500ms loop         |
| Spinner          | Rotating arc              | 800ms loop          |
| Pulse            | Opacity 0.3→1→0.3         | 1500ms loop         |
| Progress bar     | Width 0→100%              | Determinate: varies |
| Tutor thinking   | Head tilt + blink         | 2000ms loop         |

### Gesture Animations

| Gesture         | Response                           |
| --------------- | ---------------------------------- |
| Tap             | Ripple effect (150ms)              |
| Long press      | Slight scale down (100ms) + haptic |
| Swipe to delete | Item slides out (200ms)            |
| Pull to refresh | Spinner appears (200ms)            |
| Scroll          | Parallax on header (continuous)    |

### Reduced Motion

When `MediaQuery.disableAnimations` is true or the user has enabled "Reduce Motion" in accessibility settings:

- All `AnimatedContainer`, `AnimatedOpacity`, `SlideTransition`, `ScaleTransition` use zero duration
- Page transitions become instant cross-fade (200ms max)
- Loading spinners become static indicators
- Skeleton shimmer becomes static gray background
- Tutor animations are disabled
- Gesture feedback uses opacity change only (no scale)

### Motion Don'ts

- Do not animate more than 3 elements simultaneously
- Do not use bounce easing for page transitions
- Do not add motion to text appearing (causes reading difficulty)
- Do not use motion as the only indicator of state change (always pair with color/text)
- Do not exceed 600ms for any single animation
- Do not animate layout properties (width, height) on frequently-updated elements

---

## 10. Asset Strategy

### Asset Organization

```
frontend/assets/
  brand/
    logo-primary-light.svg
    logo-primary-dark.svg
    logo-mark-only.svg
    logo-mono-black.svg
    logo-mono-white.svg
    logo-adaptive.svg
    logo-splash.png
  mascot/
    tutor-neutral.svg
    tutor-thinking.svg
    tutor-happy.svg
    tutor-encouraging.svg
    tutor-confused.svg
    tutor-sleeping.svg
    tutor-waving.svg
  illustrations/
    empty-state/
    onboarding/
    success/
    error/
    subjects/
  icons/
    custom/
  animations/
    lottie/
    rive/
  audio/
    correct.wav
    incorrect.wav
    notification.wav
    achievement.wav
  fonts/
    PlusJakartaSans-Regular.ttf
    PlusJakartaSans-Medium.ttf
    PlusJakartaSans-SemiBold.ttf
    PlusJakartaSans-Bold.ttf
    PlusJakartaSans-ExtraBold.ttf
    Inter-Regular.ttf
    Inter-Medium.ttf
    Inter-SemiBold.ttf
    Inter-Bold.ttf
    JetBrainsMono-Regular.ttf
    JetBrainsMono-Bold.ttf
  locales/
    id.json
    en.json
```

### Asset Naming Convention

| Pattern       | Example                                 |
| ------------- | --------------------------------------- |
| Brand assets  | `logo-{variant}.svg`                    |
| Mascot states | `tutor-{state}.svg`                     |
| Illustrations | `{category}-{topic}.svg`                |
| Custom icons  | `{name}.svg`                            |
| Animations    | `{name}.json` (Lottie) or `.riv` (Rive) |
| Audio         | `{purpose}.{format}`                    |
| Fonts         | `{Family}-{Weight}.ttf`                 |
| Locales       | `{language_code}.json`                  |

### Asset Loading Strategy

| Asset Type    | Loading                 | Caching                 |
| ------------- | ----------------------- | ----------------------- |
| Fonts         | Preloaded at startup    | Always cached           |
| Logo (splash) | Preloaded at startup    | Always cached           |
| Brand assets  | Preloaded at startup    | Always cached           |
| Mascot        | Preloaded at startup    | Always cached           |
| Illustrations | Lazy load on first use  | Cached after first load |
| Custom icons  | Lazy load on first use  | Cached after first load |
| Animations    | Lazy load on first use  | Cached after first load |
| Audio         | Lazy load on first play | Cached after first play |

### Asset Precaching

At app startup, the following assets are precached via `AssetPrecacher`:

1. Logo (splash screen)
2. All mascot states
3. Empty state illustrations (most common: no-courses, no-results, offline)
4. Onboarding illustrations
5. All fonts

### Asset Size Budgets

| Category            | Maximum Total | Per-Asset Maximum |
| ------------------- | ------------- | ----------------- |
| SVG illustrations   | 500KB total   | 50KB each         |
| PNG images          | 2MB total     | 200KB each        |
| Animations (Lottie) | 300KB total   | 100KB each        |
| Audio               | 1MB total     | 200KB each        |
| Fonts               | 2MB total     | 400KB each        |

### Asset Optimization

- SVGs must be optimized (remove metadata, unnecessary attributes)
- PNGs must be compressed (use TinyPNG or equivalent)
- Lottie animations must be exported at final render size (not scaled)
- Audio files must be compressed (128kbps MP3 or equivalent AAC)
- Fonts must use `subset` option to include only Latin + Latin-Extended characters

### Image Resolution

| Target          | Resolution    | Format                       |
| --------------- | ------------- | ---------------------------- |
| App icon        | 1024x1024     | PNG                          |
| Splash          | 1080x1920     | PNG                          |
| Logo variants   | Vector (SVG)  | SVG                          |
| Illustrations   | Vector (SVG)  | SVG                          |
| Photos (if any) | 2x resolution | WebP preferred, PNG fallback |

---

## 11. Accessibility Standards

### WCAG 2.1 Compliance

MentorinAja targets **WCAG 2.1 Level AA** compliance. This includes:

### Color Contrast

| Element                          | Minimum Ratio | Standard |
| -------------------------------- | ------------- | -------- |
| Normal text (< 18px)             | 4.5:1         | AA       |
| Large text (≥ 18px or 14px bold) | 3:1           | AA       |
| UI components                    | 3:1           | AA       |
| Focus indicators                 | 3:1           | AA       |

### Touch Targets

| Element       | Minimum Size             | Standard   |
| ------------- | ------------------------ | ---------- |
| Buttons       | 48x48px                  | WCAG 2.5.5 |
| Icons         | 48x48px (touch area)     | WCAG 2.5.5 |
| List items    | Full width x 48px height | WCAG 2.5.5 |
| Tab bar items | 48x48px                  | WCAG 2.5.5 |

### Text Scaling

- All text respects system text scale factor
- No text smaller than 11px (labelSmall minimum)
- Layouts must not overflow at 2.0x text scale
- Test at 1.0x, 1.3x, and 2.0x

### Screen Reader Support

Every interactive element must have:

1. **Semantics label** — describes what the element is
2. **Semantics hint** — describes what happens when activated (if not obvious)
3. **Semantics role** — implicit from widget type (button, link, heading)

Examples:

```dart
Semantics(
  label: 'Mulai Belajar',
  hint: 'Tap untuk memulai pelajaran',
  button: true,
  child: AppButton(...),
)
```

### Focus Management

- Logical focus order follows visual layout (top-to-bottom, left-to-right)
- Focus indicators are visible (3:1 contrast minimum)
- Modal dialogs trap focus within the dialog
- Focus returns to triggering element when dialog closes
- Skip navigation link available for screen readers

### Animation Accessibility

- All animations respect `MediaQuery.disableAnimations`
- No animation loops indefinitely (except loading indicators)
- No flash frequency above 3 Hz (seizure risk)
- Content is understandable without any animation

### Color Independence

- Information is never conveyed by color alone
- Always pair color with: icon, text label, or pattern
- Example: error state uses red color + error icon + error text

### Language

- All UI text has a language attribute
- Bahasa Indonesia is the primary language
- Language switcher available in settings

### Testing Checklist

| Test            | Tool                                      | Frequency     |
| --------------- | ----------------------------------------- | ------------- |
| Color contrast  | Chrome DevTools, Colour Contrast Analyser | Every PR      |
| Screen reader   | TalkBack (Android), VoiceOver (iOS)       | Every release |
| Text scaling    | Device settings at 2.0x                   | Every release |
| Focus order     | Keyboard navigation (external keyboard)   | Every release |
| Touch targets   | Manual measurement                        | Every PR      |
| Reduced motion  | Device accessibility settings             | Every release |
| Semantic labels | Flutter semantic viewer                   | Every PR      |

---

## 12. Future Screen Direction

### Phase 6+ Screen Roadmap

The brand identity defined here will be applied to the following future screens (out of scope for Phases 1-5, documented here for design consistency):

| Phase | Screens                    | Brand Elements Used                           |
| ----- | -------------------------- | --------------------------------------------- |
| 6     | Onboarding (3 screens)     | Illustrations, mascot, typography, color      |
| 7     | Home dashboard             | Cards, color system, typography hierarchy     |
| 8     | Course catalog + search    | List layouts, badges, chips, filters          |
| 9     | Course detail + enrollment | Hero layout, progress, CTA hierarchy          |
| 10    | AI chat interface          | Chat bubbles, mascot states, typing indicator |
| 11    | Lesson viewer              | Content layout, code highlighting, navigation |
| 12    | Quiz/assessment            | Form inputs, feedback colors, animations      |
| 13    | Progress dashboard         | Charts, progress bars, achievement badges     |
| 14    | Profile + settings         | Forms, toggles, list items, dark mode         |
| 15    | Notifications              | Cards, badges, empty states                   |
| 16    | Payment/subscription       | Trust indicators, form validation             |

### Design Consistency for Future Phases

Every future screen must:

1. Use tokens from `core/theme/` — never hardcode colors, sizes, or durations
2. Use widgets from `shared/design_system//` — never build buttons, inputs, cards from scratch
3. Use illustrations from `assets/illustrations/` — never use placeholder images
4. Use the mascot from `assets/mascot/` — for all empty states and loading
5. Use fonts from `core/assets/app_fonts.dart` — never hardcode font families
6. Use spacing from `AppSpacing` — never hardcode padding/margin values
7. Use radius from `AppRadius` — never hardcode border radius
8. Follow the color ratio rules — 70-80% neutral, 15-20% primary

### Dark Mode Support

All future screens must support dark mode from day one:

- Use `AppColors.neutral*` for backgrounds (adapts to theme)
- Use `AppColors.primary*` for accents (stays consistent)
- Test every screen in both light and dark mode
- Use `AppTheme.light()` and `AppTheme.dark()` — never build custom themes

---

## 13. Design Consistency Rules

### Rule 1: Token-First Design

Every visual property must use a design token. No exceptions.

| Property      | Token Source      | Example                        |
| ------------- | ----------------- | ------------------------------ |
| Color         | `AppColors.*`     | `AppColors.primary`            |
| Typography    | `AppTypography.*` | `AppTypography.headlineMedium` |
| Spacing       | `AppSpacing.*`    | `AppSpacing.md`                |
| Border radius | `AppRadius.*`     | `AppRadius.medium`             |
| Elevation     | `AppElevation.*`  | `AppElevation.medium`          |
| Duration      | `AppDurations.*`  | `AppDurations.normal`          |
| Icon size     | `AppIconSizes.*`  | `AppIconSizes.iconLarge`       |

### Rule 2: Widget Reuse

Before building any UI element, check if it exists in `shared/design_system/`:

| Element    | Widget                                                                             |
| ---------- | ---------------------------------------------------------------------------------- |
| Button     | `AppButton.primary`, `AppButton.secondary`, `AppButton.outlined`, `AppButton.text` |
| Input      | `AppTextField`, `AppPasswordField`, `AppSearchBar`                                 |
| Card       | `AppCard.elevated`, `AppCard.outlined`, `AppCourseCard`                            |
| Avatar     | `AppAvatar.network`, `AppAvatar.asset`, `AppAvatar.initials`                       |
| Badge      | `AppBadge`, `AppStatusBadge`                                                       |
| Chip       | `AppFilterChip`                                                                    |
| Dialog     | `AppDialog`, `AppConfirmDialog`, `AppInfoDialog`                                   |
| Loader     | `AppSpinner`, `AppSkeleton`, `AppLoadingOverlay`                                   |
| Feedback   | `AppEmptyState`, `AppErrorView`, `AppSuccessOverlay`                               |
| Navigation | `AppBottomNav`, `AppNavBar`, `AppDrawer`, `AppTabBar`                              |
| List       | `AppListTile`, `AppSettingsTile`, `AppNotificationTile`                            |
| Layout     | `ResponsiveContainer`, `AdaptiveGrid`, `AdaptiveColumn`                            |

### Rule 3: Spacing Grid

All spacing must use the 8pt grid:

| Token  | Value | Usage                             |
| ------ | ----- | --------------------------------- |
| `xxs`  | 4px   | Tight spacing (icon-text gap)     |
| `xs`   | 8px   | Compact spacing (chip padding)    |
| `sm`   | 12px  | Small spacing (list item padding) |
| `md`   | 16px  | Standard spacing (card padding)   |
| `lg`   | 24px  | Section spacing                   |
| `xl`   | 32px  | Large section spacing             |
| `xxl`  | 40px  | Page section spacing              |
| `xxxl` | 48px  | Major section spacing             |

Never use arbitrary values like 13px, 17px, or 22px.

### Rule 4: Hierarchy Consistency

Every screen must follow this visual hierarchy:

1. **Page title** — `headlineLarge` or `headlineMedium`
2. **Section titles** — `headlineSmall` or `titleLarge`
3. **Card titles** — `headlineSmall` or `titleMedium`
4. **Body text** — `bodyLarge` or `bodyMedium`
5. **Captions** — `bodySmall`
6. **Labels** — `labelLarge`, `labelMedium`, `labelSmall`

Maximum 4 type styles per screen.

### Rule 5: Color Proportion

Every screen must maintain:

- 70-80% neutral colors (backgrounds, text, borders)
- 15-20% primary color (CTAs, active states, accents)
- 3-5% secondary color (links, info badges)
- 2-5% feedback colors (success, warning, error)

If a screen feels "too colorful," reduce feedback color usage. If it feels "too bland," increase primary accent usage.

### Rule 6: Empty State Pattern

Every list, tab, or section that can be empty must include:

1. Illustration (160x160px max)
2. Title (2-4 words)
3. Description (1-2 sentences)
4. Action button (if actionable)

Never show a blank screen.

### Rule 7: Error State Pattern

Every screen must handle errors gracefully:

1. Error illustration (120x120px max)
2. Error title (what happened)
3. Error description (plain language)
4. Retry button (if recoverable)
5. Home button (if critical)

Never show a raw error message.

### Rule 8: Loading State Pattern

Every screen must show loading state:

1. Skeleton screen (preferred) or spinner
2. Loading message ("Memuat..." or contextual)
3. Minimum 300ms display time (prevent flash)

Never show a blank screen during loading.

---

## 14. Scalability Review

### Asset System Scalability

| Concern            | Solution                                                                 |
| ------------------ | ------------------------------------------------------------------------ |
| New mascot states  | Add SVG to `assets/mascot/`, update `AppMascotState` enum                |
| New illustrations  | Add SVG to `assets/illustrations/{category}/`, update `AppIllustrations` |
| New custom icons   | Add SVG to `assets/icons/custom/`, update `AppCustomIcons`               |
| New animations     | Add Lottie/Rive to `assets/animations/`, update barrels                  |
| New audio          | Add to `assets/audio/`, update `AppAudio`                                |
| New fonts          | Add TTF to `assets/fonts/`, update `AppFontFamilies`                     |
| New locales        | Add JSON to `assets/locales/`, update `AppLocales`                       |
| New brand variants | Add SVG to `assets/brand/`, update `AppLogo`                             |

### Theme System Scalability

| Concern             | Solution                                 |
| ------------------- | ---------------------------------------- |
| New semantic color  | Add to `AppColors` + `AppThemeExtension` |
| New type scale step | Add to `AppTypeScale` + `AppTypography`  |
| New radius preset   | Add to `AppRadius`                       |
| New elevation level | Add to `AppElevation`                    |
| New duration        | Add to `AppDurations`                    |
| New easing          | Add to `AppEasing`                       |
| New icon size       | Add to `AppIconSizes`                    |
| New spacing step    | Add to `AppSpacing`                      |

### Widget System Scalability

| Concern                | Solution                                  |
| ---------------------- | ----------------------------------------- |
| New button variant     | Extend `AppButton` with named constructor |
| New input type         | Add to `shared/design_system/inputs/`     |
| New card layout        | Add to `shared/design_system/cards/`      |
| New feedback widget    | Add to `shared/design_system/feedback/`   |
| New navigation pattern | Add to `shared/design_system/navigation/` |
| New list item          | Add to `shared/design_system/lists/`      |
| New layout helper      | Add to `shared/design_system/layout/`     |

### Brand Identity Scalability

| Concern                     | Solution                                       |
| --------------------------- | ---------------------------------------------- |
| New product line            | Create sub-brand variant in `brand/`           |
| New platform (web, desktop) | Apply same tokens, adjust density              |
| New language                | Add locale JSON, update RTL support if needed  |
| New accessibility need      | Add to accessibility checklist, update testing |

### Maintenance Cadence

| Task                                  | Frequency   | Owner                |
| ------------------------------------- | ----------- | -------------------- |
| Asset audit (unused assets)           | Quarterly   | Designer             |
| Token review (are tokens sufficient?) | Quarterly   | Designer + Engineer  |
| Accessibility audit                   | Bi-annually | Designer + QA        |
| Brand consistency review              | Bi-annually | Designer             |
| Performance audit (asset sizes)       | Quarterly   | Engineer             |
| Color contrast verification           | Every PR    | Engineer (automated) |

---

## 15. Staff Engineer Review

### Completeness Checklist

- [x] Brand vision and values defined
- [x] Brand personality and tone defined
- [x] Color strategy with semantic mapping
- [x] Typography strategy with hierarchy rules
- [x] Logo strategy with usage rules
- [x] Mascot strategy with states and sizes
- [x] Illustration system with categories and sizes
- [x] Icon system with Material Symbols integration
- [x] Motion design guidelines with easing and duration
- [x] Asset strategy with organization and budgets
- [x] Accessibility standards with WCAG 2.1 AA targets
- [x] Future screen direction for Phase 6+
- [x] Design consistency rules (8 rules)
- [x] Scalability review for all systems
- [x] Staff engineer review (this section)

### Quality Criteria

| Criterion              | Status | Notes                                                                |
| ---------------------- | ------ | -------------------------------------------------------------------- |
| All tokens documented  | ✅     | Colors, typography, spacing, radius, elevation, duration, icon sizes |
| All widgets documented | ✅     | 54+ widgets in shared/design_system/                                 |
| All assets documented  | ✅     | 14 files in core/assets/, 9 files in shared/widgets/asset/           |
| Dark mode support      | ✅     | Full ColorScheme in AppColors, AppTheme.dark()                       |
| Accessibility targets  | ✅     | WCAG 2.1 AA, touch targets, screen reader, text scaling              |
| Performance budgets    | ✅     | Asset size limits defined                                            |
| Scalability paths      | ✅     | Extension points for all systems                                     |
| Future direction       | ✅     | Phase 6+ screen roadmap                                              |

### Open Questions

| Question               | Status       | Resolution                                      |
| ---------------------- | ------------ | ----------------------------------------------- |
| Figma design files?    | Pending      | Need to create Figma file matching this spec    |
| Asset export pipeline? | Pending      | Need to set up Figma → SVG export workflow      |
| Animation authoring?   | Pending      | Need Lottie/Rive authoring environment          |
| Audio recording?       | Pending      | Need to record/license audio assets             |
| Font licensing?        | ✅           | Google Fonts — open source, no licensing issues |
| RTL support?           | Out of scope | Bahasa Indonesia is LTR only                    |
| Web platform?          | Out of scope | Phase 7+ consideration                          |

### Risk Assessment

| Risk                      | Likelihood | Impact | Mitigation                                    |
| ------------------------- | ---------- | ------ | --------------------------------------------- |
| Asset sizes exceed budget | Low        | Medium | SVG optimization, lazy loading                |
| Dark mode contrast issues | Medium     | High   | Automated contrast checking                   |
| Screen reader gaps        | Medium     | High   | Semantic labels on all interactive elements   |
| Animation performance     | Low        | Medium | Reduced motion fallback, GPU-accelerated only |
| Font loading FOUT         | Low        | Low    | Preloaded fonts, system font fallback         |

### Sign-Off

This brand identity specification is complete and ready for implementation in Phase 6+. All design tokens, widgets, assets, and guidelines are documented and consistent with the existing Flutter codebase.

**Next action:** Begin Phase 6 (Onboarding Screens) using this specification as the design source of truth.

---

_This document is the authoritative brand identity specification for MentorinAja. All future design and implementation work must conform to the standards defined here._
