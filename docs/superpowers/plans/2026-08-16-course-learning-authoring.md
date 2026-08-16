# Course Learning Experience & Course Authoring Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the Mentor Course Authoring flow and enrich the Student Course Player with block-based content and interactive games.

**Architecture:** A shared domain model connects Mentor authoring and Student learning. Authoring happens via `CourseAuthoringRepository` across 4 new editor screens. The Student Player consumes richer `LessonContentBlock` types and 5 new interactive `GameType`s. Mock repositories provide data until backend integration.

**Tech Stack:** Flutter, plain state management (ChangeNotifier), AppRouter

**Spec:** `docs/superpowers/specs/2026-08-16-course-learning-authoring-design.md`

## Global Constraints

- **Version floors:** Dart >= 3.12.0
- **Dependency limits:** No new dependencies beyond existing `flutter_svg`
- **Naming and copy rules:** Copy in Bahasa Indonesia, warm and concrete
- **Platform requirements:** Android, iOS, Windows targets configured
- **Design rules:** Use tokens from `AppColors`, `AppSpacing`, `AppTypeScale`, `AppRadius` — NEVER raw hex colors or arbitrary spacing numbers.

---

### Phase 1: Shared Domain & Repository Layer

#### Task 1: Update Lesson Content Model

**Files:**
- Modify: `frontend/lib/features/lesson/domain/entities/lesson_content.dart`
- Modify: `frontend/lib/features/lesson/data/mock_lesson_content.dart`

**Interfaces:**
- Produces: `LessonContentBlockType` extended with `heading`, `subheading`, `numberedList`, `warning`, `example`, `summary`, `checklist`

- [ ] **Step 1: Update the enum**
Modify `LessonContentBlockType` in `lesson_content.dart` to add the new types.
```dart
enum LessonContentBlockType {
  paragraph,
  code,
  bulletList,
  tip,
  exercise,
  // New types:
  heading,
  subheading,
  numberedList,
  warning,
  example,
  summary,
  checklist,
}
```

- [ ] **Step 2: Update mock content**
Modify `MockLessonContent.forLesson` in `mock_lesson_content.dart` to use the new types, making the mock data feel like a richer learning document. Add a `heading` block, a `warning` block, and an `example` block.

- [ ] **Step 3: Commit**
```bash
git add frontend/lib/features/lesson/domain/entities/lesson_content.dart
git add frontend/lib/features/lesson/data/mock_lesson_content.dart
git commit -m "feat(lesson): add new content block types to domain model"
```

#### Task 2: Update Lesson Exercise Model

**Files:**
- Modify: `frontend/lib/features/lesson/domain/entities/lesson_exercise.dart`
- Modify: `frontend/lib/features/lesson/data/mock_lesson_exercises.dart`

**Interfaces:**
- Produces: `LessonExerciseType` with `codeWriting`
- Produces: `GameType` enum

- [ ] **Step 1: Add new exercise type and game type enum**
Modify `lesson_exercise.dart` to add `codeWriting` to `LessonExerciseType` and create `GameType`. Add the new properties needed to `LessonExercise`.
```dart
enum GameType {
  codeOrdering,
  tokenCompletion,
  multipleChoice,
  identifyError,
  outputPrediction,
}

enum LessonExerciseType {
  codeCompletion,
  codeCorrection,
  codeExplanation,
  // New:
  codeWriting,
}

// Inside LessonExercise:
final GameType? gameType;
final List<int>? correctOrder;
final String? expectedAnswer;
```

- [ ] **Step 2: Update mock exercises**
Modify `MockLessonExercises` in `mock_lesson_exercises.dart` to include a sample `codeWriting` exercise in `latihanExercises` and map the new game properties.

- [ ] **Step 3: Commit**
```bash
git add frontend/lib/features/lesson/domain/entities/lesson_exercise.dart
git add frontend/lib/features/lesson/data/mock_lesson_exercises.dart
git commit -m "feat(lesson): add codeWriting and GameType to exercise model"
```

#### Task 3: Create Course Authoring Domain

**Files:**
- Create: `frontend/lib/features/course_authoring/domain/entities/draft_status.dart`
- Create: `frontend/lib/features/course_authoring/domain/entities/course_authoring_draft.dart`
- Create: `frontend/lib/features/course_authoring/domain/entities/lesson_draft.dart`

**Interfaces:**
- Produces: `DraftStatus`, `CourseAuthoringDraft`, `LessonDraft`

- [ ] **Step 1: Define DraftStatus**
Create `draft_status.dart`:
```dart
enum DraftStatus { draft, published }
```

