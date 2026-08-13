# MentorinAja — Brand Identity

This document defines the MentorinAja visual brand: its direction, color roles, type, surface language, and tone of voice. It is the **single source of truth** for how the product looks and feels.

- **Status:** Authoritative
- **Last updated:** 2026-08-13
- **Companion docs:** design tokens (`design-system.md`), screen patterns (`ui-patterns.md`)

---

## A. Personality

MentinorinAja is **energetic, warm, and credible** — a modern learning interface that leads with confident color while staying readable and calm under density. It is deliberately *not* generic or minimal: color is the hero, and every surface reinforces a sense of progress.

**Core traits:**

| Trait | What it means |
|---|---|
| **Modern** | Material 3, fresh type, rounded geometry, contemporary spacing. |
| **Colorful** | Color is a first-class element — used to guide, delight, and differentiate, never as noise. |
| **Expressive** | The interface has personality: warm microcopy, friendly illustration, playful accents. |
| **Clean** | Surfaces stay tidy: restrained card styles, clear hierarchy, generous whitespace. |
| **Premium** | Polish, consistency, and attention to detail at every state (hover, pressed, empty, loading). |

## B. Visual Direction

- **Orange is the hero, indigo is the wingman, white keeps it calm.** One dominant brand axis (orange → indigo) over warm neutral surfaces.
- **Learning feels like progress.** Every screen makes the user feel one step further along.
- **Friendly, not childish.** Encouraging and approachable while remaining credible and premium.
- **Consistency is polish.** Every screen reuses the same tokens, components, and motion rules.
- **No gradients.** The brand is flat: color comes from solid fills and subtle translucent shapes at 4–8% opacity. Never layer gradient, noise, or texture over a surface.

## C. Primary Color — Orange

The primary action color and the brand's visual anchor.

| Token | Light | Dark | Role |
|---|---|---|---|
| `primary` | `#F97316` | `#FF9A5F` | Primary actions, active highlights, progress, hero moments |
| `onPrimary` | `#FFFFFF` | `#3B1E00` | Content on primary |
| `primaryContainer` | `#FFF7ED` | `#5B2E08` | Soft orange surfaces, selected states |
| `onPrimaryContainer` | `#7A2E00` | `#FFDBC6` | Content on primary containers |
| `primaryHover` | `#EA580C` | — | Hover state |
| `primaryPressed` | `#C2410C` | — | Pressed state |
| `primarySubtle` | `#FFFBF7` | — | Pale brand tint for soft separation |

Orange dominates: primary CTAs, the active navigation item, key highlights. It is **never** a background wash across a full screen except the splash and onboarding end-state.

## D. Secondary Color — Indigo

The support color: secondary actions, discovery, and personalization accents.

| Token | Light | Dark | Role |
|---|---|---|---|
| `secondary` | `#514AF8` | `#9B9DFF` | Secondary actions, discovery, support |
| `onSecondary` | `#FFFFFF` | `#13166F` | Content on secondary |
| `secondaryContainer` | `#EEEDFF` | `#3B3F9E` | Soft indigo surfaces, selected secondary states |
| `onSecondaryContainer` | `#3730A3` | `#E1E2FF` | Content on secondary containers |
| `secondaryHover` | `#4338CA` | — | Hover state |
| `secondaryPressed` | `#3730A3` | — | Pressed state |
| `secondarySubtle` | `#F5F3FF` | — | Pale indigo tint for soft separation |

Indigo supports but never outshines orange. Use it for secondary buttons, "Untuk Kamu" discovery accents, active filter states, and the progress chart's informational series.

## E. Neutrals

Warm, slightly off-white surfaces that keep color vivid and long reading sessions comfortable.

| Token | Light | Dark | Role |
|---|---|---|---|
| `background` | `#FCFDFD` | `#101214` | App background (slightly off-white, glare-free) |
| `onBackground` | `#1D2939` | `#E7EAEE` | Content on background |
| `surface` | `#FFFFFF` | `#17191D` | Elevated surfaces such as cards and sheets |
| `onSurface` | `#1D2939` | `#E7EAEE` | Content on surface |
| `card` | `#FFFFFF` | `#1D2126` | Explicit "card" surface, distinct from page background |
| `onCard` | `#1D2939` | `#E7EAEE` | Content on cards |
| `surfaceVariant` | `#F2F4F7` | `#2E3238` | Muted grouped surfaces |
| `onSurfaceVariant` | `#667085` | `#B0B7C3` | Secondary text, captions |
| `surfaceContainerLowest` | `#FCFDFD` | `#0C0E10` | Material 3 containers (nav bars, fields) |
| `surfaceContainerLow` | `#F6F8F9` | `#17191D` |  |
| `surfaceContainer` | `#EFF2F4` | `#1B1E23` |  |
| `surfaceContainerHigh` | `#E9ECEF` | `#22262C` |  |
| `surfaceContainerHighest` | `#E4E7EB` | `#2A2F36` |  |

