# MentorinAja Frontend Documentation

> Last updated: 2026-08-18  
> Version: 0.1.0  
> Status: Pre-release / Development

---

## 1. Project Overview

MentorinAja adalah platform edukasi untuk pelajar Indonesia. Frontend adalah aplikasi Flutter yang menyediakan pengalaman belajar interaktif dengan course player, AI tutor, dan sistem progres.

**Target Pengguna:**
- Pelajar Indonesia (siswa/mahasiswa)
- Mentor/pengajar course
- Konten kreator course

**Arsitektur:**
- Mock-only data layer (belum ada integrasi API nyata)
- ChangeNotifier + ListenableBuilder untuk state management
- 4-tab navigation (Home, Explore, Progress, Profile)
- 3-stage course learning flow (Materi, Game, Latihan)

---

## 2. Production Platform

| Platform | Status |
|----------|--------|
| Android | Production target |
| iOS | Production target |
| Windows | Removed |
| Web | Removed |

**Development Tooling:**
14 preview entrypoint (`main_*_preview.dart`) dipertahankan sebagai development tooling, BUKAN production entrypoint.

---

## 3. Technology Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (SDK >=3.10.0) |
| Language | Dart |
| State Management | ChangeNotifier + ListenableBuilder |
| Theme | ThemeData + ColorScheme.fromSeed() |
| Fonts | Plus Jakarta Sans (heading), Inter (body), JetBrains Mono (code) |
| SVG Rendering | flutter_svg ^2.0.10+1 |
| Icons | Custom SVG assets + Material Icons |
| Routing | onGenerateRoute + Navigator 1.0 |

**Dependencies:**
- Production: flutter SDK, flutter_svg
- Dev: flutter_test, flutter_lints

**Key Principle:** Zero runtime dependencies beyond Flutter SDK dan flutter_svg.

---

## 4. Project Structure

```
frontend/
├── android/                    # Android platform configuration
├── ios/                        # iOS platform configuration
├── assets/
│   ├── icons/                  # 30+ SVG icon files
│   ├── images/                 # Image assets (placeholder)
│   ├── audio/                  # Audio assets (placeholder)
│   ├── fonts/                  # Font files (placeholder)
│   └── translations/           # Localization files (placeholder)
├── lib/
│   ├── app/                    # Application shell (3 files)
│   ├── config/                 # Configuration (3 files)
│   ├── core/                   # Core utilities (27 files)
│   ├── features/               # Feature modules (155+ files)
│   │   ├── auth/               # Authentication (14 files)
│   │   ├── course/             # Course detail & player (14 files)
│   │   ├── course_authoring/   # Course creation (15 files)
│   │   ├── explore/            # Course discovery (5 files)
│   │   ├── home/               # Home screen (11 files)
│   │   ├── lesson/             # Lesson player (30 files)
│   │   ├── notifications/      # Notifications (7 files)
│   │   ├── onboarding/         # Onboarding flow (10 files)
│   │   ├── profile/            # User profile (18 files)
│   │   ├── progress/           # Learning progress (12 files)
│   │   ├── splash/             # Splash screen (5 files)
│   │   └── tutor/              # AI Tutor (7 files)
│   ├── routing/                # Navigation (3 files)
│   ├── shared/                 # Shared code (68 files)
│   │   ├── design_system/      # Design system widgets (56+ files)
│   │   ├── widgets/            # Shared widgets (11 files)
│   │   ├── data/               # Shared mock data (2 files)
│   │   ├── enums/              # Shared enumerations (1 file)
│   │   ├── models/             # Shared models (1 file)
│   │   └── transitions/        # Page transitions (2 files)
│   └── main*.dart              # 15 entrypoints (1 production + 14 preview)
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

**Total Dart files:** 279

---

## 5. Architecture

### Layered Architecture

```
┌─────────────────────────────────────────┐
│              Presentation               │
│  screens/ │ widgets/ │ controllers/     │
├─────────────────────────────────────────┤
│              Application                │
│  services/ │ repositories (abstract)    │
├─────────────────────────────────────────┤
│              Domain                     │
│  entities/ │ models/ │ enums            │
├─────────────────────────────────────────┤
│              Infrastructure             │
│  repositories (mock) │ data/            │
└─────────────────────────────────────────┘
```

### Entry Points

**Production:**
- `lib/main.dart` → `AppBootstrap` → `App` (MaterialApp)

**Development Tooling (14 preview entrypoints):**
- `lib/main_profile_preview.dart`
- `lib/main_tutor_chat_preview.dart` (ai_tutor)
- `lib/main_course_card_preview.dart`
- `lib/main_onboarding_preview.dart`
- `lib/main_login_preview.dart` (authentication)
- `lib/main_otp_preview.dart`
- `lib/main_verification_preview.dart`
- `lib/main_course_card_vertical_preview.dart`
- `lib/main_home_preview.dart`
- `lib/main_course_list_preview.dart`
- `lib/main_progress_preview.dart`
- `lib/main_notifications_preview.dart`
- `lib/main_lesson_flow_preview.dart`
- `lib/main_course_player_preview.dart`

### Application Shell

```
AppBootstrap → App (MaterialApp) → MainShell (IndexedStack)
```

- **AppBootstrap:** Pre-flight initialization (stubs: `isFirstLaunch=true`, `isAuthenticated=false`)
- **App:** Root `MaterialApp` dengan theme configuration, error handling, dan routing
- **MainShell:** Bottom navigation dengan 4 tab menggunakan `IndexedStack` untuk state preservation

### Tab Structure

| Index | Tab | Icon | Description |
|-------|-----|------|-------------|
| 0 | Home | `home_outlined/home_rounded` | Main hub dengan course listings |
| 1 | Explore | `search` | Browse available courses |
| 2 | Progress | `bar_chart_outlined/bar_chart_rounded` | Learning progress tracker |
| 3 | Profile | `person_outline/person_rounded` | User profile dan settings |

---

## 6. Dependency Direction

```
UI Widgets
    ↓
Controllers (ChangeNotifier)
    ↓
Abstract Repositories
    ↓
Mock Implementations
    ↓
Static Mock Data
```

**Current State:**
- Semua data berasal dari mock repositories
- Mock repositories mengimplementasikan abstract interfaces
- Controllers mengorkestrasi data dari repositories
- Widgets menampilkan data dari controllers via ListenableBuilder
 
**Future State:**
- Mock implementations akan diganti dengan real API services
- Abstract interfaces tetap (kontrak frontend)
- Controllers tidak berubah
- Widgets tidak berubah

---

## 7. Data Flow

### Course Learning Flow

```
MockCourseCatalog (static 15 courses)
    ↓
MockCourseRepository (findByTitle, all, coursesInCategory)
    ↓
