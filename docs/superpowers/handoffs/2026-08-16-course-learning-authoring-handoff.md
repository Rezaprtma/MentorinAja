# Course Learning & Authoring — Implementation Handoff

## 1. Current Status

- **Date:** 2026-08-16
- **Project area:** Frontend (Flutter application)
- **Current phase:** Shared Domain Model & Repository Layer (Completed). Course Player Revision (In Progress). Mentor Course Authoring (Pending).
- **Current task:** Task 5: Implement New Content Block Renderers
- **Last completed task:** Task 4: Create Course Authoring Repository (and its fix for feature coupling)
- **Next task to continue:** Task 6: Implement Code Writing Exercise
- **Overall completion status:** Phase 1 (Shared Domain Model & Repository Layer) is completed. Phase 2 (Course Player Revision) is in progress with Task 5 partially completed. Phase 3 (Mentor Course Authoring) is pending.

Implementation must resume from **Task 5 (Implement New Content Block Renderers)** and then continue sequentially with Task 6.

## 2. Completed Tasks

### Task 1: Update Lesson Content Model

- **Implemented:** Extended the `LessonContentBlockType` enum with new content block types to support richer learning documents.
- **Files created/modified:**
    - Modified: `frontend/lib/features/lesson/domain/entities/lesson_content.dart`
    - Modified: `frontend/lib/features/lesson/data/mock_lesson_content.dart`
- **Important models/enums/interfaces introduced:** `LessonContentBlockType` now includes `heading`, `subheading`, `numberedList`, `warning`, `example`, `summary`, `checklist`.
- **Connection to later tasks:** This provides the foundational enum values for rendering richer content in the Materi stage (Task 5) and for the Material Editor in Course Authoring (Task 13).
- **Important decisions made:** None beyond what was in the plan. The implementation correctly added the enum values and updated the mock data to include examples of these new block types.

### Task 2: Update Lesson Exercise Model

- **Implemented:** Added `codeWriting` to `LessonExerciseType` and created the `GameType` enum with its values. Also added new fields (`gameType`, `correctOrder`, `expectedAnswer`) to the `LessonExercise` class and updated mock data.
- **Files created/modified:**
    - Modified: `frontend/lib/features/lesson/domain/entities/lesson_exercise.dart`
    - Modified: `frontend/lib/features/lesson/data/mock_lesson_exercises.dart`
    - Modified: `frontend/lib/features/lesson/presentation/widgets/exercises/lesson_exercise_view.dart` (added a placeholder for `codeWriting` to maintain compilation, as this file performs an exhaustive switch).
- **Important models/enums/interfaces introduced:**
    - `LessonExerciseType` now includes `codeWriting`.
    - `GameType` enum (codeOrdering, tokenCompletion, multipleChoice, identifyError, outputPrediction).
    - `LessonExercise` class now has `gameType`, `correctOrder`, `expectedAnswer` fields.
- **Connection to later tasks:** These enums and fields are crucial for defining new game types in the Game stage (Task 7, 8) and for the Game and Exercise Editors in Course Authoring (Task 14). The placeholder in `lesson_exercise_view.dart` ensures the app compiles until Task 6 implements the actual `codeWriting` widget.
- **Important decisions made:** An exhaustive switch in `LessonExerciseView` required adding a temporary placeholder (`SizedBox.shrink()`) for the `codeWriting` type to ensure compilation, which was explicitly noted in the implementation plan's fix round.

### Task 3 & 4: Create Course Authoring Domain + Repository

- **Implemented:** Created all necessary domain entities for Course Authoring and implemented the abstract repository interface with a mock in-memory implementation. A critical feature coupling issue was resolved by moving shared enums to a dedicated `shared/enums/` location.
- **Files created/modified:**
    - Created: `frontend/lib/shared/enums/enums.dart` (containing `LessonContentBlockType`, `LessonExerciseType`, `GameType`)
    - Created: `frontend/lib/features/course_authoring/domain/entities/draft_status.dart`
    - Created: `frontend/lib/features/course_authoring/domain/entities/course_authoring_draft.dart`
    - Created: `frontend/lib/features/course_authoring/domain/entities/lesson_draft.dart`
    - Created: `frontend/lib/features/course_authoring/domain/entities/material_block_draft.dart`
    - Created: `frontend/lib/features/course_authoring/domain/entities/game_draft.dart`
    - Created: `frontend/lib/features/course_authoring/domain/entities/game_choice_draft.dart`
    - Created: `frontend/lib/features/course_authoring/domain/entities/blank_draft.dart`
    - Created: `frontend/lib/features/course_authoring/domain/entities/exercise_draft.dart`
    - Created: `frontend/lib/features/course_authoring/domain/repositories/course_authoring_repository.dart`
    - Created: `frontend/lib/features/course_authoring/data/mock_course_authoring_repository.dart`
    - Created: `frontend/lib/features/course_authoring/course_authoring.dart` (barrel export)
    - Modified: `frontend/lib/features/lesson/domain/entities/lesson_content.dart` (updated import)
    - Modified: `frontend/lib/features/lesson/domain/entities/lesson_exercise.dart` (updated import)