- [ ] **Step 2: Define LessonDraft**
Create `lesson_draft.dart`:
```dart
class LessonDraft {
  const LessonDraft({
    required this.id,
    required this.title,
    required this.description,
    this.objective,
    this.estimatedMinutes = 10,
    this.order = 0,
    // (mock lists for material, games, exercises here for simplicity)
  });
  final String id;
  final String title;
  final String description;
  final String? objective;
  final int estimatedMinutes;
  final int order;
  // (copyWith method)
}
```

- [ ] **Step 3: Define CourseAuthoringDraft**
Create `course_authoring_draft.dart`:
```dart
import 'draft_status.dart';
import 'lesson_draft.dart';

class CourseAuthoringDraft {
  const CourseAuthoringDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.language,
    required this.level,
    this.estimatedMinutes,
    this.thumbnailPath,
    this.objectives = const [],
    required this.targetAudience,
    this.status = DraftStatus.draft,
    required this.updatedAt,
    this.lessons = const [],
  });
  // (fields and copyWith)
}
```

- [ ] **Step 4: Commit**
```bash
git add frontend/lib/features/course_authoring/domain/entities/
git commit -m "feat(authoring): create course and lesson draft entities"
```

#### Task 4: Create Course Authoring Repository

**Files:**
- Create: `frontend/lib/features/course_authoring/domain/repositories/course_authoring_repository.dart`
- Create: `frontend/lib/features/course_authoring/data/mock_course_authoring_repository.dart`
- Create: `frontend/lib/features/course_authoring/course_authoring.dart`

**Interfaces:**
- Produces: `CourseAuthoringRepository` and `MockCourseAuthoringRepository`

- [ ] **Step 1: Define interface**
Create `course_authoring_repository.dart` with methods to find, create, update courses and lessons.

- [ ] **Step 2: Create mock implementation**
Create `mock_course_authoring_repository.dart` extending `CourseAuthoringRepository` with in-memory lists and seed data.

- [ ] **Step 3: Export barrel**
Create `course_authoring.dart`:
```dart
export 'domain/entities/draft_status.dart';
export 'domain/entities/course_authoring_draft.dart';
export 'domain/entities/lesson_draft.dart';
export 'domain/repositories/course_authoring_repository.dart';
export 'data/mock_course_authoring_repository.dart';
```

- [ ] **Step 4: Commit**
```bash
git add frontend/lib/features/course_authoring/
git commit -m "feat(authoring): add authoring repository and mock data"
```

---

### Phase 2: Course Player Revision

#### Task 5: Implement New Content Block Renderers

**Files:**
- Modify: `frontend/lib/features/lesson/presentation/widgets/lesson_content_block_view.dart`

**Interfaces:**
- Consumes: updated `LessonContentBlockType`

- [ ] **Step 1: Add new view classes**
In `lesson_content_block_view.dart`, create private widgets for `_HeadingView`, `_SubheadingView`, `_NumberedListView`, `_WarningView`, `_ExampleView`, `_SummaryView`, `_ChecklistView`. Use `AppTypeScale` and `AppColors` from `context.appColors`.

- [ ] **Step 2: Update switch statement**
Update the `switch` in `LessonContentBlockView.build` to map the new types to their views.

- [ ] **Step 3: Commit**
```bash
git add frontend/lib/features/lesson/presentation/widgets/lesson_content_block_view.dart
git commit -m "feat(lesson): implement new content block renderers for materi"
```

#### Task 6: Implement Code Writing Exercise

**Files:**
- Create: `frontend/lib/features/lesson/presentation/widgets/exercises/code_writing_exercise.dart`
- Modify: `frontend/lib/features/lesson/presentation/widgets/exercises/lesson_exercise_view.dart`
- Modify: `frontend/lib/features/lesson/lesson.dart`

**Interfaces:**
- Consumes: `LessonExerciseType.codeWriting`
- Produces: `CodeWritingExercise`

- [ ] **Step 1: Create the code writing exercise**
Create `code_writing_exercise.dart` with a `TextField` (multiline, `AppTypeScale.code`) containing the `starterCode`. Implement the submit logic comparing input to `expectedAnswer`.

- [ ] **Step 2: Register in view dispatcher**
In `lesson_exercise_view.dart`, add the mapping for `LessonExerciseType.codeWriting` to return `CodeWritingExercise`.

- [ ] **Step 3: Export in barrel**
Add the export to `lesson.dart`.

- [ ] **Step 4: Commit**
```bash
git add frontend/lib/features/lesson/
git commit -m "feat(lesson): implement code writing exercise for latihan"
```

#### Task 7: Implement Game Flow Wrapper and Existing Games

**Files:**
- Create: `frontend/lib/features/lesson/presentation/widgets/games/game_view.dart`
- Create: `frontend/lib/features/lesson/presentation/widgets/games/token_completion_game.dart`
- Modify: `frontend/lib/features/lesson/presentation/stages/game_stage.dart`
- Modify: `frontend/lib/features/lesson/lesson.dart`