MockProgressRepository (tracks completed/current lessons)
    ↓
LearningProgressController (orchestrates progress + course data)
    ↓
UI Widgets (course detail, lesson list, progress)
```

### Notification Flow

```
MockNotificationRepository (8 hardcoded notifications)
    ↓
NotificationController (refresh, markRead, markAllRead)
    ↓
UI Widgets (notification list, unread badge)
```

### AI Tutor Flow

```
User input (text)
    ↓
TutorController.send(text)
    ↓
MockTutorRepository.reply(context, message) [keyword-based]
    ↓
TutorMessage added to _messages list
    ↓
UI Widgets (chat messages)
```

### Profile Flow

```
MockProfileData (displayName, email)
    ↓
ProfileController (updateProfile, reset)
    ↓
UI Widgets (profile page, edit profile)
```

### Lesson Content Flow

```
MockLessonContent (generates LessonContentBlocks)
    ↓
MockLessonExercises (generates LessonExercises)
MockModuleContentGenerator (generates games + exercises)
    ↓
CoursePlayerPreview (aggregates content per lesson)
    ↓
UI Widgets (lesson player, exercise screens)
```

---

## 8. Feature Map

### Splash

| Aspect | Detail |
|--------|--------|
| Purpose | App initialization dan routing decision |
| Entry Point | `lib/features/splash/presentation/screens/splash_screen.dart` |
| Pages | SplashScreen |
| Main Widgets | MentorinAja SVG icon |
| Controller | SplashController |
| Repository | None (stubs only) |
| Models | SplashState (enum) |
| Data Source | Hardcoded stubs |
| State | idle → initializing → routing/error |
| Navigation | /onboarding (first launch), /home (authenticated), /authentication |
| Persistence | None (stubs) |
| Backend Dependency | None (stubs) |
| API Seam | None |
| QA Requirements | Minimum 2-second display, correct routing based on auth state |
| Known Limitations | All initialization is stubbed |

### Onboarding

| Aspect | Detail |
|--------|--------|
| Purpose | Introduce app features to new users |
| Entry Point | `lib/features/onboarding/presentation/screens/onboarding_screen.dart` |
| Pages | OnboardingScreen |
| Main Widgets | OnboardingPage, OnboardingIndicator, OnboardingIllustration |
| Controller | OnboardingController |
| Repository | None |
| Models | None |
| Data Source | 3 hardcoded pages |
| State | currentPage (0-2) |
| Navigation | /authentication (on complete) |
| Persistence | None |
| Backend Dependency | None |
| API Seam | None |
| QA Requirements | Page navigation, skip button, "Mulai Belajar" CTA |
| Known Limitations | Static content |

### Auth

| Aspect | Detail |
|--------|--------|
| Purpose | User authentication (email, OTP, Google) |
| Entry Point | `lib/features/auth/presentation/screens/authentication_screen.dart` |
| Pages | AuthenticationScreen, SignInScreen, CreateAccountScreen, OtpVerificationScreen |
| Main Widgets | AuthAmbientBackground, AuthScaffold, GoogleAuthButton |
| Controller | OtpVerificationController, VerificationRequestController, GoogleAuthController |
| Repository | None (MockAuthService) |
| Models | AuthActionResult, AuthFlow, AuthValidators |
| Data Source | Mock auth simulation |
| State | isProcessing, isVerifying, isVerified, countdown |
| Navigation | /verification → /home |
| Persistence | None |
| Backend Dependency | Auth backend (TBD) |
| API Seam | AuthGoogleService interface |
| QA Requirements | Form validation, OTP flow, Google sign-in |
| Known Limitations | All auth is mocked |

### Home

| Aspect | Detail |
|--------|--------|
| Purpose | Main hub dengan course listings dan progress |
| Entry Point | `lib/features/home/presentation/pages/home_page.dart` |
| Pages | HomePage |
| Main Widgets | HomeHeader, HeroBannerCarousel, ContinueLearningCard, RecommendedSection |
| Controller | None (uses LearningProgressController.instance) |
| Repository | None |
| Models | MockBanner, MockCourse |
| Data Source | MockHomeData (static) |
| State | None (stateless) |
| Navigation | /notifications, /course/{slug} |
| Persistence | None |
| Backend Dependency | Home data API (TBD) |
| API Seam | None (direct mock consumption) |
| QA Requirements | Banner carousel, course cards, pull-to-refresh |
| Known Limitations | Static data |

### Explore

| Aspect | Detail |
|--------|--------|
| Purpose | Course discovery dan search |
| Entry Point | `lib/features/explore/presentation/pages/explore_page.dart` |
| Pages | ExplorePage, CategoryDetailPage |
| Main Widgets | CategoryDiscoveryCard |
| Controller | None |
| Repository | None |
| Models | ExploreCategory, ExploreCourse |
| Data Source | MockExploreData (static) |
| State | Search query, selected category |
| Navigation | /course/{courseId}, /category/{name} |
| Persistence | None |
| Backend Dependency | Course catalog API (TBD) |
| API Seam | None (direct mock consumption) |
| QA Requirements | Search, category filter, course cards |
| Known Limitations | Static data |

### Course Detail

| Aspect | Detail |
|--------|--------|
| Purpose | Display course information dan enrollment |
| Entry Point | `lib/features/course/presentation/pages/course_detail_page.dart` |
| Pages | CourseDetailPage |
| Main Widgets | CourseIdentityHeader, CourseOutlineTile, CourseSummaryCard |
| Controller | LearningProgressController |
| Repository | CourseRepository, ProgressRepository |
| Models | CourseDetail, CourseLesson, CourseProgress |
| Data Source | MockCourseCatalog |
| State | bookmark toggle, progress state |
| Navigation | /course/{courseId}/lesson/{lessonId}, /course/{courseId}/completed |
| Persistence | None (mock) |
| Backend Dependency | Course detail API (TBD) |
| API Seam | CourseRepository interface |
| QA Requirements | Course info display, lesson outline, start/continue button |
| Known Limitations | Mock progress data |

### Course Player (Lesson)

| Aspect | Detail |
|--------|--------|
| Purpose | Interactive lesson learning dengan 3 stages |
| Entry Point | `lib/features/lesson/presentation/pages/course_player_page.dart` |
| Pages | CoursePlayerPage, CourseCompletedPage |
| Main Widgets | MateriStage, GameStage, LatihanStage, LearningNavigationBar |
| Controller | TutorController (for AI tutor) |
| Repository | CourseRepository, ProgressRepository, TutorRepository |
| Models | CoursePlayerPreview, LessonContentBlock, LessonExercise |
| Data Source | MockLessonContent, MockLessonExercises, MockModuleContentGenerator |
| State | stageIndex, gameIndex |
| Navigation | /course/{courseId}/completed, AI tutor panel |
| Persistence | None (mock) |
| Backend Dependency | Lesson content API (TBD), Tutor API (TBD) |
| API Seam | CourseRepository, ProgressRepository, TutorRepository |
| QA Requirements | 3-stage flow, game interactions, exercise completion |
| Known Limitations | Mock content, keyword-based tutor replies |

### Materi

| Aspect | Detail |
|--------|--------|
| Purpose | Material/reading content display |
| Entry Point | MateriStage (within CoursePlayerPage) |
| Pages | None (stage within CoursePlayerPage) |
| Main Widgets | LessonContentBlockView, StageIntroCard |
| Controller | None |
| Repository | None |
| Models | LessonContentBlock |
| Data Source | MockLessonContent |
| State | Content scroll position |
| Navigation | Next stage (game) |
| Persistence | None |
| Backend Dependency | Content delivery API (TBD) |
| API Seam | None (direct mock consumption) |
| QA Requirements | Content rendering, code blocks, lists |
| Known Limitations | Static content |

### Game

| Aspect | Detail |
|--------|--------|
| Purpose | Interactive learning challenges |
| Entry Point | GameStage (within CoursePlayerPage) |
| Pages | None (stage within CoursePlayerPage) |
| Main Widgets | GameView, MultipleChoiceGame, CodeOrderingGame, IdentifyErrorGame, OutputPredictionGame, TokenCompletionGame |
| Controller | None |
| Repository | None |
| Models | LessonExercise, GameType |
| Data Source | MockLessonExercises, MockModuleContentGenerator |
| State | Game completion status |
| Navigation | Next stage (latihan) |
| Persistence | None |
| Backend Dependency | Game content API (TBD) |
| API Seam | None (direct mock consumption) |
| QA Requirements | Game type selection, answer validation, feedback |
| Known Limitations | Mock exercises |

### Latihan

| Aspect | Detail |
|--------|--------|
| Purpose | Practice exercises |
| Entry Point | LatihanStage (within CoursePlayerPage) |
| Pages | None (stage within CoursePlayerPage) |
| Main Widgets | LessonExerciseView, ExerciseCard, ExerciseFeedback |
| Controller | None |
| Repository | None |
| Models | LessonExercise, LessonExerciseType |
| Data Source | MockLessonExercises |
| State | Exercise completion status |
| Navigation | Next lesson or completion |
| Persistence | None |
| Backend Dependency | Exercise API (TBD) |
| API Seam | None (direct mock consumption) |
| QA Requirements | Exercise types, answer validation, feedback |
| Known Limitations | Mock exercises |

### Exercise Architecture

| Aspect | Detail |
|--------|--------|
| Purpose | Different exercise types for learning |
| Types | codeCompletion, codeCorrection, codeExplanation, codeWriting |
| Game Types | codeOrdering, tokenCompletion, multipleChoice, identifyError, outputPrediction |
| Widgets | CodeCompletionExercise, CodeCorrectionExercise, CodeExplanationExercise, CodeWritingExercise |
| Data Source | MockLessonExercises, MockModuleContentGenerator |

### AI Tutor

| Aspect | Detail |
|--------|--------|
| Purpose | AI-powered learning assistance |
| Entry Point | showAiTutorPanel() (modal bottom sheet or dialog) |
| Pages | None (panel, not standalone route) |
| Main Widgets | AiTutorPanel |
| Controller | TutorController |
| Repository | TutorRepository |
| Models | TutorMessage, TutorLessonContext |
| Data Source | MockTutorRepository |
| State | messages, isThinking |
| Navigation | None (modal) |
| Persistence | None |
| Backend Dependency | AI/Tutor API (TBD) |
| API Seam | TutorRepository interface |
| QA Requirements | Chat interaction, suggested prompts, context display |
| Known Limitations | Keyword-based mock replies |

### Notifications

| Aspect | Detail |
|--------|--------|
| Purpose | In-app notification center |
| Entry Point | `lib/features/notifications/presentation/pages/notification_page.dart` |
| Pages | NotificationPage |
| Main Widgets | NotificationListItem |
| Controller | NotificationController |
| Repository | NotificationRepository |
| Models | AppNotification, AppNotificationKind |
| Data Source | MockNotificationRepository (8 items) |
| State | Filter, onlyUnread |
| Navigation | /course/{courseId} (on tap) |
| Persistence | None |
| Backend Dependency | Notification API (TBD) |
| API Seam | NotificationRepository interface |
| QA Requirements | Grouping, filtering, mark read, unread badge |
| Known Limitations | Mock data |

### Profile

| Aspect | Detail |
|--------|--------|
| Purpose | User profile display dan management |
| Entry Point | `lib/features/profile/presentation/pages/profile_page.dart` |
| Pages | ProfilePage, EditProfilePage, PrivacyPolicyPage, UserPolicyPage, AboutPage, FeedbackPage, HelpCenterPage |
| Main Widgets | ProfileHeader, ProfileIdentity, ProfilePhotoAvatar, ProfileSettingsSection |
| Controller | ProfileController |
| Repository | None (MockProfileData) |
| Models | ProfilePhoto |
| Data Source | MockProfileData, MockProfilePhotos |
| State | username, photoUrl |
| Navigation | /profile/edit, /support/*, /legal/* |
| Persistence | None |
| Backend Dependency | Profile API (TBD) |
| API Seam | None (direct mock consumption) |
| QA Requirements | Profile display, edit flow, theme toggle, sign out |
| Known Limitations | Mock data |

### Edit Profile

| Aspect | Detail |
|--------|--------|
| Purpose | User profile editing |
| Entry Point | `lib/features/profile/presentation/pages/edit_profile_page.dart` |
| Pages | EditProfilePage |
| Main Widgets | ProfilePhotoAvatar, AppTextField |
| Controller | ProfileController |
| Repository | None |
| Models | None |
| Data Source | MockProfileData |
| State | username, photoUrl, hasChanges |
| Navigation | pop (on save) |
| Persistence | None |
| Backend Dependency | Profile update API (TBD) |
| API Seam | None (direct mock consumption) |
| QA Requirements | Form validation, save, discard confirmation |
| Known Limitations | Mock photo picker |

### Theme

| Aspect | Detail |
|--------|--------|
| Purpose | Light/dark theme management |
| Entry Point | ProfilePage (theme toggle) |
| Pages | None (bottom sheet) |
| Main Widgets | None (bottom sheet) |
| Controller | ThemeModeController |
| Repository | None |
| Models | None |
| Data Source | None |
| State | ThemeMode (system/light/dark) |
| Navigation | None |
| Persistence | None (in-memory only) |
| Backend Dependency | None |
| API Seam | None |
| QA Requirements | Theme switching, system theme support |
| Known Limitations | No persistence |

### Language

| Aspect | Detail |
|--------|--------|
| Purpose | Language selection (placeholder) |
| Entry Point | ProfilePage (language sheet) |
| Pages | None (bottom sheet) |
| Main Widgets | None |
| Controller | None |
| Repository | None |
| Models | None |
| Data Source | None |
| State | None |
| Navigation | None |
| Persistence | None |
| Backend Dependency | i18n API (TBD) |
| API Seam | None |
| QA Requirements | Language sheet display |
| Known Limitations | Not implemented |

### Feedback

| Aspect | Detail |
|--------|--------|
| Purpose | User feedback submission |
| Entry Point | `lib/features/profile/presentation/pages/support/feedback_page.dart` |
| Pages | FeedbackPage |
| Main Widgets | AppChips, AppMultilineField |
| Controller | None |
| Repository | None |
| Models | None |
| Data Source | None (local state) |
| State | category, message |
| Navigation | None |
| Persistence | None |
| Backend Dependency | Feedback API (TBD) |
| API Seam | None |
| QA Requirements | Form validation, submit, success state |
| Known Limitations | Local state only |

### Help Center

| Aspect | Detail |
|--------|--------|
| Purpose | FAQ and support |
| Entry Point | `lib/features/profile/presentation/pages/support/help_center_page.dart` |
| Pages | HelpCenterPage |
| Main Widgets | ExpansionTile FAQ list |
| Controller | None |
| Repository | None |
| Models | None |
| Data Source | 7 hardcoded FAQ entries |
| State | Search query |
| Navigation | None |
| Persistence | None |
| Backend Dependency | FAQ API (TBD) |
| API Seam | None |
| QA Requirements | Search, expand/collapse |
| Known Limitations | Static data |

### About

| Aspect | Detail |
|--------|--------|
| Purpose | App information |
| Entry Point | `lib/features/profile/presentation/pages/support/about_page.dart` |
| Pages | AboutPage |
| Main Widgets | App icon, feature rows |
| Controller | None |
| Repository | None |
| Models | None |
| Data Source | Hardcoded (version 1.0.0) |
| State | None |
| Navigation | None |
| Persistence | None |
| Backend Dependency | None |
| API Seam | None |
| QA Requirements | App info display |
| Known Limitations | Static content |

### Privacy Policy

| Aspect | Detail |
|--------|--------|
| Purpose | Privacy policy document |
| Entry Point | `lib/features/profile/presentation/pages/legal/privacy_policy_page.dart` |
| Pages | PrivacyPolicyPage |
| Main Widgets | Document sections |
| Controller | None |
| Repository | None |
| Models | None |
| Data Source | Hardcoded (4 sections) |
| State | None |
| Navigation | None |
| Persistence | None |
| Backend Dependency | None |
| API Seam | None |
| QA Requirements | Content display |
| Known Limitations | Static content |

### User Policy

| Aspect | Detail |
|--------|--------|
| Purpose | Terms of service document |
| Entry Point | `lib/features/profile/presentation/pages/legal/user_policy_page.dart` |
| Pages | UserPolicyPage |
| Main Widgets | Document sections |
| Controller | None |
| Repository | None |
| Models | None |
| Data Source | Hardcoded (4 sections) |
| State | None |
| Navigation | None |
| Persistence | None |
| Backend Dependency | None |
| API Seam | None |
| QA Requirements | Content display |
| Known Limitations | Static content |

### Course Authoring (Mentor)

| Aspect | Detail |
|--------|--------|
| Purpose | Course creation and management for mentors |
| Entry Point | `lib/features/course_authoring/presentation/pages/course_list_page.dart` |
| Pages | CourseListPage, CourseCreatePage, CourseEditorPage, LessonEditorPage |
| Main Widgets | CourseDraftCard, CourseLessonTile, PublishValidationPanel |
| Controller | None (uses repository directly) |
| Repository | CourseAuthoringRepository |
| Models | CourseAuthoringDraft, LessonDraft, DraftStatus, PublishValidation |
| Data Source | MockCourseAuthoringRepository |
| State | Draft list, current draft |
| Navigation | /mentor/courses/* |
| Persistence | None (mock) |
| Backend Dependency | Course authoring API (TBD) |
| API Seam | CourseAuthoringRepository interface |
| QA Requirements | CRUD operations, publish/unpublish, validation |
| Known Limitations | Mock data |

---

## 9. Routing

### Route Structure

| Route | Destination | Parameters |
|-------|-------------|------------|
| `/splash` | SplashScreen | — |
| `/onboarding` | OnboardingScreen | — |
| `/authentication` | AuthenticationScreen | — |
| `/create-account` | CreateAccountScreen | — |
| `/sign-in` | SignInScreen | — |
| `/verification` | OtpVerificationScreen | email (arguments) |
| `/home` | MainShell | — |
| `/explore` | ExplorePage | — |
| `/courses` | Placeholder | — |
| `/progress` | ProgressPage | — |
| `/profile` | ProfilePage | — |
| `/course/{courseId}` | CourseDetailPage | courseId |
| `/course/{courseId}/lesson/{lessonId}` | CoursePlayerPage | courseId, lessonId |
| `/course/{courseId}/completed` | CourseCompletedPage | courseId |
| `/notifications` | NotificationPage | — |
| `/category/{category}` | CategoryDetailPage | category |
| `/support/feedback` | FeedbackPage | — |
| `/support/help` | HelpCenterPage | — |
| `/support/about` | AboutPage | — |
| `/legal/privacy` | PrivacyPolicyPage | — |
| `/legal/terms` | UserPolicyPage | — |
| `/profile/edit` | EditProfilePage | — |
| `/mentor/courses` | CourseListPage | — |
| `/mentor/courses/create` | CourseCreatePage | — |
| `/mentor/courses/{courseId}` | CourseEditorPage | courseId |
| `/mentor/courses/{courseId}/lessons/{lessonId}` | LessonEditorPage | courseId, lessonId |
| `/mentor/courses/{courseId}/preview` | CoursePlayerPage (preview) | courseId |
| `/mentor/courses/{courseId}/preview/{lessonId}` | CoursePlayerPage (preview) | courseId, lessonId |

### Unwired Routes (defined but not implemented)

| Route | Status |
|-------|--------|
| `/courses` | Placeholder only |
| `/quiz` | Not wired |
| `/settings` | Not wired |
| `/practice` | Not wired |
| `/tutor` | Not wired (standalone) |
| `/conversation` | Not wired |
| `/camera` | Not wired |
| `/voice` | Not wired |

---

## 10. State Management

### Pattern: ChangeNotifier + ListenableBuilder

**NO external state management packages.** Entire app uses raw ChangeNotifier.

### Singletons

| Controller | Access | Scope |
|------------|--------|-------|
| ThemeModeController | `.instance` | Global |
| LearningProgressController | `.instance` | Global |
| NotificationController | `.instance` | Global |
| ProfileController | `.instance` | Global |

### Per-Screen Controllers

| Controller | Created In | Scope |
|------------|------------|-------|
| OnboardingController | OnboardingScreen.initState() | Screen lifetime |
| VerificationRequestController | SignInScreen/CreateAccountScreen | Screen lifetime |
| OtpVerificationController | OtpVerificationScreen.initState() | Screen lifetime |
| GoogleAuthController | GoogleAuthSignInButton.initState() | Widget lifetime |
| SplashController | SplashScreen.initState() | Screen lifetime |
| TutorController | showAiTutorPanel() | Panel lifetime |

### State Consumption Patterns

**Pattern 1: ListenableBuilder (primary)**
```dart
ListenableBuilder(
  listenable: SomeController.instance,
  builder: (context, _) { ... }
)
```

**Pattern 2: AnimatedBuilder (profile/theme)**
```dart
AnimatedBuilder(
  animation: SomeController.instance,
  builder: (context, child) { ... }
)
```

**Pattern 3: Manual addListener (splash)**
```dart
_controller.addListener(() { setState(() {}); })
```

---

## 11. Repository Layer

### Abstract Interfaces (5)

| Repository | Methods |
|------------|---------|
| CourseRepository | findById, findByTitle, coursesInCategory, all |
| ProgressRepository | progressFor, completedLessonIds, currentLessonId, startCourse, completeLesson, resetAll |
| NotificationRepository | fetch |
| TutorRepository | reply |
| CourseAuthoringRepository | allDrafts, findDraft, createDraft, updateDraft, deleteDraft, addLesson, updateLesson, deleteLesson, reorderLessons, publishCourse, unpublishCourse |

### Mock Implementations (5)

| Mock | Implements | Data Source |
|------|------------|-------------|
| MockCourseRepository | CourseRepository | MockCourseCatalog (15 courses) |
| MockProgressRepository | ProgressRepository | In-memory maps |
| MockNotificationRepository | NotificationRepository | 8 hardcoded items |
| MockTutorRepository | TutorRepository | Keyword matching |
| MockCourseAuthoringRepository | CourseAuthoringRepository | In-memory list |

---

## 12. Mock Data

### Mock Data Files (11)

| File | Data |
|------|------|
| mock_course_catalog.dart | 15 courses with full details |
| mock_course_repository.dart | Course lookup implementation |
| mock_progress_repository.dart | Progress tracking implementation |
| mock_home_data.dart | Home screen content |
| mock_explore_data.dart | Explore categories and courses |
| mock_progress_data.dart | Progress page data |
| mock_profile_data.dart | User profile data |
| mock_profile_photos.dart | Photo picker options |
| mock_lesson_content.dart | Lesson content blocks |
| mock_lesson_exercises.dart | Lesson exercises |
| mock_module_content_generator.dart | Game/exercise generation |
| mock_auth_service.dart | Auth simulation |
| mock_notification_repository.dart | Notification data |
| mock_tutor_repository.dart | Tutor responses |
| mock_course_authoring_repository.dart | Course authoring CRUD |
| mock_refresh.dart | Refresh simulation |

### Entities (12)

| Entity | Fields |
|--------|--------|
| CourseDetail | id, title, category, shortDescription, description, learningOutcomes, lessons, iconPath, brand, rating, level, studentCount, estimatedMinutes, progress |
| CourseLesson | id, title, durationMinutes, summary, state, materialPdfPath |
| CourseProgress | courseId, completedLessons, totalLessons, progress, currentLessonId |
| AppNotification | id, kind, title, message, createdAt, isRead, courseId, actionLabel |
| TutorMessage | role, text, createdAt, code, codeLabel |
| TutorMessageContext | courseId, courseTitle, lessonId, lessonTitle, stageTitle |
| CourseAuthoringDraft | id, title, description, category, language, level, estimatedMinutes, thumbnailPath, objectives, targetAudience, status, updatedAt, lessons |
| LessonDraft | id, title, description, objective, estimatedMinutes, order, materialPdfPath |
| DraftStatus | enum: draft, published |
| LessonContentBlock | type, text, label, items, heading, exercise |
| LessonExercise | type, title, instruction, code, correctedCode, blanks, options, choices, hint, explanation, gameType, correctOrder, expectedAnswer |
| CoursePlayerPreview | course, lessons, materiByLesson, gameByLesson, latihanByLesson |

---

## 13. Design System

### Widget Inventory (59 widgets)

**Animations (4):**
- AppAnimatedButton, AppAnimatedContainer, AppFade/FadeIn, AppScale/ScaleIn

**Avatar (1):**
- AppAvatar (network, initial, user constructors)

**Badges (1):**
- AppBadge (success, warning, error, info, neutral variants)

**Buttons (4):**
- AppButton (primary, secondary, outlined, text, danger variants)
- AppFloatingActionButton (standard, extended)
- AppIconButton
- AppLoadingButton

**Cards (6):**
- AppBaseCard, AppElevatedCard, AppOutlinedCard, AppInfoCard, AppStatCard, AppCourseCard

**Chips (3):**
- AppFilterChip, AppChoiceChip, AppInputChip

**Content (1):**
- AppCodeBlock

**Dialogs (4):**
- AppAlertDialog, AppBottomSheet, AppConfirmationDialog, AppLoadingDialog

**Extensions (1):**
- AppContextBreakpoints (screen metrics, breakpoints)

**Feedback (4):**
- AppBanner, AppNotificationCard, AppSnackBar, AppToast

**Inputs (10):**
- AppTextField, AppMultilineField, AppSearchField, AppDropdownField, AppCheckbox, AppRadioGroup, AppSwitch, AppOtpInput, AppOtpField, AppNumericKeypad

**Layout (6):**
- AppGap, AppDivider, AppContainer, AppScrollablePage, AppSafeArea, AppSection

**Lists (4):**
- AppTile, AppSettingsTile, AppProfileTile, AppCourseTile

**Loaders (5):**
- AppCircularLoader, AppLinearLoader, AppEmptyState, AppShimmer, AppSkeleton

**Navigation (5):**
- AppAppBar, AppNavDestination/AppBottomNav, AppFloatingBottomNav, AppPageHeader, AppSectionHeader

---

## 14. Theme System

### Theme Builder (AppTheme)

- `light()` → Light mode ThemeData
- `dark()` → Dark mode ThemeData
- `fromColorScheme()` → Custom theme from ColorScheme
- `dynamic()` → Android 12+ dynamic color

### Custom Theme Extension (AppThemeExtension)

Semantic colors not in standard ColorScheme:
- background, card, onCard, divider, border
- textPrimary, textSecondary, textDisabled
- success, warning, error, info (with container/onContainer variants)

### Color Palette

**Light:**
- Primary: #F97316 (Orange)
- Secondary: #514AF8 (Indigo)
- Success: #17B26A (Green)
- Warning: #F79009 (Amber)
- Error: #F04438 (Red)
- Info: #2E90FA (Blue)
- Background: #FCFDFD (Near-white)

**Dark:**
- Primary: #FF9A5F (Light Orange)
- Secondary: #9B9DFF (Light Indigo)
- Success: #47D16C (Bright Green)
- Warning: #FFC24B (Bright Amber)
- Error: #F97066 (Light Red)
- Info: #7CB8FF (Light Blue)
- Background: #101214 (Near-black)

### Typography

**Font Families:**
- Heading: PlusJakartaSans
- Body: Inter
- Code: JetBrainsMono

**Type Scale:** 17 text styles from displayLarge (57px) to caption (12px)

### Spacing

Token-based system: xxs(4), xs(8), sm(12), md(16), lg(24), xl(32), xxl(40), xxxl(48)

### Radius

Token-based system: small(8), medium(12), large(16), extraLarge(24), pill(100), circle(999)

### Duration

Token-based system: fastest(75ms), fast(150ms), medium(250ms), slow(350ms), slower(500ms), slowest(900ms)

### Elevation

Token-based system: flat(0), xs(1), sm(2), md(3), lg(4), xl(6), xxl(8), xxxl(12)

### Icon Sizes

Token-based system: xs(16), sm(18), md(20), lg(24), xl(28), xxl(32), xxxl(40), xxxxl(48)

---

## 15. Responsive Strategy

### Breakpoints

| Token | Value |
|-------|-------|
| smallPhone | 360px |
| phone | 600px |
| smallTablet | 840px |
| tablet | 1200px |
| desktop | 1440px |
| ultraWide | 1440px |

### Layout Tiers

- **compact:** < 600px (phone)
- **medium:** 600-839px (small tablet)
- **expanded:** 840-1199px (tablet)
- **large:** 1200-1439px (desktop)
- **extraLarge:** >= 1440px (ultra-wide)

### Responsive Padding

| Width | Horizontal | Vertical |
|-------|------------|----------|
| >= 1200px | 32px | 32px |
| >= 840px | 24px | 32px |
| < 840px | 16px | 24px |

### Responsive Spacing

| Width | Section Gap | Item Gap |
|-------|-------------|----------|
| >= 840px | 32px | 16px |
| < 840px | 24px | 12px |

### Context Extension

Provides: `isCompact`, `isMedium`, `isExpanded`, `isLarge`, `isExtraLarge`, `isPhone`, `isTablet`, `isDesktop`, `isWide`, `layoutTier`, `isLandscape`, `isPortrait`, `paddingTop`, `paddingBottom`, `keyboardHeight`, `isKeyboardVisible`, `appTextTheme`, `isDarkMode`

---

## 16. Accessibility

### Current Support

- Semantic labels pada interactive elements
- Sufficient color contrast (WCAG AA)
- Touch target minimum 48x48px
- Screen reader support via Semantics widget

### Future Enhancements

- Text scaling support
- High contrast mode
- Keyboard navigation
- Reduced motion support

---

## 17. Course Learning Architecture

### 3-Stage Learning Flow

```
Stage 0: Materi (Content/Reading)
    ↓