Neutrals carry text, structure, and restraint. Decorative color budgets stay in the brand axis; neutrals are the canvas.

## F. Semantic Colors

State colors, used sparingly and always paired with an icon or word label.

| Token | Light | Dark | Role |
|---|---|---|---|
| `success` | `#17B26A` | `#47D16C` | Completion, correct answers, positive progress |
| `successContainer` | `#D8F6E6` | `#0A5C36` | Soft success surfaces |
| `onSuccessContainer` | `#0A5C36` | `#B5F3CC` | Content on success containers |
| `warning` | `#F79009` | `#FFC24B` | Attention, near-goal states |
| `warningContainer` | `#FDEBD0` | `#7A4400` | Soft warning surfaces |
| `onWarningContainer` | `#7A4400` | `#FFE4B0` | Content on warning containers |
| `error` | `#F04438` | `#F97066` | Errors, destructive actions |
| `errorContainer` | `#FDE3E1` | `#7A1711` | Soft error surfaces |
| `onErrorContainer` | `#7A1711` | `#FFD9D6` | Content on error containers |
| `info` | `#2E90FA` | `#7CB8FF` | Informational messages |
| `infoContainer` | `#D6EAFF` | `#0B4C85` | Soft info surfaces |
| `onInfoContainer` | `#0B4C85` | `#D3E6FF` | Content on info containers |

Usage:

- **Never mix more than 2–3 accent hues on one screen.** If orange and indigo already appear, add at most one semantic accent.
- Semantic colors are **not** brand decoration. They say something: done, caution, failed, noticed.
- Each has an `on*` container tone for soft surfaces (badges, chips, banners).

## G. Technology Colors

Technology/accent colors are **explicitly not part of the brand palette.** They exist only to identify real technologies (Python, PHP, MySQL, Dart/Flutter, …) or course/learning categories.

- Defined as `TechBrandColors` (background / accent / onAccent) in `shared/data/tech_brand_colors.dart`, used by mock data only.
- Never introduce a technology hue into buttons, navigation, or brand moments.
- On Progress, technology colors are confined to small logo tiles; progress bars, charts, and CTAs stay in brand orange + indigo + success green.

## H. Color Hierarchy and Usage Rules

1. **Orange is the hero.** Primary CTAs, active states, key highlights.
2. **Indigo is the wingman.** Secondary actions, discovery accents, non-primary emphasis.
3. **White is the calm surface.** Cards, sheets, and page background.
4. **Semantic hues say something** — done, caution, failed, noticed — and never decorate.
5. **Technology hues identify technologies**, never the brand.
6. **Use tokens, never raw hex.** Components and screens reference `AppColors` (light/dark), the Material `ColorScheme`, or `AppThemeExtension` semantic tokens. Hardcoded `Color(0xFF…)` in screens is a defect.
7. **Never rely on color alone** to convey meaning — pair with icons, text, or shape.
8. **Dark mode preserves the same roles** with adjusted luminance (dark variants above).
9. **Two hue budget:** a screen shows ≤ 3 accent hues total (brand + at most one semantic).

## I. Typography

| Token | Family | Weights | Use |
|---|---|---|---|
| Display | Plus Jakarta Sans | 700, 800 | Page titles, large headings |
| Heading | Plus Jakarta Sans | 600, 700 | Section headings, card titles |
| Body | Inter | 400, 500, 600 | Paragraphs, labels, descriptions |
| Mono | JetBrains Mono | 400, 700 | Code, technical identifiers |

Rules:

- Default to the `AppTypeScale` token scale; do not hand-pick arbitrary sizes.
- Emphasize with weight and size before adding color.
- Numbers/statistics use a tabular-friendly treatment in headings.
- Keep line lengths readable (≈ 60–80 chars per line).
- All human-facing copy is Bahasa Indonesia; accents that read warmer on colored surfaces come from the `OnboardingColors`/`*Muted` pattern rather than raw alpha text everywhere.

## J. Surfaces

- **Prefer flat, bordered cards over heavy shadows.** Clean and modern.
- `background` is the page canvas; cards lift off it on `card`/`surface` with a hairline border (`#EAECF0` light / `#33383F` dark).
- Elevation is reserved for floating elements: the bottom nav, menus, overlays.
- Decorative color fills are restrained to 4–8% alpha shapes behind content (e.g. the Auth ambient circles).

## K. Radius and Borders

| Token | Value | Use |
|---|---|---|
| `AppRadius.small` | 8 | Chips, tags inside cards |
| `AppRadius.medium` | 12 | Inputs, chat bubbles, small surfaces |
| `AppRadius.large` | 16 | Standard cards, panels |
| `AppRadius.extraLarge` | 24 | Hero surfaces, sheets, dialogs |
| `AppRadius.pill` | 100 | Fully-rounded capsule (buttons) |