**Interfaces:**
- Produces: `GameView` widget replacing `LessonExerciseView` in the Game Stage

- [ ] **Step 1: Create GameView dispatcher**
Create `game_view.dart` that switches on `exercise.gameType`.

- [ ] **Step 2: Wrap existing exercises as games**
Create `token_completion_game.dart` which wraps `CodeCompletionExercise` with a game-specific title/instruction. (Do the same for multiple choice and error correction in subsequent files or the same file).

- [ ] **Step 3: Update Game Stage**
Modify `game_stage.dart` to render `GameView` instead of `LessonExerciseView`.

- [ ] **Step 4: Commit**
```bash
git add frontend/lib/features/lesson/
git commit -m "feat(lesson): add GameView dispatcher and update game stage"
```

#### Task 8: Implement Code Ordering Game

**Files:**
- Create: `frontend/lib/features/lesson/presentation/widgets/games/code_ordering_game.dart`
- Modify: `frontend/lib/features/lesson/presentation/widgets/games/game_view.dart`

**Interfaces:**
- Consumes: `GameType.codeOrdering`

- [ ] **Step 1: Create Code Ordering Game**
Create `code_ordering_game.dart`. Present `exercise.options` as tappable chips. Tapping them moves them to the answer area. Tapping in the answer area moves them back. Evaluate order against `correctOrder`.

- [ ] **Step 2: Register game**
Add to `game_view.dart` switch statement.

- [ ] **Step 3: Commit**
```bash
git add frontend/lib/features/lesson/
git commit -m "feat(lesson): implement code ordering interactive game"
```

---

### Phase 3: Mentor Course Authoring

#### Task 9: Profile Integration & Controller Update

**Files:**
- Modify: `frontend/lib/features/profile/logic/profile_controller.dart`
- Modify: `frontend/lib/features/profile/presentation/pages/profile_page.dart`
- Modify: `frontend/lib/routing/route_names.dart`
- Modify: `frontend/lib/app/app.dart`

**Interfaces:**
- Consumes: `ProfileController`
- Produces: Route `/mentor/courses`

- [ ] **Step 1: Update controller**
Add `bool get isMentor => true;` to `ProfileController`.

- [ ] **Step 2: Update route names and app.dart**
Add `static const String mentorCourses = '/mentor/courses';` to `AppRoutes` and placeholder route in `app.dart`.

- [ ] **Step 3: Add Mentor section to ProfilePage**
In `profile_page.dart`, insert a new `ProfileSettingsSection` with title 'Mentor' right after the identity header, visible only if `isMentor` is true, containing one row for 'Kelola Course' that navigates to `mentorCourses`.

- [ ] **Step 4: Commit**
```bash
git add frontend/lib/features/profile/ frontend/lib/routing/ frontend/lib/app/
git commit -m "feat(authoring): integrate mentor management into profile"
```

#### Task 10: Course List Page

**Files:**
- Create: `frontend/lib/features/course_authoring/presentation/pages/course_list_page.dart`
- Modify: `frontend/lib/app/app.dart`

**Interfaces:**
- Produces: `CourseListPage` screen

- [ ] **Step 1: Create CourseListPage**
Create `course_list_page.dart`. Fetch drafts from `MockCourseAuthoringRepository`. Show a list of course cards (title, lesson count, status). Include a floating action button or top CTA "Buat Course".

- [ ] **Step 2: Update routing**
Update `app.dart` to route `/mentor/courses` to `CourseListPage()`.

- [ ] **Step 3: Commit**
```bash
git add frontend/lib/features/course_authoring/ frontend/lib/app/
git commit -m "feat(authoring): create course list page"
```

#### Task 11: Course Create Page

**Files:**
- Create: `frontend/lib/features/course_authoring/presentation/pages/course_create_page.dart`
- Modify: `frontend/lib/routing/route_names.dart`
- Modify: `frontend/lib/app/app.dart`

**Interfaces:**
- Produces: `CourseCreatePage` screen

- [ ] **Step 1: Create CourseCreatePage**
Create form with fields: Nama Course, Deskripsi, Kategori, Bahasa Pemrograman, Level. CTA "Buat Course" saves via repository and navigates to the editor. Use design system input widgets.

- [ ] **Step 2: Update routing**
Add `/mentor/courses/create` route.

- [ ] **Step 3: Commit**
```bash
git add frontend/lib/features/course_authoring/ frontend/lib/routing/ frontend/lib/app/
git commit -m "feat(authoring): create course creation form"
```

#### Task 12: Course Editor Page

**Files:**
- Create: `frontend/lib/features/course_authoring/presentation/pages/course_editor_page.dart`
- Modify: `frontend/lib/routing/route_names.dart`
- Modify: `frontend/lib/app/app.dart`