Stage 1: Game (Interactive Challenge)
    ↓
Stage 2: Latihan (Exercise/Practice)
    ↓
Mark Lesson Complete → Next Lesson or Course Complete
```

### Stage Navigation

- **Undo:** Back to previous stage or previous lesson
- **Next:** Advance stages, then mark lesson complete
- **End Session:** Show confirmation dialog before exiting

### AI Tutor Integration

- Accessible from any stage via chat button
- Opens as modal bottom sheet (mobile) or dialog (tablet/desktop)
- Context-aware (course, lesson, stage information)

### Preview Mode

- Mentor preview mode via `preview` parameter
- Uses `CoursePlayerPreview` data
- No progress tracking
- Shows toast on preview end

---

## 18. Materi

### Content Types

| Type | Description |
|------|-------------|
| heading | Section heading |
| subheading | Sub-section heading |
| paragraph | Text paragraph |
| code | Code block with syntax highlighting |
| bulletList | Bullet-point list |
| numberedList | Numbered list |
| tip | Tip/callout box |
| warning | Warning callout box |
| example | Example block |
| summary | Summary block |
| checklist | Checklist items |
| exercise | Embedded exercise |

### Content Generation

MockLessonContent generates content blocks for any course+lesson combination. Content includes:
- Course-specific code snippets (15 courses covered)
- Language-specific formatting
- Mixed content types per lesson

---

## 19. Game

### Game Types

| Type | Description |
|------|-------------|
| codeOrdering | Arrange code tokens in correct order |
| tokenCompletion | Fill in missing code tokens |
| multipleChoice | Select correct answer from options |
| identifyError | Find the error in code |
| outputPrediction | Predict code output |

### Game Generation

MockModuleContentGenerator generates games by topic keyword matching:
- hello → codeOrdering
- variabel → multipleChoice
- kondisi → tokenCompletion
- loop → outputPrediction
- generic → identifyError

---

## 20. Latihan

### Exercise Types

| Type | Description |
|------|-------------|
| codeCompletion | Fill in code blanks |
| codeCorrection | Fix code errors |
| codeExplanation | Explain code behavior |
| codeWriting | Write code from scratch |

### Exercise Generation

MockLessonExercises generates exercises by course:
- dasar-python: correction + explanation + writing
- javascript-modern: completion + correction + explanation
- mysql-dasar: completion + correction + writing
- flutter-untuk-pemula: completion + correction + explanation
- html-css-modern: completion + correction + writing

---

## 21. Exercise Architecture

### Exercise Components

- **ExerciseCard:** Container for exercise display
- **ExerciseFeedback:** Feedback display after submission
- **LessonExerciseView:** Main exercise view wrapper

### Exercise-Specific Widgets

- **CodeCompletionExercise:** Blank-filling interface
- **CodeCorrectionExercise:** Error-finding interface
- **CodeExplanationExercise:** Explanation input
- **CodeWritingExercise:** Code editor interface

---

## 22. AI Tutor

### Architecture

```
showAiTutorPanel(context, lessonContext: TutorLessonContext)
    ↓
