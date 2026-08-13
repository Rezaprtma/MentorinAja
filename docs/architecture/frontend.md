# Frontend Architecture

This document describes the MentorinAja Flutter frontend as it is actually implemented today. It is the source of truth for structure, dependencies, and conventions.

- **Status:** Authoritative
- **Last updated:** 2026-08-12
- **Audience:** Flutter engineers, reviewers
- **Scope:** Frontend only. The backend is a bootstrap; this document does not describe server-side systems.

---

## 1. Overview

MentinorinAja is a course-based learning app. The Flutter frontend is the only implemented surface; it currently runs on mock data and drives the whole onboarding → authentication → learning shell journey.

### Current implementation facts

- **Framework:** Flutter, Material 3 (`useMaterial3: true`)
- **State management:** plain Flutter (`StatefulWidget`, `ChangeNotifier`, controllers). No third-party state library.
- **Routing:** custom Navigator 2.0 `AppRouter` plus `onGenerateRoute` in `App`; path constants in `route_names.dart`. No GoRouter.
- **Dependencies:** only `flutter_svg` (plus `flutter_test` / `flutter_lints`).
- **Data:** local mock repositories (`MockHomeData`, `MockExploreData`, `MockProgressData`, `MockAuthService`). No network layer.
- **UI copy:** Bahasa Indonesia.
- **Platforms:** Android, iOS, Windows targets configured.

---

## 2. Repository Layout

```
frontend/
├── lib/
│   ├── main.dart                 # entrypoint
│   ├── app/                      # App widget, MainShell, bootstrap
│   ├── routing/                  # route constants, guard, router
│   ├── core/                     # theme, assets, navigation service, responsive, lifecycle
│   ├── shared/                   # design system, widgets, models, data
│   └── features/                 # feature modules (splash, onboarding, auth, ...)
├── test/
│   ├── unit/                     # controller / logic tests
│   └── widget/                   # screen and navigation tests
└── assets/                       # brand icons, tech logos, onboarding art
```

### Directory responsibilities

| Path | Responsibility |
|---|---|
| `lib/app/` | Root widgets: `App` (MaterialApp), `MainShell` (4-tab shell), `bootstrap.dart`. |
| `lib/routing/` | `AppRoutes` constants, `RouteGuard`, Navigator 2.0 `AppRouter`. |
| `lib/core/` | Cross-cutting infrastructure: theme tokens, asset registry, navigation service, responsive helpers, lifecycle mixins. |
| `lib/shared/` | Reusable, feature-agnostic code: design system components, widgets, models, mock data. |
| `lib/features/` | One folder per product area; each feature exposes a public API (barrel) and owns its screens, widgets, logic. |
| `test/` | `unit/` for logic, `widget/` for screens and flows. |

### Dependency rules

- Features import `core/`, `shared/`, and other features through their public barrels only.
- `core/` and `shared/` never import features.
- No widget or screen hardcodes colors, spacing, or type styles — always use design tokens.

---

## 3. App Bootstrap and Navigation

### Startup flow

```
main.dart
  └─ App (MaterialApp)
       ├─ theme: AppTheme.light() / dark()
       ├─ initialRoute: AppRoutes.splash
       ├─ onGenerateRoute → resolves path to screen
       └─ AppShell wraps the navigator
```

### Route table

| Route | Screen |
|---|---|
| `/splash` | `SplashScreen` |
| `/onboarding` | `OnboardingScreen` |
| `/authentication` | `AuthenticationScreen` |
| `/create-account` | `CreateAccountScreen` |
| `/sign-in` | `SignInScreen` |
| `/verification` | `OtpVerificationScreen` |
| `/home` | `MainShell` (tab shell) |
| `/explore` | `ExplorePage` |
| `/courses`, `/course/{courseId}` | Placeholder scaffolds |

`AppRoutes` also declares reserved paths (`/progress`, `/profile`, `/settings`, `/tutor`, `/lesson`, `/quiz`, `/practice`, `/voice`, `/camera`, `/conversation`) for features that are not implemented yet.

### MainShell

`MainShell` is the post-authentication shell. It renders four tabs in an `IndexedStack` (preserves per-tab scroll state) and floats `AppFloatingBottomNav`:

1. **Home** — greeting, hero carousel, "Progres Saya" resume card, recommended course rail.
2. **Explore** — "Jelajahi" catalog: category cards, "Kursus Populer" rail, "Untuk Kamu" section.
3. **Progress** — "Progres Belajar": stats panel, active courses, completed courses.
4. **Profile** — placeholder surface.

---

## 4. Theme and Design Tokens

The visual system lives in `lib/core/theme/` and is consumed everywhere via design tokens.

| File | Role |
|---|---|
| `app_colors.dart` | Raw palette: `AppColors` (light), `AppDarkColors` (dark). **Single source of truth for hex values.** |
| `app_theme_extension.dart` | Semantic roles beyond Material `ColorScheme` (success, warning, info, card, text tones). |
| `app_theme.dart` | `AppTheme.light()` / `dark()` / `fromColorScheme()` factories. |
| `app_typography.dart` | Type scale (`AppTypeScale`) and text theme builder (`AppTypography`). |
| `app_spacing.dart`, `app_radius.dart`, `app_elevation.dart`, `app_icon_sizes.dart`, `app_durations.dart` | Spacing, radius, elevation, icon, duration tokens. |