**Interfaces:**
- Produces: `CourseEditorPage` screen

- [ ] **Step 1: Create CourseEditorPage**
Show course header (editable), Objectives list (add/remove), and a list of lessons. Each lesson tile shows status and navigates to the lesson editor.

- [ ] **Step 2: Update routing**
Add `/mentor/courses/{courseId}` route.

- [ ] **Step 3: Commit**
```bash
git add frontend/lib/features/course_authoring/ frontend/lib/routing/ frontend/lib/app/
git commit -m "feat(authoring): create course editor page"
```

#### Task 13: Lesson Editor Page & Material Tab

**Files:**
- Create: `frontend/lib/features/course_authoring/presentation/pages/lesson_editor_page.dart`
- Create: `frontend/lib/features/course_authoring/presentation/widgets/material_block_editor.dart`
- Modify: `frontend/lib/routing/route_names.dart`
- Modify: `frontend/lib/app/app.dart`

**Interfaces:**
- Produces: `LessonEditorPage` screen

- [ ] **Step 1: Create LessonEditorPage structure**
Create `lesson_editor_page.dart` with a `DefaultTabController` (3 tabs: MATERI, GAME, LATIHAN).

- [ ] **Step 2: Create MaterialBlockEditor**
Create `material_block_editor.dart`. A list of blocks where each block has a dropdown for type and a text field for content.

- [ ] **Step 3: Update routing**
Add `/mentor/courses/{courseId}/lessons/{lessonId}` route.

- [ ] **Step 4: Commit**
```bash
git add frontend/lib/features/course_authoring/ frontend/lib/routing/ frontend/lib/app/
git commit -m "feat(authoring): create lesson editor page and material tab"
```

#### Task 14: Game and Exercise Editor Tabs

**Files:**
- Create: `frontend/lib/features/course_authoring/presentation/widgets/game_editor.dart`
- Create: `frontend/lib/features/course_authoring/presentation/widgets/exercise_editor.dart`
- Modify: `frontend/lib/features/course_authoring/presentation/pages/lesson_editor_page.dart`

**Interfaces:**
- Produces: `GameEditor`, `ExerciseEditor` widgets

- [ ] **Step 1: Create GameEditor**
Create `game_editor.dart`. Dropdown for GameType. Show type-specific fields (e.g. correctOrder for codeOrdering).

- [ ] **Step 2: Create ExerciseEditor**
Create `exercise_editor.dart`. Fields for instruction, starter code, expected answer.

- [ ] **Step 3: Integrate into LessonEditorPage**
Add these to the 2nd and 3rd tabs in `lesson_editor_page.dart`.

- [ ] **Step 4: Commit**
```bash
git add frontend/lib/features/course_authoring/
git commit -m "feat(authoring): create game and exercise editor tabs"
```

#### Task 15: Preview & Publish Flow

**Files:**
- Create: `frontend/lib/features/course_authoring/logic/authoring_preview_adapter.dart`
- Create: `frontend/lib/features/course_authoring/presentation/widgets/publish_validation_panel.dart`
- Modify: `frontend/lib/features/course_authoring/presentation/pages/course_editor_page.dart`
- Modify: `frontend/lib/routing/route_names.dart`
- Modify: `frontend/lib/app/app.dart`

**Interfaces:**
- Produces: Preview route reusing `CoursePlayerPage`
- Produces: Publish validation UI

- [ ] **Step 1: Create preview adapter**
Create `authoring_preview_adapter.dart` with methods to convert `CourseAuthoringDraft` to `CourseDetail` and `LessonDraft` to `CourseLesson`.

- [ ] **Step 2: Implement Preview Route**
Add `/mentor/courses/{courseId}/preview` to `app.dart`. Resolve to `CoursePlayerPage`, but wrap or inject the preview adapter data.

- [ ] **Step 3: Implement publish validation**
Create `publish_validation_panel.dart` to show missing fields (title, description, lessons, material, game, exercise). Add Publish action to `CourseEditorPage` that checks validation.

- [ ] **Step 4: Commit**
```bash
git add frontend/lib/features/course_authoring/ frontend/lib/routing/ frontend/lib/app/
git commit -m "feat(authoring): implement preview and publish validation flow"
```

#### Task 16: Ensure Code Quality

**Files:**
- All touched files

- [ ] **Step 1: Run code formatter**
Run `dart format .`

- [ ] **Step 2: Run analyzer**
Run `flutter analyze`. Address any issues (unused imports, missing required fields, type mismatches).

- [ ] **Step 3: Run tests**
Run `flutter test`. Fix any broken existing tests (especially `course_player_page_test.dart` due to UI structure changes).

- [ ] **Step 4: Commit**
```bash
git add .
git commit -m "chore: formatting, analyzer fixes and test adjustments"
```

---