TutorController (created per panel open)
    ↓
TutorRepository.reply(context, message)
    ↓
TutorMessage (assistant response)
    ↓
AiTutorPanel (chat UI)
```

### Panel Presentation

- **Mobile (< 720px):** ModalBottomSheet (92% height)
- **Tablet/Desktop (>= 720px):** Dialog (520x720 max)

### Message Types

- **Learner:** Right-aligned, primary color
- **Assistant:** Left-aligned, surface color, optional code block

### Suggested Prompts

- "Jelaskan bagian ini"
- "Kenapa kode ini error?"
- "Bisa kasih petunjuk?"
- "Aku masih bingung"

---

## 23. Notifications

### Notification Types (AppNotificationKind)

| Kind | Category |
|------|----------|
| courseUpdate | course |
| lessonReady | belajar |
| progress | belajar |
| newCourse | course |
| reminder | pengingat |

### Notification Groups

- Hari Ini
- Kemarin
- Minggu Ini
- Sebelumnya

### Filter Options

- Category: All, Belajar, Course, Pengingat
- Only Unread toggle
- Mark All Read action

---

## 24. Profile

### Profile Sections

1. **Identity:** Avatar, username, email, edit button
2. **Mentor:** "Kelola Course" (if isMentor)
3. **Preferences:** Theme, Notifications, Language
4. **Support:** Feedback, Help Center, About
5. **Legal:** Privacy Policy, User Policy
6. **Sign Out:** Destructive action with confirmation

### Profile Data

- username: MockProfileData.displayName ("Rina")
- email: MockProfileData.email ("rina@mentorinaja.id")
- isMentor: hardcoded true
- photoUrl: null (mock)

---

## 25. Edit Profile

### Edit Fields

- Avatar with photo picker bottom sheet
- Username text field (max 30 chars)

### Photo Picker Options

- Gallery (mock)
- Camera (mock)
- Cancel

### Save Flow

1. Validate changes
2. Call ProfileController.updateProfile()
3. Show success toast
4. Pop page

### Pop Guard

- PopScope with discard confirmation if changes unsaved

---

## 26. Backend Handoff

### Integration Points

#### Authentication

| Aspect | Detail |
|--------|--------|
| Current Implementation | MockAuthService (simulated delay, optional failure) |
| Backend Responsibility | Real authentication (email/password, OTP, Google) |
| Frontend Responsibility | Form validation, UI state management |
| Data Required | User credentials, OTP codes, Google ID tokens |
| Persistence | User session, refresh tokens |
| Authentication | Required for protected routes |
| Loading | Button loading state |
| Empty | N/A |
| Error | Form validation, network errors |
| Integration Status | Planned |

#### Course Catalog

| Aspect | Detail |
|--------|--------|
| Current Implementation | MockCourseRepository (15 static courses) |
| Backend Responsibility | Course CRUD, enrollment, search |
| Frontend Responsibility | Display, filtering, navigation |
| Data Required | Course list, course details, categories |
| Persistence | User enrollments |
| Authentication | Optional (browse), Required (enroll) |
| Loading | Skeleton loaders |
| Empty | Empty state with CTA |
| Error | Retry button |
| Integration Status | Planned |

#### Progress Tracking

| Aspect | Detail |
|--------|--------|
| Current Implementation | MockProgressRepository (in-memory maps) |
| Backend Responsibility | Progress persistence, analytics |
| Frontend Responsibility | Display, local state |
| Data Required | Completed lessons, current lesson, progress % |
| Persistence | Required |
| Authentication | Required |
| Loading | Skeleton loaders |
| Empty | Not enrolled state |
| Error | Retry with cached data |
| Integration Status | Planned |

#### Notifications

| Aspect | Detail |
|--------|--------|
| Current Implementation | MockNotificationRepository (8 items) |
| Backend Responsibility | Push notifications, notification CRUD |
| Frontend Responsibility | Display, filtering, mark read |
| Data Required | Notification list, unread count |
| Persistence | Read status |
| Authentication | Required |
| Loading | Skeleton loaders |
| Empty | Empty state |
| Error | Retry button |
| Integration Status | Planned |

#### AI Tutor

| Aspect | Detail |
|--------|--------|
| Current Implementation | MockTutorRepository (keyword matching) |
| Backend Responsibility | AI model integration, context management |
| Frontend Responsibility | Chat UI, message display |
| Data Required | User message, AI response, context |
| Persistence | Conversation history |
| Authentication | Required |
| Loading | Thinking indicator |
| Empty | Initial greeting |
| Error | Error message with retry |
| Integration Status | Planned |

#### Course Authoring

| Aspect | Detail |
|--------|--------|
| Current Implementation | MockCourseAuthoringRepository (in-memory CRUD) |
| Backend Responsibility | Course storage, publishing workflow |
| Frontend Responsibility | CRUD UI, validation |
| Data Required | Draft courses, lessons, publish status |
| Persistence | Required |
| Authentication | Required (mentor role) |
| Loading | Save indicators |
| Empty | Empty state with CTA |
| Error | Validation errors, save failures |
| Integration Status | Planned |

#### Profile Management

| Aspect | Detail |
|--------|--------|
| Current Implementation | MockProfileData (static) |
| Backend Responsibility | Profile CRUD, photo upload |
| Frontend Responsibility | Display, edit UI |
| Data Required | User profile, photo URL |
| Persistence | Required |
| Authentication | Required |
| Loading | Save indicators |
| Empty | N/A |
| Error | Save failure handling |
| Integration Status | Planned |

---

## 27. API Handoff

### Status: TBD

**No API endpoints have been defined yet.** All data is currently mocked.

### Frontend Expected Contracts

#### Course Catalog

```
GET /courses
Response: {
  courses: [
    {
      id: String,
      title: String,
      category: String,
      shortDescription: String,
      description: String,
      learningOutcomes: [String],
      lessons: [
        {
          id: String,
          title: String,
          durationMinutes: int,
          summary: String?
        }
      ],
      iconPath: String,
      rating: double,
      level: String?,
      studentCount: int?,
      estimatedMinutes: int?,
      progress: double?
    }
  ]
}
```

#### Progress

```
GET /progress
Response: {
  enrollments: [
    {
      courseId: String,
      completedLessons: int,
      totalLessons: int,
      progress: double,
      currentLessonId: String?
    }
  ]
}