### Brand colors (source: `docs/design/brandidentity.md`)

- Primary: orange `#F97316`
- Secondary: purple/indigo `#514AF8`
- Dark mode swaps to lighter tints (`#FF9A5F`, `#9B9DFF`).

### Rules

- Components and screens reference tokens (`context.appColors.*`, `AppSpacing.*`, `AppTypeScale.*`); raw hex values appear only in `app_colors.dart`.
- Both light and dark modes are derived from the same token system.

---

## 5. Design System

`lib/shared/design_system/` is the reusable, feature-agnostic component library, grouped by category:

| Category | Components |
|---|---|
| Buttons | `AppButton` (primary/secondary/outlined/text), `AppIconButton`, `AppLoadingButton`, FAB |
| Cards | `AppCard` variants (elevated/outlined/base), `AppCourseCard`, `AppStatCard`, `AppInfoCard` |
| Inputs | text field, search field, OTP field, checkbox, switch, radio, dropdown, multiline |
| Feedback | `AppSnackBar`, `AppToast`, `AppBanner`, `AppNotification` |
| Loaders | skeleton, shimmer, empty state, circular/linear loader |
| Navigation | `AppFloatingBottomNav`, `AppBottomNavigation`, `AppPageHeader`, `AppSectionHeader`, `AppAppBar` |
| Lists | `AppTile`, `AppSettingsTile`, `AppProfileTile`, `AppCourseTile` |
| Layout | `AppContainer`, `AppSection`, `AppDivider`, `AppGap`, `AppSafeArea`, `AppScrollablePage` |
| Dialogs | alert, confirmation, bottom sheet, loading |
| Avatars / badges / chips | `AppAvatar`, `AppBadge`, filter chips |

`lib/shared/widgets/` holds coarser composables: `AppShell`, `ResponsiveContainer`, `ResponsivePadding`, tech-brand logos, image asset helper.

### Usage rules

- Prefer existing design-system components over bespoke widgets.
- Add a new component only when a pattern repeats; place it in `shared/design_system/`.
- Keep components state-management-free and feature-agnostic.

---

## 6. Features

Each feature lives in `lib/features/<name>/` and follows a consistent shape:

```
features/<name>/
├── <name>.dart                  # public API barrel
├── logic/                       # controllers, services, validators, mock data
└── presentation/
    ├── pages/                   # screens
    └── widgets/                 # screen-scoped widgets
```

### Implemented features

| Feature | Status | Content |
|---|---|---|
| `splash` | ✅ | Logo splash, routes to onboarding/auth/home. |
| `onboarding` | ✅ | 3 illustrated pages, "Mulai Belajar" CTA → auth. |
| `auth` | ✅ | Sign in, create account, OTP verification, Google (mock), validators, Indonesian strings. |
| `home` | ✅ | Greeting, hero carousel, resume card, recommended rail, tech logos. |
| `explore` | ✅ | Category discovery, popular courses rail, "Untuk Kamu" section. |
| `progress` | ✅ | Stats panel, active/completed course cards, pull-to-refresh. |
| `profile` | ⚠️ | Placeholder empty state. |
| `course`, `lesson`, `quiz`, `practice`, `tutor`, `voice`, `camera`, `conversation`, `settings` | ⬜ | Folders/routes reserved; not implemented. |

### Data

- Features consume local mock data (e.g. `mock_home_data.dart`, `mock_progress_data.dart`) behind simple constants/collections.
- When a backend API exists, swap mocks for repositories without changing screen logic (the presentation layer never knows the data source).

---

## 7. Testing

Tests live in `frontend/test/`.

| Layer | Location | Examples |
|---|---|---|
| Unit | `test/unit/` | `auth_validators_test.dart`, `auth_flow_test.dart`, `mock_auth_service_test.dart`, `otp_verification_controller_test.dart`, `app_theme_test.dart` |
| Widget | `test/widget/` | `main_shell_navigation_test.dart`, `onboarding_flow_test.dart`, `auth_flow_navigation_test.dart`, `explore_page_test.dart`, `home_banners_smoke_test.dart`, `progress_page_test.dart`, `pull_to_refresh_test.dart`, `app_notification_card_test.dart` |

Run from `frontend/`:

```bash
flutter test
```

### Conventions

- Widget tests build the real widgets against mock data; navigation tests assert route transitions.
- Keep the analyzer clean: `flutter analyze` must report zero issues.

---

## 8. Engineering Standards

- **Formatting:** `dart format .`
- **Analysis:** `flutter analyze`
- **Comments:** file-level doc header (line 1) and public API docs only; no inline narration.
- **Naming:** expressive names over comments; keep files cohesive.
- **State management:** start with plain Flutter primitives. Do not add a state-management or routing package without justification.
- **Dependencies:** verify a package exists before importing; keep `pubspec.yaml` minimal.
- **Responsive:** use `ResponsiveContainer` / `ResponsivePadding` and the breakpoint helpers so screens work from phone to tablet/desktop.

---

## 9. Future Direction (Planned, Not Implemented)

- Backend API integration behind repositories (auth, courses, progress).
- Course detail, lesson viewer, quiz, and practice surfaces (routes already reserved).
- AI tutor, conversation, voice, and camera features (routes reserved; no implementation).
- Profile and settings completion.
- Persistent data/offline support.

Any new screen must follow `docs/design/ui-patterns.md` and reuse the design system before adding bespoke UI.
