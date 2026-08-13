# Design System — Rules

This document defines the **design rules** for building MentorinAja interfaces: layout, spacing, elevation, components, motion, and responsiveness. It is the rulebook for how components and screens are put together.

- **Status:** Authoritative
- **Last updated:** 2026-08-12
- **Companion docs:** brand identity (`brandidentity.md`), screen patterns (`ui-patterns.md`)

---

## 1. Purpose and Scope

The design system guarantees that any screen — from a fresh learner's first run to a returning user's progress review — feels like the same product.

- This document states **what** the rules are.
- `ui-patterns.md` describes **how screens** compose them.
- `brandidentity.md` owns colors, type, and tone.
- Implementation lives in `frontend/lib/shared/design_system/` (see `docs/architecture/frontend.md`).

---

## 2. Layout Grid and Breakpoints

### Breakpoints

| Breakpoint | Width | Layout |
|---|---|---|
| Compact | `< 600` | 1 column, edge-to-edge content with `AppSpacing.lg` padding |
| Medium | `600 – 904` | 2 columns, content rails can wrap |
| Expanded | `> 904` | Multi-column grids, centered content max-width 1200 px |

- Use `ResponsiveContainer` for page-level adaptation.
- Vertical rhythm: space content blocks with `AppSpacing.xl` (32 px) on a screen.

### Horizontal spacing scale

| Token | Value | Use |
|---|---|---|
| `xxs` | 4 | Smallest inset; tight alignment details |
| `xs` | 8 | Default inner padding for compact controls |
| `sm` | 12 | Small gaps between related elements |
| `md` | 16 | Standard screen padding, default component padding |
| `lg` | 24 | Section inner padding, card padding |
| `xl` | 32 | Section spacing on wider layouts |
| `xxl` | 40 | Generous screen-level spacing |
| `xxxl` | 48 | Large hero/empty-state spacing |

---

## 3. Elevation and Surface Rules

| Level | Use | Style |
|---|---|---|
| Base | Page background | `surface` |
| Raised | Cards, panels | `surfaceContainer`, subtle border |
| Floating | Bottom nav, FAB | Elevated shadow, rounded `full` ends |

- **Prefer flat, bordered cards over heavy shadows.** The brand reads clean and modern.
- Use elevation only where it earns its place (floating navigation, active overlays).
- Cards use radius `AppRadius.large` (16 px) by default; small chips use `AppRadius.small`/`medium`; hero surfaces and sheets use `AppRadius.extraLarge` (24 px).

---

## 4. Component Rules

### Buttons

| Variant | Use | Rule |
|---|---|---|
| Primary | The one main action on a screen | Orange `primary`, white text, filled |
| Secondary | Support action next to primary | Purple `secondary` or outlined |
| Text/ghost | Tertiary, low-emphasis | Inline, clear affordance |

- One primary action per view, visually dominant.
- Minimum touch target 48×48 px; loading states keep the button width stable.

### Cards

- **Course card:** cover/brand, title, meta (level, lessons), footer action. Tap target = whole card.
- **Stat card:** number-driven, icon + label + value, used in progress summary.
- **Resume/continue card:** dominant on Home; progress bar + CTA.

### Navigation

- Floating bottom bar, 4 destinations max, active state = orange icon + label.
- Page headers: large title + optional subtitle; back affordance where pushed.
- Section headers: short title + optional "Lihat Semua" action aligned right.

### Lists and rows

- Rows are ≥ 56 px tall, separated by hairline dividers or 8 px gaps.
- Settings/profile rows: icon + label + trailing chevron/action.

### Feedback

- **Toast:** transient confirmations, auto-dismiss, top/snackbar position.
- **Banner/notification:** persistent messages with action.
- **Empty states:** illustration + title + description + one primary CTA.
- **Loading:** skeletons match the layout they replace (card-shaped, shimmer).

### Inputs

- Fields carry a clear label, `OutlineInputBorder`, and 16 px radius.
- Validation: inline error text under the field + red border; success state optional green check.
- OTP field: single-character boxes with focus chaining.

### Chips and filters

- `AppFilterChip` / `AppChoiceChip` are available for compact filtering; selected state = orange container + dark text.
- Learn areas in Explore are currently presented as full-bleed category discovery cards (see `ui-patterns.md`).

---

## 5. Motion Rules

### Durations and easing

| Intent | Duration | Curve |
|---|---|---|
| Micro (hover/pressed) | 100 ms | easeOut |
| Standard (transitions, fades) | 200–250 ms | easeInOut |
| Page/horizontal transitions | 300 ms | easeInOutCubic |

### Rules

- Motion is **functional**: it explains relationships, state changes, and hierarchy.
- Fade + subtle slide is the default transition; avoid bouncy or exaggerated effects.
- Respect **reduced-motion** preferences: replace animations with instant state changes.
- Pull-to-refresh uses a branded loading indicator, not a generic spinner.

---

## 6. Accessibility Rules

- Contrast ≥ 4.5:1 for body text, ≥ 3:1 for large text (WCAG AA).
- Touch targets ≥ 48×48 px with adequate spacing between targets.
- Every interactive element has a semantic label (icons, buttons, chips).
- Color is never the only signal; pair with icons/text/labels.
- Support text scaling without overflow (responsive layouts, flexible text).
- Focus order matches visual order; visible focus rings in keyboard mode.
- Do not auto-play or flash content; avoid high-frequency blinking.

---

## 7. Cross-Cutting Rules

- **Consistency beats cleverness:** reuse existing components; add new ones only for a repeated pattern.
- **Do not hardcode** colors, spacing, radii, or type sizes in screens — use the token layer.
- **Naming:** components are prefixed `App*` (e.g. `AppButton`, `AppCard`) and live in `shared/design_system/`.
- **Dark mode:** every screen must render correctly in both themes; verify token usage, not hex values.
- **Responsive check:** every screen must be reviewed at compact, medium, and expanded widths.

---

## 8. Design Rules Summary (checklist)

- [ ] Uses tokens, not hardcoded values.
- [ ] One primary action per screen (orange).
- [ ] Purple used for support/discovery, never as the dominant CTA.
- [ ] Cards flat with subtle borders; elevation reserved for floating elements.
- [ ] Empty/loading/error states present for every data surface.
- [ ] 48 px touch targets; labels on interactive elements.
- [ ] Copy in Bahasa Indonesia, warm and concrete.
- [ ] Verified in light + dark and all three breakpoints.