POST /progress/{courseId}/complete
Request: { lessonId: String }
Response: { success: bool }
```

#### Notifications

```
GET /notifications
Response: {
  notifications: [
    {
      id: String,
      kind: String,
      title: String,
      message: String,
      createdAt: DateTime,
      isRead: bool,
      courseId: String?,
      actionLabel: String?
    }
  ]
}

PUT /notifications/{id}/read
Response: { success: bool }

PUT /notifications/read-all
Response: { success: bool }
```

#### AI Tutor

```
POST /tutor/reply
Request: {
  courseId: String,
  lessonId: String,
  stageTitle: String?,
  message: String
}
Response: {
  role: String,
  text: String,
  code: String?,
  codeLabel: String?
}
```

#### Profile

```
GET /profile
Response: {
  username: String,
  email: String,
  photoUrl: String?
}

PUT /profile
Request: { username: String?, photoUrl: String? }
Response: { success: bool }
```

**Note:** These contracts are based on frontend data needs and may not be the final API contracts.

---

## 28. QA Handoff

### Test Coverage

**Current State:** All tests intentionally removed during Phase 0.5.

**NOT APPLICABLE:** Frontend test suite was intentionally removed during Phase 0.5.

### Critical Flows

#### Authentication Flow

| Step | Expected Behavior |
|------|-------------------|
| 1. Open app | Splash screen displays for minimum 2 seconds |
| 2. First launch | Navigate to onboarding |
| 3. Complete onboarding | Navigate to authentication |
| 4. Enter email | Validate email format |
| 5. Continue | Navigate to OTP verification |
| 6. Enter OTP | Validate 6-digit code |
| 7. Verify | Navigate to home |
| 8. Google sign-in | Simulate sign-in, navigate to home |

#### Course Learning Flow

| Step | Expected Behavior |
|------|-------------------|
| 1. Select course | Display course detail |
| 2. Start course | Begin with lesson 1, stage 0 (Materi) |
| 3. Complete Materi | Advance to stage 1 (Game) |
| 4. Complete Game | Advance to stage 2 (Latihan) |
| 5. Complete Latihan | Mark lesson complete, advance to next lesson |
| 6. Complete last lesson | Navigate to course completed page |

#### Profile Management Flow

| Step | Expected Behavior |
|------|-------------------|
| 1. Navigate to profile | Display user info |
| 2. Edit profile | Navigate to edit page |
| 3. Change username | Update local state |
| 4. Save | Update ProfileController, show toast, pop |
| 5. Discard | Show confirmation, pop without saving |

### Edge Cases

- Network errors during API calls (future)
- Empty course catalog
- Empty notification list
- Empty progress (no enrollments)
- Invalid OTP codes
- Expired sessions
- Concurrent modifications
- Empty states

### Empty States

| Screen | Empty State |
|--------|-------------|
| Home | No courses in progress |
| Explore | No search results |
| Progress | No enrolled courses |
| Notifications | No notifications |
| Course List (Mentor) | No draft courses |

### Error States

| Screen | Error State |
|--------|-------------|
| Course Load | Retry button |
| Notification Load | Retry button |
| Profile Load | Retry button |
| Auth Failure | Error message with retry |
| OTP Failure | Error message with retry |

### Responsive Requirements

| Breakpoint | Behavior |
|------------|----------|
| < 600px | Single column, bottom navigation |
| 600-839px | Adaptive grid, bottom navigation |
| 840-1199px | Multi-column, bottom navigation |
| >= 1200px | Full layout, bottom navigation |

### Accessibility Requirements

- All interactive elements must have semantic labels
- Color contrast ratio >= 4.5:1
- Touch target size >= 48x48px
- Screen reader navigation support

### Navigation Requirements

- Back button behavior consistent
- Tab state preserved
- Deep linking support (future)
- Route parameters validated

### State Transitions

| State | Transition |
|-------|------------|
| idle → initializing | Splash start |
| initializing → routing | Init complete |
| routing → error | Init failed |
| not enrolled → enrolled | Start course |
| lesson incomplete → complete | Complete all stages |
| course incomplete → complete | Complete last lesson |

### Regression Risks

- Theme switching affects all screens
- Responsive layout changes
- Mock data updates
- Navigation flow changes
- State management changes

---

## 29. Preview Tooling

### 14 Preview Entrypoints

| File | Feature |
|------|---------|
| main_profile_preview.dart | ProfilePage |
| main_tutor_chat_preview.dart | AiTutorPanel |
| main_course_card_preview.dart | Course cards |
| main_onboarding_preview.dart | OnboardingScreen |
| main_login_preview.dart | AuthenticationScreen |
| main_otp_preview.dart | OtpVerificationScreen |
| main_verification_preview.dart | VerificationRequestScreen |
| main_course_card_vertical_preview.dart | Vertical course cards |
| main_home_preview.dart | HomePage |
| main_course_list_preview.dart | CourseListPage |
| main_progress_preview.dart | ProgressPage |
| main_notifications_preview.dart | NotificationPage |
| main_lesson_flow_preview.dart | CoursePlayerPage |
| main_course_player_preview.dart | CoursePlayerPage |

### Preview Pattern

Each preview entrypoint:
- Standalone MaterialApp with light/dark theme
- Single page or widget
- Development tooling only (NOT production)

---

## 30. Current Limitations

### Mock Data

- All data is hardcoded or generated
- No real API integration
- No data persistence
- No offline support

### Authentication

- All auth is simulated
- No real user management
- No session persistence
- No token refresh

### State Management

- No state restoration across app restarts
- No cross-session persistence
- Global mutable singletons

### Testing

- No automated tests
- No unit tests
- No widget tests
- No integration tests

### Performance

- No image caching
- No pagination
- No lazy loading
- No optimization

### Platform

- iOS build unverified (no macOS/Xcode)
- Android debug build unverified
- Application ID still `com.example.frontend`

---

## 31. Future Integration Points

### Backend APIs

- Authentication (email, OTP, Google)
- Course catalog (CRUD, search, enrollment)
- Progress tracking (completion, analytics)
- Notifications (push, CRUD)
- AI Tutor (model integration)
- Course authoring (publishing workflow)
- Profile management (CRUD, photo upload)

### State Management

- Consider Riverpod or Bloc for complex state
- Add state restoration
- Add cross-session persistence

### Testing

- Unit tests for controllers
- Widget tests for key components
- Integration tests for critical flows

### Performance

- Image caching
- Pagination
- Lazy loading
- Code splitting

### Analytics

- Event tracking
- Error reporting
- Performance monitoring

---

## 32. Current vs Future

| Aspect | Current | Future |
|--------|---------|--------|
| Data | Mock only | Real API |
| Auth | Simulated | Real authentication |
| Persistence | In-memory | Database + cache |
| State | ChangeNotifier | Possible Riverpod/Bloc |
| Tests | None | Unit + Widget + Integration |
| Performance | Basic | Optimized |
| Offline | None | Offline support |
| Analytics | None | Event tracking |
| Platform | Android/iOS (unverified) | Android/iOS (verified) |
| App ID | com.example.frontend | com.mentorin.aja |

---

*End of Documentation*
