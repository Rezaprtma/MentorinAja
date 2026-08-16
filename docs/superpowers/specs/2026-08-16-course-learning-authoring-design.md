# Course Learning Experience & Course Authoring — Design Spec

- **Status:** Approved
- **Date:** 2026-08-16
- **Scope:** Flutter frontend only; no backend changes

---

## 1. Overview

Two connected subsystems sharing a domain model:

1. **Course Player Revision** — enrich the existing Materi → Game → Latihan flow with block-based learning documents, interactive game types, and code writing exercises
2. **Mentor Course Authoring** — new feature: mentors create and manage courses through a structured authoring flow accessible from Profile

Implementation is phased:

- Phase 1: Shared domain model & repository layer
- Phase 2: Course Player revision
- Phase 3: Mentor Course Authoring

---

## 2. Shared Domain Model

### 2.1 Content Block Types

Extend `LessonContentBlockType` with new variants:

| Type | Purpose |
|---|---|
| `heading` | Large section heading |
| `subheading` | Medium sub-section heading |
| `paragraph` | Prose explanation (existing) |
| `code` | Monospaced code block (existing) |
| `bulletList` | Unordered list (existing) |
| `numberedList` | Ordered numbered list |
| `tip` | Indigo callout (existing) |
| `warning` | Red/warning callout |
| `example` | Bordered example card with label |
| `summary` | Recap section in indigo container |
| `checklist` | Visual checklist items |
| `exercise` | Interactive exercise (existing) |

### 2.2 Game Types

| Type | Interaction |
|---|---|
| `codeOrdering` | Arrange code lines/tokens in correct order via tap-to-place |
| `tokenCompletion` | Fill blanks with correct tokens (existing codeCompletion reframed) |
| `multipleChoice` | Pick correct answer from choices |
| `identifyError` | Find bug in code (existing codeCorrection reframed) |
| `outputPrediction` | Predict code output from choices |

### 2.3 Authoring Entities

```
CourseAuthoringDraft
├── id: String
├── title: String
├── description: String
├── category: String
├── language: String (programming language)
├── level: String
├── estimatedMinutes: int?
├── thumbnailPath: String?
├── objectives: List<String>
├── targetAudience: String
├── status: DraftStatus (draft | published)
├── updatedAt: DateTime
├── lessons: List<LessonDraft>

LessonDraft
├── id: String
├── title: String
├── description: String
├── objective: String
├── estimatedMinutes: int
├── order: int
├── material: LessonMaterialDraft
├── games: List<GameDraft>
├── exercises: List<ExerciseDraft>

LessonMaterialDraft
├── blocks: List<MaterialBlockDraft>

MaterialBlockDraft
├── id: String
├── type: MaterialBlockType (maps to LessonContentBlockType for rendering)
├── text: String?
├── label: String?
├── items: List<String>
├── order: int

GameDraft
├── id: String
├── type: GameType
├── question: String
├── instruction: String
├── difficulty: String (mudah | sedang | sulit)
├── tokens: List<String> (for codeOrdering, tokenCompletion)
├── correctOrder: List<int>? (for codeOrdering)
├── code: String? (for identifyError, outputPrediction)
├── correctedCode: String? (for identifyError)
├── choices: List<GameChoiceDraft> (for multipleChoice, identifyError, outputPrediction)
├── blanks: List<BlankDraft> (for tokenCompletion)
├── options: List<String> (distractor pool)
├── hint: String?
├── explanation: String?
├── feedback: String?
├── points: int?

GameChoiceDraft
├── label: String
├── isCorrect: bool

BlankDraft
├── token: String
├── accept: List<String>

ExerciseDraft
├── id: String
├── title: String
├── instruction: String
├── starterCode: String
├── expectedConcept: String?
├── expectedAnswer: String
├── hints: List<String>
├── feedback: String?
├── difficulty: String (mudah | sedang | sulit)
```

### 2.4 Repositories

```dart
abstract class CourseAuthoringRepository {
  List<CourseAuthoringDraft> allDrafts();
  CourseAuthoringDraft? findDraft(String id);
  CourseAuthoringDraft createDraft(CourseAuthoringDraft draft);
  CourseAuthoringDraft updateDraft(CourseAuthoringDraft draft);
  void deleteDraft(String id);

  LessonDraft addLesson(String courseId, LessonDraft lesson);
  LessonDraft updateLesson(String courseId, LessonDraft lesson);
  void deleteLesson(String courseId, String lessonId);
  void reorderLessons(String courseId, List<String> lessonIds);

  void publishCourse(String courseId);
  void unpublishCourse(String courseId);
}
```

`MockCourseAuthoringRepository` provides in-memory storage with sample data.

Existing `CourseRepository` unchanged for student reading.

---

## 3. Course Player Revision

### 3.1 Materi Stage

Current: paragraph, bulletList, code, tip, exercise blocks.