- **Important models/enums/interfaces introduced:**
    - `DraftStatus` enum.
    - `CourseAuthoringDraft` entity (representing a mentor's course draft).
    - `LessonDraft` entity.
    - `MaterialBlockDraft`, `GameDraft`, `GameChoiceDraft`, `BlankDraft`, `ExerciseDraft` entities.
    - `CourseAuthoringRepository` abstract interface.
    - `MockCourseAuthoringRepository` concrete implementation with seed data.
- **Connection to later tasks:** These entities and repository form the entire backend for the Mentor Course Authoring feature (Tasks 9-15). The mock implementation provides the data for UI development.
- **Important decisions made:** The shared enums (`LessonContentBlockType`, `LessonExerciseType`, `GameType`) were moved from `features/lesson/domain/entities/` to `frontend/lib/shared/enums/enums.dart` to resolve a feature coupling violation and allow both `lesson` and `course_authoring` features to depend on them without violating isolation principles.

## 3. Current Task — Task 5

**Task 5: Implement New Content Block Renderers**

- **File(s) currently being modified:** `frontend/lib/features/lesson/presentation/widgets/lesson_content_block_view.dart`
- **What has already been implemented:** The `LessonContentBlockView` switch statement has been updated to include cases for all new `LessonContentBlockType` values: `heading`, `subheading`, `numberedList`, `warning`, `example`, `summary`, `checklist`. Placeholder renderers (`_HeadingView`, `_SubheadingView`, etc.) have been implemented as private `StatelessWidget`s within this file.
- **What remains unfinished:**
    - The new renderers (`_HeadingView`, `_SubheadingView`, `_NumberedListView`, `_WarningView`, `_ExampleView`, `_SummaryView`, `_ChecklistView`) are implemented using basic `Text` widgets or simple `Container`s with `Text`. They currently lack the specific design system styling (e.g., icons, detailed layouts, semantic color usage for warning/example blocks) and full responsiveness specified in the Design Spec and Global Constraints.
    - Integration of complex layouts, such as displaying numbered items with proper indentation, styling for checklists, and accurate application of semantic colors for `warning` and `example` types.
- **Current renderer architecture:** A `switch` statement based on `block.type` dispatches to private `_View` widgets within `lesson_content_block_view.dart`.
- **New `LessonContentBlockType` values that must be supported:** All 7 new types: `heading`, `subheading`, `numberedList`, `warning`, `example`, `summary`, `checklist`.
- **Any temporary/incomplete code:** The implementations of `_HeadingView`, `_SubheadingView`, `_NumberedListView`, `_WarningView`, `_ExampleView`, `_SummaryView`, `_ChecklistView` are functional but require refinement to match the full design specification. For instance, `_ChecklistView` only shows checkboxes visually without interaction.
- **Any compile/test state known at this point:** The project currently compiles and all existing tests pass. `flutter analyze` reports 0 issues. No new tests specifically for the new renderers have been added yet, as this task primarily focuses on UI rendering.

## 4. Remaining Tasks

### Task 6: Implement Code Writing Exercise
- **Goal:** Create the UI widget for the new `codeWriting` exercise type in the Latihan stage.
- **Files expected to be created/modified:**
    - Create: `frontend/lib/features/lesson/presentation/widgets/exercises/code_writing_exercise.dart`
    - Modify: `frontend/lib/features/lesson/presentation/widgets/exercises/lesson_exercise_view.dart`
    - Modify: `frontend/lib/features/lesson/lesson.dart`
- **Dependencies on previous tasks:** Depends on `LessonExerciseType.codeWriting` and `LessonExercise` fields (`expectedAnswer`, `starterCode`) from Task 2.
- **Important implementation requirements:**
    - Use a multiline `TextField` with `AppTypeScale.code` for code input.
    - Implement submit logic to compare user input with `expectedAnswer`.
    - Provide feedback (correct/incorrect) and hint functionality.
- **Expected output:** A functional code editor-like interface for students to write and submit code, with appropriate feedback.
- **Validation requirements:** Widget tests for rendering, input, submission, feedback, and hints.

### Task 7: Implement Game Flow Wrapper and Existing Games
- **Goal:** Create a dispatcher for game types and wrap existing exercises as games in the Game stage.
- **Files expected to be created/modified:**
    - Create: `frontend/lib/features/lesson/presentation/widgets/games/game_view.dart`
    - Create: `frontend/lib/features/lesson/presentation/widgets/games/token_completion_game.dart`
    - Modify: `frontend/lib/features/lesson/presentation/stages/game_stage.dart`
    - Modify: `frontend/lib/features/lesson/lesson.dart`
- **Dependencies on previous tasks:** Depends on `GameType` enum from Task 2, and existing `CodeCompletionExercise` from the `lesson` feature.
- **Important implementation requirements:**
    - `GameView` must switch rendering based on `GameType`.
    - Wrap `CodeCompletionExercise` (and later other exercise types) with a game-specific UI frame.
- **Expected output:** The Game stage should correctly render and manage different game types, starting with token completion.
- **Validation requirements:** Widget tests for `GameView` dispatching, and for `TokenCompletionGame` functionality within the game context.

### Task 8: Implement Code Ordering Game
- **Goal:** Implement the interactive Code Ordering game.
- **Files expected to be created/modified:**
    - Create: `frontend/lib/features/lesson/presentation/widgets/games/code_ordering_game.dart`
    - Modify: `frontend/lib/features/lesson/presentation/widgets/games/game_view.dart`
- **Dependencies on previous tasks:** Depends on `GameType.codeOrdering` and `GameDraft` fields (`tokens`, `correctOrder`) from Task 2/3.
- **Important implementation requirements:**
    - Implement a UI where code lines/tokens can be reordered (via tap-to-place).
    - Provide visual feedback for placement, undo, reset, and correctness.
- **Expected output:** An interactive Code Ordering game where users can assemble code snippets.
- **Validation requirements:** Widget tests for token placement, reordering, feedback, and correctness.

### Task 9: Profile Integration & Controller Update
- **Goal:** Add a "Mentor" section to the Profile page with a "Kelola Course" link.
- **Files expected to be created/modified:**
    - Modify: `frontend/lib/features/profile/logic/profile_controller.dart`
    - Modify: `frontend/lib/features/profile/presentation/pages/profile_page.dart`
    - Modify: `frontend/lib/routing/route_names.dart`
    - Modify: `frontend/lib/app/app.dart`
- **Dependencies on previous tasks:** None direct, but relies on `ProfileController` and `AppRoutes`.
- **Important implementation requirements:**
    - Introduce `isMentor` flag in `ProfileController` (mock for now).
    - Dynamically show/hide the "Mentor" section based on `isMentor`.
    - Add a new route `/mentor/courses` and connect it.
- **Expected output:** A new "Mentor" section visible in the Profile tab, with a clickable "Kelola Course" option.
- **Validation requirements:** Widget tests for section visibility, navigation, and mock `isMentor` state.

### Task 10: Course List Page
- **Goal:** Implement the Mentor's course listing page.
- **Files expected to be created/modified:**
    - Create: `frontend/lib/features/course_authoring/presentation/pages/course_list_page.dart`
    - Modify: `frontend/lib/app/app.dart`
- **Dependencies on previous tasks:** Depends on `CourseAuthoringRepository` from Task 4.
- **Important implementation requirements:**
    - Display a list of `CourseAuthoringDraft`s using cards (title, lesson count, status).
    - "Buat Course" CTA to navigate to course creation.
    - Handle empty state.
- **Expected output:** A functional list of courses for a mentor, with creation and navigation options.
- **Validation requirements:** Widget tests for list rendering, empty state, and navigation.

### Task 11: Course Create Page
- **Goal:** Implement the form for creating a new course draft.
- **Files expected to be created/modified:**
    - Create: `frontend/lib/features/course_authoring/presentation/pages/course_create_page.dart`
    - Modify: `frontend/lib/routing/route_names.dart`
    - Modify: `frontend/lib/app/app.dart`
- **Dependencies on previous tasks:** Depends on `CourseAuthoringDraft` and `CourseAuthoringRepository` from Task 4.
- **Important implementation requirements:**
    - Implement a form with required fields (Name, Description, Category, Language, Level, etc.).
    - Use existing Design System input widgets.
    - Validate inputs and save to repository upon submission.
- **Expected output:** A form to create new course drafts.
- **Validation requirements:** Widget tests for form fields, validation, and submission.

### Task 12: Course Editor Page
- **Goal:** Implement the page for editing course details and managing lessons.
- **Files expected to be created/modified:**
    - Create: `frontend/lib/features/course_authoring/presentation/pages/course_editor_page.dart`
    - Modify: `frontend/lib/routing/route_names.dart`
    - Modify: `frontend/lib/app/app.dart`
- **Dependencies on previous tasks:** Depends on `CourseAuthoringDraft`, `LessonDraft` from Task 4.
- **Important implementation requirements:**
    - Display editable course metadata.
    - List lessons with reorder functionality.
    - Provide "Tambah Pelajaran" and navigation to lesson editor.
    - Include Preview, Save, Publish/Unpublish actions in the app bar.
- **Expected output:** A detailed course editor with lesson management.
- **Validation requirements:** Widget tests for course details, lesson list, actions, and navigation.

### Task 13: Lesson Editor Page & Material Tab
- **Goal:** Implement the multi-tab lesson editor and the Material content editing tab.
- **Files expected to be created/modified:**
    - Create: `frontend/lib/features/course_authoring/presentation/pages/lesson_editor_page.dart`
    - Create: `frontend/lib/features/course_authoring/presentation/widgets/material_block_editor.dart`
    - Modify: `frontend/lib/routing/route_names.dart`
    - Modify: `frontend/lib/app/app.dart`
- **Dependencies on previous tasks:** Depends on `LessonDraft`, `MaterialBlockDraft`, `LessonContentBlockType` from Tasks 1, 3, 4.
- **Important implementation requirements:**
    - Lesson meta fields.
    - 3 tabs: Materi, Game, Latihan.
    - Material tab: list of editable `MaterialBlockDraft`s with type selection and content input.
- **Expected output:** A tabbed lesson editor with a functional material content tab.
- **Validation requirements:** Widget tests for tab switching, block editing (add/remove/reorder), and type-specific input.

### Task 14: Game and Exercise Editor Tabs
- **Goal:** Implement the Game and Exercise editing tabs within the Lesson Editor.
- **Files expected to be created/modified:**
    - Create: `frontend/lib/features/course_authoring/presentation/widgets/game_editor.dart`
    - Create: `frontend/lib/features/course_authoring/presentation/widgets/exercise_editor.dart`
    - Modify: `frontend/lib/features/course_authoring/presentation/pages/lesson_editor_page.dart`
- **Dependencies on previous tasks:** Depends on `GameDraft`, `ExerciseDraft`, `GameType`, `LessonExerciseType` from Tasks 2, 3, 4.
- **Important implementation requirements:**
    - Game tab: dropdown for `GameType`, showing type-specific forms.
    - Exercise tab: fields for instruction, starter code, expected answer.
- **Expected output:** Fully functional Game and Exercise editing tabs.
- **Validation requirements:** Widget tests for form fields, type-specific logic, and saving changes.

### Task 15: Preview & Publish Flow
- **Goal:** Implement the course preview functionality and the draft/publish logic with validation.
- **Files expected to be created/modified:**
    - Create: `frontend/lib/features/course_authoring/logic/authoring_preview_adapter.dart`
    - Create: `frontend/lib/features/course_authoring/presentation/widgets/publish_validation_panel.dart`
    - Modify: `frontend/lib/features/course_authoring/presentation/pages/course_editor_page.dart`
    - Modify: `frontend/lib/routing/route_names.dart`
    - Modify: `frontend/lib/app/app.dart`
- **Dependencies on previous tasks:** All authoring entities and Course Player components.
- **Important implementation requirements:**
    - Adapter to convert `CourseAuthoringDraft` to `CourseDetail` for preview.
    - Route for preview that reuses `CoursePlayerPage`.
    - UI for publish/unpublish.
    - Validation logic for publishing with a clear visual feedback panel.
- **Expected output:** A working preview of a mentor's draft and a robust publish flow.
- **Validation requirements:** Widget tests for preview rendering, validation logic, and publish state changes.

### Task 16: Ensure Code Quality
- **Goal:** Ensure all new code adheres to project standards.
- **Files expected to be created/modified:** All touched files.
- **Dependencies on previous tasks:** All previous tasks.
- **Important implementation requirements:** Run `dart format .`, `flutter analyze`, `flutter test`. Address all issues.
- **Expected output:** Clean, well-tested, and formatted codebase.
- **Validation requirements:** Zero analyzer issues, all tests pass.

## 5. Architecture State

- **Feature structure:** The `frontend/lib/features/course_authoring/` module has been created. It contains its own `domain/entities`, `domain/repositories`, `data/`, and `course_authoring.dart` barrel. The `frontend/lib/features/lesson/` module remains.
- **Domain layer:**
    - **Shared enums:** `LessonContentBlockType`, `LessonExerciseType`, `GameType` are now defined in `frontend/lib/shared/enums/enums.dart`, allowing both lesson and authoring features to import them.
    - **Lesson models:** `LessonContent` and `LessonExercise` (in `features/lesson/domain/entities/`) are updated to use the shared enums and include `codeWriting` exercise type and game-specific fields.
    - **Course Authoring models:** `CourseAuthoringDraft`, `LessonDraft`, `MaterialBlockDraft`, `GameDraft`, `ExerciseDraft` and supporting entities are defined under `features/course_authoring/domain/entities/`. These mirror the student-facing models but are specifically for authoring purposes.
- **Data layer:**
    - `mock_lesson_content.dart` (in `features/lesson/data/`) is updated to generate richer content using the new `LessonContentBlockType`s.
    - `mock_lesson_exercises.dart` (in `features/lesson/data/`) is updated to include `codeWriting` samples and game-related properties.
    - `mock_course_authoring_repository.dart` (in `features/course_authoring/data/`) provides an in-memory implementation of the `CourseAuthoringRepository` with seed data.
- **Repository layer:**
    - `CourseRepository` (in `features/course/domain/repositories/`) remains for student access.
    - `CourseAuthoringRepository` (in `features/course_authoring/domain/repositories/`) is defined for mentor authoring operations.
- **Lesson model relationships:** `LessonContentBlock` and `LessonExercise` (student-facing) use the shared enums. `LessonDraft` (authoring-facing) holds lists of `MaterialBlockDraft`, `GameDraft`, `ExerciseDraft`, which mirror the student content structure.
- **Exercise/Game model relationships:** `LessonExercise` (student-facing) has a `gameType` field to differentiate game mechanics. `GameDraft` and `ExerciseDraft` (authoring-facing) capture the mentor-defined game and exercise configurations.
- **Course Authoring model relationships:** `CourseAuthoringDraft` contains a list of `LessonDraft`s.
- **How Student Course Player and Mentor Course Authoring are intended to share domain concepts:** Both ultimately refer to the same set of shared enums for content block types, exercise types, and game types. The authoring-specific draft models are designed to be converted into student-facing `CourseDetail`/`CourseLesson` models for preview, ensuring a consistent student experience.

## 6. Important Existing Project Rules

- **Flutter/Dart architecture:** Adhere to the `lib/features/` structure, `lib/core/` for cross-cutting, `lib/shared/` for reusable.
- **Existing design system:** Always use `frontend/lib/shared/design_system/` components.
- **AppColors, AppSpacing, AppTypeScale, AppRadius:** Use these token layers exclusively.
- **No raw hex colors:** Absolutely no `Color(0xFF...)` outside theme files.
- **No arbitrary spacing values:** Use `AppSpacing` enum values.
- **Bahasa Indonesia UI copy:** All user-facing text must be in Bahasa Indonesia.
- **Existing Material → Game → Latihan flow:** This stage structure must be preserved in Course Player.
- **Existing Course Player navigation behavior:** Floating control bar, auto-hide/show, previous/next stage/lesson navigation must be maintained.
- **No unnecessary dependencies:** Avoid adding new `pubspec.yaml` dependencies unless absolutely critical and justified.
- **Existing state management approach:** Continue using `ChangeNotifier` / plain Flutter state management (no Riverpod, Bloc, etc.).
- **Existing routing approach:** Use the custom Navigator 2.0 `AppRouter` and `AppRoutes` constants.
- **Android + iOS are the active product targets:** All UI/UX should prioritize these platforms.
- **Windows is OUT OF SCOPE for this project:** Do not implement or maintain Windows-specific UI. Do not validate on Windows.

## 7. Backend / API Handoff

The frontend is preparing for a backend API that will provide persistence for mentor-authored course content.

- **`CourseAuthoringDraft`:** Full course metadata (id, title, description, category, language, level, etc.), objectives, target audience, `DraftStatus`, and list of `LessonDraft`s. This will be the top-level entity for storing mentor-created courses.
- **`LessonDraft`:** Lesson metadata (id, title, description, objective, estimatedMinutes), and its nested `LessonMaterialDraft`, `GameDraft`s, and `ExerciseDraft`s.
- **`MaterialBlockDraft`:** Represents individual content blocks within a lesson's material, including type (`LessonContentBlockType`), text, label, and items.
- **`GameDraft`:** Game configuration (id, type (`GameType`), question, instruction, difficulty, options, correct answers, hints, feedback, points). This will encapsulate all details needed to reconstruct and validate a game.
- **`ExerciseDraft`:** Exercise configuration (id, title, instruction, starterCode, `expectedConcept`, `expectedAnswer`, hints, feedback, difficulty).
- **`DraftStatus`:** Enum (`draft`, `published`) indicating the publication state of a course.
- **Repository operations:** The `CourseAuthoringRepository` defines the contract for CRUD (Create, Read, Update, Delete) operations on courses and lessons, as well as publishing/unpublishing and reordering. These operations will eventually map to API calls.
- **Expected persistence requirements:** All `CourseAuthoringDraft` data, including nested lessons, materials, games, and exercises, will need to be persisted by the backend.
- **Expected API contract areas that are currently TBD:**
    - Specific API endpoints (e.g., `/api/mentor/courses`, `/api/mentor/courses/{id}/lessons`).
    - Authentication and authorization mechanisms for mentor roles.
    - Data transfer objects (DTOs) for API requests and responses.
    - Real-time updates for collaboration (if any).
- **Implemented frontend mock behavior:** `MockCourseAuthoringRepository` currently simulates all repository operations in-memory.
- **Expected future backend behavior:** The backend will implement the `CourseAuthoringRepository` contract via HTTP services, storing data in a database.
- **Things that are NOT implemented yet:** The actual network layer, API calls, and backend integration. The current implementation relies entirely on mock data.

## 8. QA Handoff

Upon completion of the entire project, QA should validate the following:

- **Unit tests:** Ensure all domain logic, controllers, and repository mocks function as expected.
- **Widget tests:** Cover rendering and interaction for all new screens, widgets, game types, and exercise types.
- **Course Player tests:**
    - Verify correct rendering of all new `LessonContentBlockType`s in Materi stage.
    - Validate functionality of all 5 `GameType`s (Code Ordering, Token Completion, Multiple Choice, Identify Error, Output Prediction), including feedback, hints, and retry.
    - Verify `codeWriting` exercise in Latihan stage, including input, submission, feedback, and hints.
    - Confirm existing stage navigation (Materi → Game → Latihan) and lesson progression are preserved.
    - Ensure AI Tutor context is correct across stages.
- **Course Authoring tests:**
    - **CourseListPage:** Correctly displays courses, handles empty state, navigates to create/edit.
    - **CourseCreatePage:** All form fields functional, validates input, creates draft.
    - **CourseEditorPage:** Displays course details, allows editing, manages lesson list (add/reorder/delete), handles Preview, Save, Publish/Unpublish actions.
    - **LessonEditorPage:** Tab switching, lesson meta editing.
    - **Material editor:** Add/remove/reorder blocks, type selection, content editing for all `MaterialBlockType`s.
    - **Game editor:** Game type selection, type-specific form fields, saves game configurations.
    - **Exercise editor:** Fields for instruction, starter code, expected answer, hints, saves exercise configurations.
    - **Preview flow:** Mentor preview accurately reflects the authored content in the student Course Player UI.
    - **Draft/publish validation:** Correctly identifies and displays missing required fields before publishing.
- **Form validation:** All input forms throughout authoring should correctly validate user input.
- **Responsive widths:** All new screens and widgets must be usable and visually consistent across compact (320px), medium (600px), and expanded (1024px) breakpoints.
- **Accessibility:** All interactive elements must have semantic labels, touch targets >= 48x48px, and support text scaling without overflow.
- **Navigation:** All new routes must function correctly, back buttons, and deep links (if any) to edited content.
- **Dark/light theme:** All new UI components and screens must render correctly in both light and dark modes without visual regressions.
- **Android/iOS behavior:** Ensure consistent and correct behavior across both target mobile platforms.
- **Final required commands (Quality Gates):**
    - `dart format .` (should produce no changes)
    - `flutter analyze` (should report 0 issues)
    - `flutter test` (all tests must pass)

## 9. Design / UX Requirements

### Student

- **Materi:** Read as a cohesive learning document, not a single long card. Clear typography hierarchy (heading, subheading, paragraph). Visual differentiation for tip, warning, example, summary blocks.
- **Game:** Interactive learning experience inspired by Duolingo. Clear question, instructions. Visual feedback (correct/incorrect states). Hints and explanatory feedback.
- **Latihan:** Code writing focus. Editor-like input for user-written code. Submission and evaluation with system feedback, hints, and explanations.
- **AI Tutor:** Available from Course Player, context-aware of course, lesson, stage, and content. Provides explanations and hints without directly giving answers.
- **Existing learning navigation:** Floating control bar for stage/lesson navigation. Fixed, safe-area aware, non-overlapping.

### Mentor

- **Kelola Course:** "Mentor" section in Profile. "Kelola Course" row leads to course list.
- **Course List:** Displays owned courses with status (Draft/Published), last updated. "Buat Course" CTA.
- **Create Course:** Comprehensive form for course metadata (name, description, category, language, level, objectives).
- **Course Editor:** Overview of course details. Editable objectives. Lesson management (add, edit, delete, reorder lessons). Preview, Save, Publish/Unpublish actions.
- **Lesson Editor:** Tabbed interface for Materi, Game, Latihan content.
    - **Material editor:** Block-based editing interface for all `LessonContentBlockType`s.
    - **Game editor:** Select game type, configure type-specific questions, tokens, answers, hints, feedback.
    - **Exercise editor:** Configure title, instruction, starter code, expected answer, hints, feedback for coding exercises.
- **Preview:** Mentor can view the authored content as a student would see it, using the actual student Course Player UI.
- **Publish validation:** Clear visual cues and messages for incomplete required fields.

Preserve the existing project design language. New UI must follow `docs/design/brandidentity.md`, `docs/design/design-system.md`, and `docs/design/ui-patterns.md`.

## 10. Tomorrow's Resume Instructions

WHEN CONTINUING TOMORROW:

1. Read this handoff document first.
2. Inspect the actual repository.
3. Inspect the original implementation plan (`docs/superpowers/plans/2026-08-16-course-learning-authoring.md`).
4. Inspect the current Task 5 changes in `frontend/lib/features/lesson/presentation/widgets/lesson_content_block_view.dart` and `frontend/lib/features/lesson/data/mock_lesson_content.dart`.
5. Verify whether Task 5 is actually complete (all renderers fully styled as per spec).
6. If Task 5 is incomplete, finish Task 5 first.
7. Run focused tests (e.g., widget tests for `LessonContentBlockView` to ensure new renderers are correct).
8. Only then start Task 6.
9. Continue sequentially through Task 16.
10. Do not redo completed Tasks 1–4 unless an actual bug is discovered.
11. Do not assume the previous AI's implementation is correct; verify against the repository and the original plan.
12. Preserve existing project conventions.

## 11. Known Issues / Risks

- **Compile/Test State:** Current code compiles and all tests pass.
- **Task 5 Completion:** Task 5 (Implement New Content Block Renderers) is **partially completed**. The renderers are present in code, but their styling and full design system adherence might require further refinement. This should be the very first action tomorrow.
- **Analyzer warning:** One minor analyzer warning exists (`curly_braces_in_flow_control_structures` in `mock_lesson_exercises.dart`). This is a style warning and does not affect functionality.

## 12. File Change Map

| Task | File | Status | Purpose |
|------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|------------------------------------------------------------------------------------|
| 1    | `frontend/lib/features/lesson/domain/entities/lesson_content.dart`                                                                                                                 | Completed| Extend `LessonContentBlockType` enum.                                             |
| 1    | `frontend/lib/features/lesson/data/mock_lesson_content.dart`                                                                                                                       | Completed| Update `MockLessonContent.forLesson` to use new block types.                     |
| 2    | `frontend/lib/features/lesson/domain/entities/lesson_exercise.dart`                                                                                                                | Completed| Add `codeWriting` to `LessonExerciseType`, define `GameType` enum, add fields to `LessonExercise`. |
| 2    | `frontend/lib/features/lesson/data/mock_lesson_exercises.dart`                                                                                                                     | Completed| Update mock exercises to include `codeWriting` and use new game properties.      |
| 2    | `frontend/lib/features/lesson/presentation/widgets/exercises/lesson_exercise_view.dart`                                                                                            | Completed| Add placeholder for `codeWriting` in the exhaustive switch.                      |
| 3+4  | `frontend/lib/shared/enums/enums.dart`                                                                                                                                             | Completed| Centralize `LessonContentBlockType`, `LessonExerciseType`, `GameType` enums.     |
| 3+4  | `frontend/lib/features/course_authoring/domain/entities/draft_status.dart`                                                                                                         | Completed| Define `DraftStatus` enum.                                                       |
| 3+4  | `frontend/lib/features/course_authoring/domain/entities/course_authoring_draft.dart`                                                                                               | Completed| Define `CourseAuthoringDraft` entity.                                            |
| 3+4  | `frontend/lib/features/course_authoring/domain/entities/lesson_draft.dart`                                                                                                         | Completed| Define `LessonDraft` entity.                                                     |
| 3+4  | `frontend/lib/features/course_authoring/domain/entities/material_block_draft.dart`                                                                                                 | Completed| Define `MaterialBlockDraft` entity.                                              |
| 3+4  | `frontend/lib/features/course_authoring/domain/entities/game_draft.dart`                                                                                                           | Completed| Define `GameDraft` entity.                                                       |
| 3+4  | `frontend/lib/features/course_authoring/domain/entities/game_choice_draft.dart`                                                                                                    | Completed| Define `GameChoiceDraft` entity.                                                 |
| 3+4  | `frontend/lib/features/course_authoring/domain/entities/blank_draft.dart`                                                                                                          | Completed| Define `BlankDraft` entity.                                                      |
| 3+4  | `frontend/lib/features/course_authoring/domain/entities/exercise_draft.dart`                                                                                                       | Completed| Define `ExerciseDraft` entity.                                                   |
| 3+4  | `frontend/lib/features/course_authoring/domain/repositories/course_authoring_repository.dart`                                                                                      | Completed| Define `CourseAuthoringRepository` interface.                                    |
| 3+4  | `frontend/lib/features/course_authoring/data/mock_course_authoring_repository.dart`                                                                                                | Completed| Implement `MockCourseAuthoringRepository`.                                       |
| 3+4  | `frontend/lib/features/course_authoring/course_authoring.dart`                                                                                                                     | Completed| Barrel export for course authoring feature.                                      |
| 3+4  | `frontend/lib/features/lesson/domain/entities/lesson_content.dart`                                                                                                                 | Completed| Update import for shared enums.                                                  |
| 3+4  | `frontend/lib/features/lesson/domain/entities/lesson_exercise.dart`                                                                                                                | Completed| Update import for shared enums.                                                  |
| 5    | `frontend/lib/features/lesson/presentation/widgets/lesson_content_block_view.dart`                                                                                                 | In Progress| Implement renderers for new content block types.                                 |
| 5    | `frontend/lib/features/lesson/data/mock_lesson_content.dart`                                                                                                                       | In Progress| Update mock content to include new types for Materi stage.                       |
| 6    | `frontend/lib/features/lesson/presentation/widgets/exercises/code_writing_exercise.dart`                                                                                           | Pending  | Implement the code writing exercise widget.                                      |
| 6    | `frontend/lib/features/lesson/presentation/widgets/exercises/lesson_exercise_view.dart`                                                                                            | Pending  | Integrate `code_writing_exercise.dart`.                                          |
| 6    | `frontend/lib/features/lesson/lesson.dart`                                                                                                                                         | Pending  | Export `code_writing_exercise.dart`.                                             |
| 7    | `frontend/lib/features/lesson/presentation/widgets/games/game_view.dart`                                                                                                           | Pending  | Create game view dispatcher.                                                     |
| 7    | `frontend/lib/features/lesson/presentation/widgets/games/token_completion_game.dart`                                                                                               | Pending  | Wrap `CodeCompletionExercise` as a game.                                         |
| 7    | `frontend/lib/features/lesson/presentation/stages/game_stage.dart`                                                                                                                 | Pending  | Render `GameView`.                                                               |
| 7    | `frontend/lib/features/lesson/lesson.dart`                                                                                                                                         | Pending  | Export new game widgets.                                                         |
| 8    | `frontend/lib/features/lesson/presentation/widgets/games/code_ordering_game.dart`                                                                                                  | Pending  | Implement Code Ordering Game UI.                                                 |
| 8    | `frontend/lib/features/lesson/presentation/widgets/games/game_view.dart`                                                                                                           | Pending  | Integrate Code Ordering Game.                                                    |
| 9    | `frontend/lib/features/profile/logic/profile_controller.dart`                                                                                                                      | Pending  | Add `isMentor` flag.                                                             |
| 9    | `frontend/lib/features/profile/presentation/pages/profile_page.dart`                                                                                                               | Pending  | Add "Mentor" section and "Kelola Course" row.                                    |
| 9    | `frontend/lib/routing/route_names.dart`                                                                                                                                            | Pending  | Add `/mentor/courses` route name.                                                |
| 9    | `frontend/lib/app/app.dart`                                                                                                                                                        | Pending  | Add `/mentor/courses` route resolution.                                          |
| 10   | `frontend/lib/features/course_authoring/presentation/pages/course_list_page.dart`                                                                                                  | Pending  | Create Course List Page.                                                         |
| 10   | `frontend/lib/app/app.dart`                                                                                                                                                        | Pending  | Add route for Course List Page.                                                  |
| 11   | `frontend/lib/features/course_authoring/presentation/pages/course_create_page.dart`                                                                                                | Pending  | Create Course Create Page.                                                       |
| 11   | `frontend/lib/routing/route_names.dart`                                                                                                                                            | Pending  | Add `/mentor/courses/create` route name.                                         |
| 11   | `frontend/lib/app/app.dart`                                                                                                                                                        | Pending  | Add route for Course Create Page.                                                |
| 12   | `frontend/lib/features/course_authoring/presentation/pages/course_editor_page.dart`                                                                                                | Pending  | Create Course Editor Page.                                                       |
| 12   | `frontend/lib/routing/route_names.dart`                                                                                                                                            | Pending  | Add `/mentor/courses/{courseId}` route name.                                     |
| 12   | `frontend/lib/app/app.dart`                                                                                                                                                        | Pending  | Add route for Course Editor Page.                                                |
| 13   | `frontend/lib/features/course_authoring/presentation/pages/lesson_editor_page.dart`                                                                                                | Pending  | Create Lesson Editor Page.                                                       |
| 13   | `frontend/lib/features/course_authoring/presentation/widgets/material_block_editor.dart`                                                                                           | Pending  | Create Material Block Editor widget.                                             |
| 13   | `frontend/lib/routing/route_names.dart`                                                                                                                                            | Pending  | Add `/mentor/courses/{courseId}/lessons/{lessonId}` route name.                  |
| 13   | `frontend/lib/app/app.dart`                                                                                                                                                        | Pending  | Add route for Lesson Editor Page.                                                |
| 14   | `frontend/lib/features/course_authoring/presentation/widgets/game_editor.dart`                                                                                                     | Pending  | Create Game Editor widget.                                                       |
| 14   | `frontend/lib/features/course_authoring/presentation/widgets/exercise_editor.dart`                                                                                                 | Pending  | Create Exercise Editor widget.                                                   |
| 14   | `frontend/lib/features/course_authoring/presentation/pages/lesson_editor_page.dart`                                                                                                | Pending  | Integrate Game and Exercise Editor tabs.                                         |
| 15   | `frontend/lib/features/course_authoring/logic/authoring_preview_adapter.dart`                                                                                                      | Pending  | Create Authoring Preview Adapter.                                                |
| 15   | `frontend/lib/features/course_authoring/presentation/widgets/publish_validation_panel.dart`                                                                                        | Pending  | Create Publish Validation Panel.                                                 |
| 15   | `frontend/lib/features/course_authoring/presentation/pages/course_editor_page.dart`                                                                                                | Pending  | Integrate Preview and Publish.                                                   |
| 15   | `frontend/lib/routing/route_names.dart`                                                                                                                                            | Pending  | Add `/mentor/courses/{courseId}/preview` route name.                             |
| 15   | `frontend/lib/app/app.dart`                                                                                                                                                        | Pending  | Add route for Preview.                                                           |
| 16   | All touched files                                                                                                                                                                  | Pending  | Run code formatter, analyzer, and tests.                                         |

## 13. Resume Checklist

- [ ] Verify Task 5
- [ ] Complete Task 5 if necessary
- [ ] Run focused tests
- [ ] Implement Task 6
- [ ] Implement Task 7
- [ ] Implement Task 8
- [ ] Implement Task 9
- [ ] Implement Task 10
- [ ] Implement Task 11
- [ ] Implement Task 12
- [ ] Implement Task 13
- [ ] Implement Task 14
- [ ] Implement Task 15
- [ ] Task 16 quality gate
- [ ] Final review