- Hairline borders (`border`/`divider`) separate structure; `outline` marks emphasized edges (input decorators).
- Use `AppSpacing`/`AppRadius` tokens, never raw numbers in screens.

## L. Decoration

- **No gradients.** Not for backgrounds, buttons, or imagery.
- **No textures or noise.** Color is flat.
- Decorative depth comes from **flat translucent shapes** (circles, soft waves) at low alpha, drawn from Flutter primitives — never from image assets for decoration.
- Motion is a load indicator (shimmer/skeleton rails), not decoration.

## M. Component Emphasis

| Element | Rule |
|---|---|
| Primary button | Orange `primary`, white text — one per screen |
| Secondary button | Indigo `secondary` or outlined indigo — support only |
| Text/ghost | Tertiary, low emphasis |
| Bottom nav | Floating bar; active item = orange icon + label |
| Section header | Title left, "Lihat Semua" right |
| Cards | Flat, bordered, whole-card tap target |
| Progress bar | Orange; success touches stay semantic green |
| Badges/chips | Brand containers (orange/indigo) or semantic containers |
| Empty states | Illustration + title + one sentence + one primary CTA |

## N. Accessibility

- Contrast ≥ 4.5:1 body text, ≥ 3:1 large text (WCAG AA).
- Touch targets ≥ 48×48 px with adequate spacing.
- Every interactive element has a semantic label.
- Color is never the only signal; pair with icons/text/labels.
- Support text scaling without overflow.
- Focus order matches visual order; visible focus rings in keyboard mode.

## O. Do and Don't

**Do**

- Use orange for the primary action; indigo for support.
- Keep surfaces white and calm; let color earn its place.
- Use semantic hues only for meaning.
- Use tokens (`AppColors`, theme extension) everywhere.
- Confirm each screen in light + dark at all breakpoints.

**Don't**

- Don't add a new accent hue; the budget is orange + indigo + white/neutral + one semantic.
- Don't use technology colors for brand moments.
- Don't paint gradients or textures.
- Don't hardcode hex in screens.
- Don't let indigo compete with orange for dominance.

## P. Screen-Level Strategy

Each surface has a defined personality along one spectrum — **same tokens, different emphasis:**

| Screen | Energy | Personality |
|---|---|---|
| **Onboarding** | High | Brand-connected flow: indigo → white → orange chapters; warm copy; orange final CTA |
| **Auth** | Calm | White form surface, orange primary, flat translucent orange ambient shapes, subtle indigo accents |
| **Splash** | Peak | Full-bleed solid orange, centered logomark, no CTA |
| **Home** | Highest | Orange/indigo/white hero carousel, colorful recommended rail, orange CTAs |
| **Explore** | Most colorful | Full-bleed technology-brand cards and category bands; orange stays on controls |
| **Progress** | Clean/structured | White cards, orange progress, indigo + green donut chart, green completion |
| **Profile** | Calmest | White/neutral rows, orange active nav, error for destructive actions |

## Q. Tone of Voice

MentinorinAja speaks like a **warm, knowledgeable friend** — encouraging, plain-spoken, never condescending.

| Principle | Say this | Avoid |
|---|---|---|
| Encouraging | "Kamu hampir sampai! Lanjutkan." | "Anda gagal." |
| Plain | "Coba lagi sebentar lagi." | "Terjadi kesalahan autentikasi (E-401)." |
| Concrete | "Lanjutkan Belajar · Matematika Diskrit" | "Lanjutkan modul." |
| Warm | "Teman Belajar yang Memahami Kamu" | Corporate boilerplate |

Copy rules:

- User-facing copy is **Bahasa Indonesia**; technical terms (course, lesson, quiz) may stay in English where natural.
- Imperatives are soft: "Mulai" / "Lanjutkan" / "Lihat Semua" over "Klaim sekarang!".
- Errors say what happened + what to do next, in plain words.
- Keep hero copy short; the interface does the rest.

---

## Logo and Iconography

### Mark

- The "MentinorinAja" logotype (Plus Jakarta Sans 800) is the primary lockup.
- A graduation-cap monogram mark is the app icon and favicon.
- Keep clear space ≈ icon height; use the light variant on dark surfaces, the dark variant on light surfaces; never recolor the logo with semantic colors.

### Icons

- Material Symbols (rounded family) is the icon language.
- Icons support action semantics with the semantic color roles.

### Illustration

- **Warm, rounded, friendly** characters and objects in the brand palette.
- Onboarding and empty states use illustration; interactive surfaces stay photo/typographic.

### Tech brand logos

- Courses use **real technology logos** (Python, PHP, Java, JavaScript, Dart/Flutter, MySQL, PostgreSQL, Laravel, …).
- These live in `shared/widgets/tech/` and render from bundled SVG assets (`assets/`).
- Never replace a real tech logo with a generic placeholder once the real asset exists.