Revised: adds heading, subheading, numberedList, warning, example, summary, checklist.

New renderers in `LessonContentBlockView`:

- `_HeadingView` — `AppTypeScale.titleLarge`, bold, primary color
- `_SubheadingView` — `AppTypeScale.titleMedium`, semibold
- `_NumberedListView` — like `_BulletListView` but with numbers
- `_WarningView` — warning container (amber), warning icon, like tip but different color
- `_ExampleView` — bordered card with "CONTOH" label
- `_SummaryView` — indigo container with "RANGKUMAN" label
- `_ChecklistView` — visual checkboxes (display only, not interactive)

Mock content updated to produce richer documents demonstrating these block types.

Visual hierarchy: sections use `AppSpacing.xl` separation. Typography hierarchy clear across heading → subheading → paragraph.

### 3.2 Game Stage

Current: single exercise in self-evaluate mode with challenge strip.

Revised: new `GameView` widget that dispatches by `GameType`:

**Code Ordering Game:**
- Shows shuffled code tokens/lines as tappable chips
- User taps chips in order; they stack in an answer area
- Can undo last placement or reset
- Correct: success feedback with explanation
- Incorrect: hint, try again

**Token Completion Game:**
- Reframes existing `CodeCompletionExercise` with game feedback
- Wraps in game challenge frame

**Multiple Choice Game:**
- Shows question, optional code block, 4 choices
- Tap to select, instant feedback
- Correct: explanation. Wrong: hint + retry

**Identify Error Game:**
- Reframes existing `CodeCorrectionExercise` with game feedback
- Shows buggy code, choices for fix

**Output Prediction Game:**
- Shows code block
- 4 choices of predicted output
- Tap to select, instant feedback

All games share:
- `GameFeedbackPanel` — correct/incorrect with explanation text
- Hint button (progressive)
- Retry mechanism
- Challenge strip with game type label

Game data comes from `MockLessonExercises` (extended) or authoring repository.

### 3.3 Latihan Stage

Current: correction and explanation exercises with submit button.

Revised: adds `codeWriting` exercise type.

**Code Writing Exercise:**
- Instruction text
- Starter code template (multiline `TextField`, `JetBrains Mono`)
- Submit button evaluates against expected answer
- Feedback: correct/incorrect with explanation
- Progressive hints
- Retry

New `CodeWritingExercise` widget added to exercise dispatch.

New `LessonExerciseType.codeWriting` variant with fields: `starterCode`, `expectedAnswer`.

### 3.4 AI Tutor Context

`TutorLessonContext` already carries courseId, courseTitle, lessonId, lessonTitle, stageTitle. No changes needed — the existing context passing works.

---

## 4. Mentor Course Authoring

### 4.1 Profile Integration

Add new section in `ProfilePage` between identity block and "Preferensi":

```
MENTOR
├── Kelola Course → /mentor/courses
```

Guarded by `ProfileController.isMentor` (default `true`, mock).

### 4.2 Route Structure

New routes added to `AppRoutes`:

```
/mentor/courses                           → CourseListPage
/mentor/courses/create                    → CourseCreatePage
/mentor/courses/{courseId}                 → CourseEditorPage
/mentor/courses/{courseId}/lessons/{lessonId} → LessonEditorPage
/mentor/courses/{courseId}/preview         → CoursePlayerPage (preview mode)
```

### 4.3 CourseListPage

- Page header: "Course Saya"
- Primary CTA: "Buat Course" (text, no icon)
- Cards: title, lesson count, status chip (Draft/Dipublikasikan), last updated
- Card actions: Edit, Preview, Publish/Unpublish, Delete
- Empty state: "Belum ada course" + "Mulai buat course pertama kamu." + CTA

### 4.4 CourseCreatePage

Form fields:
- Nama Course (required)
- Deskripsi (required, multiline)
- Kategori (dropdown: Pemrograman, Web, Mobile, Database, etc.)
- Bahasa Pemrograman (dropdown: Python, JavaScript, Dart, etc.)
- Level (dropdown: Pemula, Menengah, Lanjutan)
- Estimasi Durasi
- Tujuan Pembelajaran (add/remove list)
- Target Peserta (text)

CTA: "Buat Course" → creates draft, navigates to CourseEditorPage.

### 4.5 CourseEditorPage

Structure:
1. Course identity header (editable title, description)
2. Objectives section (add/remove/reorder)
3. "Materi Course" section
4. Ordered lesson list with completion indicators (Materi ✓, Game ✓, Latihan ○)
5. "Tambah Pelajaran" CTA
6. AppBar: Preview, Save, Publish/Unpublish

### 4.6 LessonEditorPage

Top: meta fields (title, description, objective, duration)

3-tab editor matching the stage indicator (MATERI | GAME | LATIHAN):

**Material Editor Tab:**
- Ordered list of block entries
- Each block: type dropdown + text/code/items input based on type
- Add block ("Tambah Blok"), delete block, reorder blocks
- Block types: heading, subheading, paragraph, code, bulletList, numberedList, tip, warning, example, summary

**Game Editor Tab:**
- Game type dropdown (5 types)
- Type-specific form:
  - Code Ordering: question, instruction, tokens (add/remove), correct order
  - Token Completion: code with blanks, token pool, correct answers
  - Multiple Choice: question, code, choices (add/remove, mark correct)
  - Identify Error: buggy code, corrected code, choices
  - Output Prediction: code, output choices
- Common: hint, explanation, difficulty dropdown
- Add game for multiple games per lesson

**Exercise Editor Tab:**
- Title, instruction (multiline), starter code (multiline, mono), expected answer, hints (add/remove), feedback, difficulty
- Add exercise for multiple exercises per lesson

### 4.7 Preview

Opens `CoursePlayerPage` with draft data converted to student format via an adapter:
- `CourseAuthoringDraft` → `CourseDetail`
- `LessonDraft` → `CourseLesson`
- `MaterialBlockDraft` → `LessonContentBlock`
- `GameDraft` → `LessonExercise` (game type)
- `ExerciseDraft` → `LessonExercise` (exercise type)

No duplicate UI — actual student player renders preview.

### 4.8 Draft & Publish

States: `DraftStatus.draft`, `DraftStatus.published`

Publish validation:
- Course title not empty
- Description not empty
- At least 1 lesson
- Each lesson: ≥1 material block, ≥1 game with answer, ≥1 exercise with expected answer
- Objectives not empty

Validation panel shows per-item status with clear labels (not just color).

### 4.9 File Structure

```
features/course_authoring/
├── course_authoring.dart
├── domain/
│   ├── entities/
│   │   ├── course_authoring_draft.dart
│   │   ├── draft_status.dart
│   │   ├── lesson_draft.dart
│   │   ├── lesson_material_draft.dart
│   │   ├── material_block_draft.dart
│   │   ├── game_draft.dart
│   │   ├── game_type.dart
│   │   ├── exercise_draft.dart
│   │   └── authoring_validation.dart
│   └── repositories/
│       └── course_authoring_repository.dart
├── data/
│   └── mock_course_authoring_repository.dart
├── application/
│   └── course_authoring_controller.dart
└── presentation/
    ├── pages/
    │   ├── course_list_page.dart
    │   ├── course_create_page.dart
    │   ├── course_editor_page.dart
    │   └── lesson_editor_page.dart
    └── widgets/
        ├── course_draft_card.dart
        ├── lesson_draft_tile.dart
        ├── material_block_editor.dart
        ├── game_editor.dart
        ├── exercise_editor.dart
        ├── publish_validation_panel.dart
        └── authoring_stage_tabs.dart
```

---

## 5. Backend Handoff

Data requiring persistence:

| Entity | Notes |
|---|---|
| CourseAuthoringDraft | Full course metadata + status |
| LessonDraft | Ordered lessons within course |
| MaterialBlockDraft | Ordered blocks within lesson material |
| GameDraft | Games per lesson with answers |
| ExerciseDraft | Exercises per lesson with answers |
| DraftStatus | Course publish state |

API endpoints: TBD  
Backend contract: TBD  
Frontend models documented above serve as the expected API shape.

---

## 6. Testing Strategy

### Unit Tests
- Domain entity creation and validation
- `CourseAuthoringController` CRUD operations
- Publish validation logic
- Draft → student model conversion
- Game type serialization

### Widget Tests
- Each new content block renderer
- Each game type widget (correct/incorrect/hint states)
- Code writing exercise
- CourseListPage (empty, with courses)
- CourseCreatePage form validation
- CourseEditorPage lesson management
- LessonEditorPage tab switching
- Material block editor (add/remove/reorder)
- Game editor type switching
- Publish validation panel
- Profile → Kelola Course navigation
- Stage indicator with all 3 stages

### Responsive
- All screens tested at 320, 360, 390, 430, 1024 widths

### Accessibility
- Semantic labels on all interactive elements
- Focus order matches visual order
- Touch targets ≥ 48px

---

## 7. Design System Compliance

- All colors from `AppColors` tokens, no raw hex
- Typography from `AppTypeScale`
- Spacing from `AppSpacing`
- Radius from `AppRadius`
- Cards: flat with subtle borders
- One primary CTA per screen (orange)
- No gradients, no emoji
- CTA buttons: text only, no icons
- Copy in Bahasa Indonesia
- Light + dark mode support
- Responsive at all breakpoints

---

## 8. Constraints

- No new dependencies beyond `flutter_svg`
- No backend/API implementation
- No authentication/role system (mock `isMentor`)
- No image picker
- No drag-and-drop (tap-to-place for code ordering)
- No rich text editor
- Existing Materi/Game/Latihan stage system preserved
- Existing Course Player navigation behavior preserved
