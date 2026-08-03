# Nerove Tutor — SCHEMA.md

**Document type:** Production database implementation specification
**Platform:** Supabase (PostgreSQL 15+, Auth, Storage, Realtime) · Python FastAPI backend · Flutter client
**Companion documents:** PRD.md (product/architecture), ERD.md (logical design)
**Status:** v1.0 — single source of truth for database implementation
**Scope note:** This document is prose + structured tables only. No SQL/DDL appears anywhere in this document by design; it is the contract engineers translate into migrations.

---

## Table of Contents

1. Schema Overview
2. Naming Standards
3. Table Specifications
4. Constraints
5. Relationships
6. Index Strategy
7. RLS Strategy
8. Storage Design
9. Realtime Strategy
10. Backup Strategy
11. Migration Strategy
12. Scalability Notes
13. Engineering Notes

---

## 1. Schema Overview

Nerove Tutor's database is organized around three workloads that pull design in different directions, and every table below is tagged with the workload it belongs to:

- **[CONTENT]** — low-write, high-read, versioned course material (courses → chapters → lessons → lesson contents/resources → quizzes → quiz questions → quiz answers, badges, feature/plan catalogs). Authored rarely, read constantly.
- **[STATE]** — per-user learning state (progress, quiz attempts, bookmarks, notes, study statistics, goals, streaks, achievements, ai memory, settings, notifications, subscriptions). Moderate write frequency, always scoped to a single `user_id`, always read on the dominant "everything about student X" pattern.
- **[TELEMETRY]** — high-volume, append-mostly, time-ordered session/event data (learning sessions, conversation threads/messages, voice sessions/transcripts, camera sessions, sleep detection events, activity/admin logs). Fastest-growing data, primary candidate for partitioning and archival.

The schema is built for **one course today, unlimited courses tomorrow**: every content row is scoped under `course_id` directly or transitively, and no table encodes "Python" as a special case. Identity is rooted entirely in Supabase-managed `auth.users`; every application table either extends it 1:1 or references it via a `user_id` foreign key — no table duplicates identity concerns.

Five design rules apply to every table in this document without exception, and are not repeated per-table below:

1. **UUID primary keys everywhere** (generated via `gen_random_uuid()` at the database default level), for Supabase Auth interoperability and to avoid sequential-ID enumeration in a multi-tenant-by-user system.
2. **`created_at` and `updated_at` on every table**, `TIMESTAMPTZ`, defaulting to `now()`, with `updated_at` maintained by a shared `set_updated_at` trigger — non-negotiable baseline for debugging, sync, and auditing.
3. **`deleted_at` (soft delete) only where another table's foreign key might reference the row historically** (content tables, catalogs). Purely disposable, leaf, user-owned rows (notes, bookmarks) are hard-deleted; there is no dead `deleted_at` column sitting unused on those tables.
4. **`user_id` is denormalized onto every user-owned row**, even where technically derivable through a join, because Row-Level Security needs a direct, indexed column to filter on — this is called out once here rather than re-justified per table.
5. **Every foreign key has an explicit, deliberate `ON DELETE`/`ON UPDATE` rule** — never left at the database default. The full rationale table is in §5; per-table specs state the rule without re-deriving it.

---

## 2. Naming Standards

| Element | Convention | Example |
|---|---|---|
| Tables | `snake_case`, plural nouns | `lessons`, `quiz_attempts` |
| Primary keys | `id` (UUID) by default | `courses.id` |
| PK-as-FK (1:1 extension tables) | `id` when the row *is* the identity (`profiles.id`); `user_id` when the row *belongs to* a user (`settings.user_id`, `learning_streaks.user_id`) | see §3.2, §3.29 |
| Foreign keys | `<referenced_singular>_id` | `lesson_id`, `course_id`, `quiz_id` |
| Self-referencing FK | named for clarity, not brevity | `prerequisite_lesson_id` |
| Timestamps | `created_at`, `updated_at` always present; domain timestamps use a verb, never a second generic `_at` | `started_at`, `ended_at`, `earned_at`, `attempted_at`, `sent_at`, `read_at` |
| Soft delete | `deleted_at` (nullable `TIMESTAMPTZ`), paired with `is_published`/`is_active` where a distinct "visible but not gone" state exists | `courses.is_published`, `courses.deleted_at` |
| Booleans | `is_<adjective>` | `is_published`, `is_active`, `is_correct` |
| JSON columns | plain descriptive name, no type suffix | `preferences`, `payload`, `criteria` |
| Enums | Postgres native `ENUM` types, `lower_snake_case` values, type name suffixed `_type`/`_status` | `progress_status`, `content_block_type` |
| Indexes | `idx_<table>_<columns>` | `idx_progress_user_id` |
| Unique constraints | `uq_<table>_<columns>` | `uq_progress_user_id_lesson_id` |
| Check constraints | `chk_<table>_<rule>` | `chk_quiz_attempts_score_range` |
| Foreign key constraints | `fk_<table>_<referenced_table>` | `fk_progress_lessons` |

---

## 3. Table Specifications

Each table lists: Purpose, Columns (name / type / nullable / default), Primary Key, Foreign Keys, Unique Constraints, Indexes, Check Constraints, Enum Usage, Relationships, Timestamps/Soft Delete, Audit & Ownership, Security Notes, Future Expansion.

### 3.1 `auth.users` *(Supabase-managed, referenced only)* — [STATE root]
- **Purpose:** Root identity record owned entirely by Supabase Auth (email, hashed credentials, MFA state, provider metadata). Application code never writes to this table directly and never adds columns to it.
- **Columns:** Managed internally by Supabase; application schema treats `id` (UUID) as the only relevant field.
- **Primary Key:** `id` (UUID)
- **Foreign Keys:** none.
- **Unique Constraints:** email uniqueness enforced internally by Supabase Auth.
- **Indexes:** managed by Supabase.
- **Relationships:** 1:1 with `profiles`, `settings`, `learning_streaks`, `admin_users`; 1:N with nearly every other user-owned table.
- **Timestamps / Soft Delete:** managed by Supabase Auth internally; not exposed to application migrations.
- **Ownership:** the row itself defines ownership for the entire schema.
- **Security Notes:** never referenced by foreign key from a client-writable insert path without going through Supabase Auth's signup flow; a `handle_new_user` trigger provisions the 1:1 extension rows (§9).
- **Future Expansion:** supports SSO/enterprise identity providers with zero application schema change — federation is an Auth concern.

### 3.2 `profiles` — [STATE]
- **Purpose:** Application-specific identity data — display name, avatar, experience level, stated learning goal.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | — (= `auth.users.id`) |
| `display_name` | TEXT | No | — |
| `avatar_storage_ref` | UUID | Yes | NULL |
| `experience_level` | `experience_level_type` ENUM | No | `'beginner'` |
| `learning_goal` | TEXT | Yes | NULL |
| `locale` | TEXT | No | `'en'` |
| `preferences` | JSONB | No | `'{}'` |
| `onboarded_at` | TIMESTAMPTZ | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id` (UUID)
- **Foreign Keys:** `id` → `auth.users.id` (`ON DELETE CASCADE`, `ON UPDATE CASCADE`); `avatar_storage_ref` → `media_files.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** PK itself (guarantees 1:1).
- **Indexes:** PK only — 1:1 lookup, no secondary access pattern.
- **Check Constraints:** `chk_profiles_display_name_length` (non-empty, ≤ 80 chars).
- **Enum Usage:** `experience_level_type` = `beginner`, `intermediate`, `advanced`.
- **Relationships:** 1:1 with `auth.users`; optional reference to `media_files` for avatar.
- **Timestamps / Soft Delete:** standard `created_at`/`updated_at`; no `deleted_at` — cascades with the identity.
- **Audit Fields:** `updated_at` is the sole change signal; no dedicated audit table (low-risk, self-service data).
- **Ownership:** `id = auth.uid()`.
- **Security Notes:** RLS restricts read/write to the owning user only; no public read.
- **Future Expansion:** `preferences` JSONB absorbs new personalization fields without migration.

### 3.3 `settings` — [STATE]
- **Purpose:** Privacy and interaction toggles — camera, voice, TTS voice choice, notification preferences. Every account has exactly one row, created with privacy-safe defaults (camera off) at signup.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `user_id` | UUID | No | — |
| `camera_enabled` | BOOLEAN | No | `false` |
| `voice_enabled` | BOOLEAN | No | `true` |
| `tts_voice` | TEXT | No | `'default'` |
| `notification_prefs` | JSONB | No | `'{}'` |
| `per_course_settings` | JSONB | No | `'{}'` |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `user_id` (UUID, PK-as-FK extension pattern)
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** PK itself.
- **Indexes:** PK only.
- **Check Constraints:** none beyond type-level.
- **Enum Usage:** none.
- **Relationships:** 1:1 with `auth.users`.
- **Timestamps / Soft Delete:** standard; no soft delete.
- **Ownership:** `user_id = auth.uid()`.
- **Security Notes:** `camera_enabled` defaults false — enforced at the schema default level, not only in the client, so a row created by any path is privacy-safe by construction.
- **Future Expansion:** `per_course_settings` JSONB reserved for V2 per-course customization.

### 3.4 `courses` — [CONTENT]
- **Purpose:** Top-level content entity — one row per course (Python today, more later).
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `slug` | TEXT | No | — |
| `title` | TEXT | No | — |
| `subject` | TEXT | No | — |
| `description` | TEXT | Yes | NULL |
| `content_version` | INTEGER | No | `1` |
| `is_published` | BOOLEAN | No | `false` |
| `cover_storage_ref` | UUID | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |
| `deleted_at` | TIMESTAMPTZ | Yes | NULL |

- **Primary Key:** `id`
- **Foreign Keys:** `cover_storage_ref` → `media_files.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** `uq_courses_slug` on `slug`.
- **Indexes:** `idx_courses_slug` (unique); partial index `idx_courses_published` on `id` `WHERE is_published = true AND deleted_at IS NULL`.
- **Check Constraints:** `chk_courses_content_version_positive` (`content_version >= 1`).
- **Enum Usage:** none.
- **Relationships:** 1:N to `chapters`.
- **Timestamps / Soft Delete:** soft delete via `deleted_at` + `is_published`; a course is never hard-deleted while any `progress` row references it.
- **Audit Fields:** all structural edits recorded in `admin_logs` (§3.38).
- **Ownership:** system/admin-owned, not user-owned; writable only by `service_role` or `admin_users`.
- **Security Notes:** readable by all authenticated users when `is_published = true`; write access restricted to admin role (§7.2).
- **Future Expansion:** `subject` field (distinct from `slug`/`title`) is what makes a second course purely additive — no schema change required.

### 3.5 `chapters` — [CONTENT]
- **Purpose:** Groups lessons within a course; provides ordering and structure.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `course_id` | UUID | No | — |
| `title` | TEXT | No | — |
| `description` | TEXT | Yes | NULL |
| `order_index` | INTEGER | No | — |
| `is_published` | BOOLEAN | No | `false` |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |
| `deleted_at` | TIMESTAMPTZ | Yes | NULL |

- **Primary Key:** `id`
- **Foreign Keys:** `course_id` → `courses.id` (`ON DELETE RESTRICT`, `ON UPDATE CASCADE`) — hard delete blocked; courses are unpublished, not deleted, while chapters exist.
- **Unique Constraints:** `uq_chapters_course_id_order_index` on (`course_id`, `order_index`).
- **Indexes:** `idx_chapters_course_id_order_index` composite, matching the "ordered chapters for course" read pattern.
- **Check Constraints:** `chk_chapters_order_index_non_negative`.
- **Enum Usage:** none.
- **Relationships:** N:1 to `courses`; 1:N to `lessons`.
- **Timestamps / Soft Delete:** soft delete only.
- **Audit Fields:** structural edits logged in `admin_logs`.
- **Ownership:** admin/system-owned.
- **Security Notes:** read-only for students (published only); write via `service_role`/admin policy.
- **Future Expansion:** integer `order_index` chosen over linked-list for simplicity; reordering is an infrequent admin-tool operation.

### 3.6 `lessons` — [CONTENT]
- **Purpose:** The core unit of teaching; carries the learning objective the AI Tutor teaches toward.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `chapter_id` | UUID | No | — |
| `prerequisite_lesson_id` | UUID | Yes | NULL |
| `title` | TEXT | No | — |
| `learning_objective` | TEXT | No | — |
| `language` | TEXT | No | `'python'` |
| `lesson_type` | `lesson_type` ENUM | No | `'concept'` |
| `order_index` | INTEGER | No | — |
| `estimated_minutes` | SMALLINT | Yes | NULL |
| `is_published` | BOOLEAN | No | `false` |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |
| `deleted_at` | TIMESTAMPTZ | Yes | NULL |

- **Primary Key:** `id`
- **Foreign Keys:** `chapter_id` → `chapters.id` (`ON DELETE RESTRICT`); `prerequisite_lesson_id` → `lessons.id` self-reference (`ON DELETE SET NULL`)
- **Unique Constraints:** `uq_lessons_chapter_id_order_index` on (`chapter_id`, `order_index`).
- **Indexes:** `idx_lessons_chapter_id_order_index` composite; `idx_lessons_prerequisite_lesson_id` for gating-chain lookups.
- **Check Constraints:** `chk_lessons_estimated_minutes_positive`; `chk_lessons_no_self_prerequisite` (`prerequisite_lesson_id <> id`).
- **Enum Usage:** `lesson_type` = `concept`, `code_along`, `discussion`.
- **Relationships:** N:1 to `chapters`; 1:N to `lesson_contents`, `lesson_resources`, `progress`, `bookmarks`, `notes`; 0:1 to `quizzes`.
- **Timestamps / Soft Delete:** soft delete only; hard delete restricted while any `progress` row references it.
- **Audit Fields:** logged in `admin_logs`.
- **Ownership:** admin/system-owned.
- **Security Notes:** read-only for students; grading/gating logic never trusts client-supplied lesson completion — see `progress` (§3.14).
- **Future Expansion:** `language` and `lesson_type` make non-Python, non-code lesson types representable without new tables.

### 3.7 `lesson_contents` — [CONTENT]
- **Purpose:** Ordered teaching-material blocks for a lesson (explanation, code example, analogy), matching the AI Tutor's step-by-step delivery.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `lesson_id` | UUID | No | — |
| `content_type` | `content_block_type` ENUM | No | — |
| `order_index` | INTEGER | No | — |
| `body` | TEXT | Yes | NULL |
| `code_snippet` | TEXT | Yes | NULL |
| `storage_reference_id` | UUID | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `lesson_id` → `lessons.id` (`ON DELETE CASCADE`); `storage_reference_id` → `media_files.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** `uq_lesson_contents_lesson_id_order_index` on (`lesson_id`, `order_index`).
- **Indexes:** `idx_lesson_contents_lesson_id_order_index`.
- **Check Constraints:** `chk_lesson_contents_body_or_media` (at least one of `body`, `code_snippet`, `storage_reference_id` is non-null).
- **Enum Usage:** `content_block_type` = `text`, `code`, `image`, `diagram`.
- **Relationships:** N:1 to `lessons`; optional reference to `media_files`.
- **Timestamps / Soft Delete:** no independent soft delete — cascades with `lessons`.
- **Audit Fields:** covered under lesson-level `admin_logs` entries.
- **Ownership:** admin/system-owned.
- **Security Notes:** read-only for students on published lessons.
- **Future Expansion:** `content_type` enum extensible for richer media without restructuring.

### 3.8 `lesson_resources` — [CONTENT]
- **Purpose:** Supplementary, downloadable/linkable resources attached to a lesson (slides, cheat sheets, external reading links, sample datasets) — distinct from inline `lesson_contents` blocks, which are the primary teaching sequence.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `lesson_id` | UUID | No | — |
| `title` | TEXT | No | — |
| `resource_type` | `lesson_resource_type` ENUM | No | — |
| `storage_reference_id` | UUID | Yes | NULL |
| `external_url` | TEXT | Yes | NULL |
| `order_index` | INTEGER | No | `0` |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |
| `deleted_at` | TIMESTAMPTZ | Yes | NULL |

- **Primary Key:** `id`
- **Foreign Keys:** `lesson_id` → `lessons.id` (`ON DELETE CASCADE`); `storage_reference_id` → `media_files.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** none beyond PK.
- **Indexes:** `idx_lesson_resources_lesson_id`.
- **Check Constraints:** `chk_lesson_resources_source_present` (exactly one of `storage_reference_id`, `external_url` is non-null).
- **Enum Usage:** `lesson_resource_type` = `slide_deck`, `cheat_sheet`, `external_link`, `dataset`, `attachment`.
- **Relationships:** N:1 to `lessons`; optional reference to `media_files`.
- **Timestamps / Soft Delete:** soft delete (a resource may be referenced from a bookmark/note historically).
- **Ownership:** admin/system-owned.
- **Security Notes:** read-only for students; `external_url` values are admin-authored, never user-supplied, to avoid becoming an open redirect vector.
- **Future Expansion:** `resource_type` enum extensible for new formats without new tables.

### 3.9 `quizzes` — [CONTENT]
- **Purpose:** The gating assessment definition for a lesson.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `lesson_id` | UUID | No | — |
| `title` | TEXT | No | — |
| `pass_threshold_pct` | SMALLINT | No | `80` |
| `is_published` | BOOLEAN | No | `false` |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |
| `deleted_at` | TIMESTAMPTZ | Yes | NULL |

- **Primary Key:** `id`
- **Foreign Keys:** `lesson_id` → `lessons.id` (`ON DELETE RESTRICT`)
- **Unique Constraints:** **deliberately none** on `lesson_id` — modeled loosely as 1:N at the schema level (enforced 1:1 at the application layer for V1) so chapter-level/multi-quiz-per-lesson models (roadmap) don't require a later migration.
- **Indexes:** `idx_quizzes_lesson_id`.
- **Check Constraints:** `chk_quizzes_pass_threshold_range` (`pass_threshold_pct BETWEEN 0 AND 100`).
- **Enum Usage:** none.
- **Relationships:** N:1 to `lessons` (1:1 by convention in V1); 1:N to `quiz_questions`, `quiz_attempts`.
- **Timestamps / Soft Delete:** soft delete; restricted while `quiz_attempts` reference it.
- **Ownership:** admin/system-owned.
- **Security Notes:** structure readable by students; correctness data is never exposed pre-grading (see `quiz_answers`, §3.11).
- **Future Expansion:** see Unique Constraints note above.

### 3.10 `quiz_questions` — [CONTENT]
- **Purpose:** Individual questions within a quiz, including seed data AI-generated variants are derived from.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `quiz_id` | UUID | No | — |
| `prompt` | TEXT | No | — |
| `question_type` | `question_type` ENUM | No | `'multiple_choice'` |
| `objective_tag` | TEXT | Yes | NULL |
| `order_index` | INTEGER | No | — |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `quiz_id` → `quizzes.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** `uq_quiz_questions_quiz_id_order_index` on (`quiz_id`, `order_index`).
- **Indexes:** `idx_quiz_questions_quiz_id`; `idx_quiz_questions_objective_tag` (supports mistake-log correlation).
- **Check Constraints:** none beyond type-level.
- **Enum Usage:** `question_type` = `multiple_choice`, `code_output`, `free_response`.
- **Relationships:** N:1 to `quizzes`; 1:N to `quiz_answers`.
- **Timestamps / Soft Delete:** cascades with parent quiz; no independent soft delete.
- **Ownership:** admin/system-owned.
- **Security Notes:** prompt text is readable pre-attempt; no correctness data lives on this row.
- **Future Expansion:** `objective_tag` links back to the lesson's learning objective for mistake-log correlation and future spaced-review scheduling.

### 3.11 `quiz_answers` — [CONTENT]
- **Purpose:** Answer options for a multiple-choice question — the canonical option set.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `quiz_question_id` | UUID | No | — |
| `option_text` | TEXT | No | — |
| `is_correct` | BOOLEAN | No | `false` |
| `order_index` | INTEGER | No | — |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `quiz_question_id` → `quiz_questions.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** none beyond PK.
- **Indexes:** `idx_quiz_answers_quiz_question_id`.
- **Check Constraints:** none beyond type-level; "exactly one correct option" is enforced at the application layer, not the database, since some question types may legitimately have zero stored correct options (free-response/code-output graded by the AI Tutor).
- **Enum Usage:** none.
- **Relationships:** N:1 to `quiz_questions`.
- **Timestamps / Soft Delete:** cascades with parent question.
- **Ownership:** admin/system-owned.
- **Security Notes:** **critical** — `is_correct` must never be exposed to a client `SELECT` before/during an attempt. No default RLS `SELECT *` policy is applied to this table for the `authenticated` role; reads for attempt rendering go through a view or RPC that strips `is_correct`, and grading itself happens server-side under `service_role` (§7.2).
- **Future Expansion:** free-response/code-output grading uses `quiz_attempts.raw_answer` (AI-evaluated) instead of this table, so this table doesn't need to represent every question type.

### 3.12 `learning_sessions` — [TELEMETRY]
- **Purpose:** One row per study session (app open to close/idle) — the parent record correlating voice/camera activity.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `lesson_id` | UUID | Yes | NULL |
| `device_type` | TEXT | Yes | NULL |
| `started_at` | TIMESTAMPTZ | No | `now()` |
| `ended_at` | TIMESTAMPTZ | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `lesson_id` → `lessons.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** none.
- **Indexes:** `idx_learning_sessions_user_id_started_at` composite.
- **Check Constraints:** `chk_learning_sessions_ended_after_started` (`ended_at IS NULL OR ended_at >= started_at`).
- **Enum Usage:** none (`device_type` is free text, values like `android`, `ios`, `windows`).
- **Relationships:** N:1 to `users`; N:1 to `lessons` (optional); 1:N to `voice_sessions`, `camera_sessions`.
- **Timestamps / Soft Delete:** no soft delete — genuinely disposable telemetry once rolled into `study_statistics`.
- **Ownership:** `user_id = auth.uid()`.
- **Security Notes:** standard per-user RLS; no cross-user read.
- **Future Expansion:** `device_type` already accommodates future macOS/Linux/Web platform values with zero schema change.

### 3.13 `conversation_threads` — [TELEMETRY]
- **Purpose:** One row per tutoring conversation/session grouping — parent of `conversation_messages`, and the entity carrying the compressed long-term-memory summary.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `lesson_id` | UUID | Yes | NULL |
| `summary` | TEXT | Yes | NULL |
| `started_at` | TIMESTAMPTZ | No | `now()` |
| `ended_at` | TIMESTAMPTZ | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `lesson_id` → `lessons.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** none.
- **Indexes:** `idx_conversation_threads_user_id_started_at`; `idx_conversation_threads_user_id_lesson_id` (per-lesson history retrieval).
- **Check Constraints:** none beyond type-level.
- **Enum Usage:** none.
- **Relationships:** N:1 to `users`; N:1 to `lessons` (optional); 1:N to `conversation_messages`; 0:1 to `voice_sessions`.
- **Timestamps / Soft Delete:** no soft delete.
- **Ownership:** `user_id = auth.uid()`.
- **Security Notes:** standard per-user RLS.
- **Future Expansion:** `summary` is deliberately separate storage from raw messages so future memory-pipeline changes don't touch `conversation_messages`.

### 3.14 `conversation_messages` — [TELEMETRY, highest-volume table]
- **Purpose:** Individual turns within a conversation thread — the raw transcript.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `conversation_id` | UUID | No | — |
| `role` | `message_role` ENUM | No | — |
| `content` | TEXT | No | — |
| `metadata` | JSONB | No | `'{}'` |
| `created_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `conversation_id` → `conversation_threads.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** none.
- **Indexes:** `idx_conversation_messages_conversation_id_created_at` — deliberately the *only* index besides PK, to keep write throughput high on the system's fastest-growing table.
- **Check Constraints:** `chk_conversation_messages_content_not_empty`.
- **Enum Usage:** `message_role` = `student`, `tutor`, `system`.
- **Relationships:** N:1 to `conversation_threads`.
- **Timestamps / Soft Delete:** `created_at` only — no `updated_at` (messages are immutable once written) and no soft delete; hard-deleted only as part of full account/thread deletion cascade.
- **Ownership:** derived through `conversation_threads.user_id` (no direct `user_id` column — deliberate exception to the denormalization rule, since RLS is enforced via a join to the low-cardinality parent table, and adding `user_id` here would only help write-path convenience, not read-path filtering, which is already `conversation_id`-scoped).
- **Security Notes:** RLS policy joins to `conversation_threads` to confirm `user_id = auth.uid()`.
- **Future Expansion:** designed for time-based partitioning by `created_at` (§12) from day one, not operationally activated at V1 scale.

### 3.15 `ai_memory` — [STATE]
- **Purpose:** Structured, queryable memory artifacts distinct from conversation summaries — the mistake log and per-objective mastery signals the AI Tutor reads every turn.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `lesson_id` | UUID | Yes | NULL |
| `objective_tag` | TEXT | No | — |
| `memory_type` | `ai_memory_type` ENUM | No | `'mistake'` |
| `content` | TEXT | No | — |
| `strength_score` | NUMERIC(4,3) | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `lesson_id` → `lessons.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** none — a student accumulates multiple entries per objective over time.
- **Indexes:** `idx_ai_memory_user_id_objective_tag` — the exact "what is this student weak on" access pattern.
- **Check Constraints:** `chk_ai_memory_strength_score_range` (`strength_score BETWEEN 0 AND 1`).
- **Enum Usage:** `ai_memory_type` = `mistake`, `mastery_signal`, `preference_note`.
- **Relationships:** N:1 to `users`; N:1 to `lessons` (optional).
- **Timestamps / Soft Delete:** no soft delete.
- **Ownership:** `user_id = auth.uid()` for read; writes are `service_role`-only (§7.3).
- **Security Notes:** never client-writable — only the FastAPI backend, under `service_role`, inserts/updates this table, since it directly shapes AI Tutor behavior and must not be spoofable by the client.
- **Future Expansion:** `objective_tag`-based indexing (rather than free-text lesson reference) is what makes V2 spaced-review scheduling a query, not a redesign.

### 3.16 `voice_sessions` — [TELEMETRY]
- **Purpose:** Telemetry for a single voice pipeline session — duration, latency metrics, provider used. Explicitly **not** audio content.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `learning_session_id` | UUID | Yes | NULL |
| `conversation_id` | UUID | Yes | NULL |
| `provider` | TEXT | No | — |
| `stt_latency_ms` | INTEGER | Yes | NULL |
| `tts_latency_ms` | INTEGER | Yes | NULL |
| `started_at` | TIMESTAMPTZ | No | `now()` |
| `ended_at` | TIMESTAMPTZ | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `learning_session_id` → `learning_sessions.id` (`ON DELETE SET NULL`); `conversation_id` → `conversation_threads.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** none.
- **Indexes:** `idx_voice_sessions_user_id_started_at`.
- **Check Constraints:** `chk_voice_sessions_latency_non_negative`.
- **Enum Usage:** none (`provider` free text per `ProviderGateway` abstraction).
- **Relationships:** N:1 to `users`; N:1 to `learning_sessions` (optional); N:1 to `conversation_threads` (optional); 1:N to `voice_transcripts`.
- **Timestamps / Soft Delete:** no soft delete.
- **Ownership:** `user_id = auth.uid()`.
- **Security Notes:** schema has no column capable of holding raw audio — a structural, not merely policy, guarantee of the no-audio-storage requirement.
- **Future Expansion:** `provider` field enables cost/performance analysis across STT/TTS vendor changes.

### 3.17 `voice_transcripts` — [TELEMETRY]
- **Purpose:** Finalized text segments produced by STT within a voice session — distinct from `conversation_messages`, which is the tutor-facing dialogue turn; a `voice_transcript` row is the raw recognized-speech segment (may include partials finalized, confidence, timing) that a `conversation_message` is derived from.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `voice_session_id` | UUID | No | — |
| `segment_text` | TEXT | No | — |
| `confidence` | NUMERIC(4,3) | Yes | NULL |
| `started_at_ms` | INTEGER | No | — |
| `ended_at_ms` | INTEGER | No | — |
| `created_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `voice_session_id` → `voice_sessions.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** none.
- **Indexes:** `idx_voice_transcripts_voice_session_id`.
- **Check Constraints:** `chk_voice_transcripts_confidence_range` (`confidence BETWEEN 0 AND 1`); `chk_voice_transcripts_time_order` (`ended_at_ms >= started_at_ms`).
- **Enum Usage:** none.
- **Relationships:** N:1 to `voice_sessions`.
- **Timestamps / Soft Delete:** `created_at` only, no `updated_at` (immutable), no soft delete.
- **Ownership:** derived through `voice_sessions.user_id` (same deliberate exception as `conversation_messages`, §3.14).
- **Security Notes:** text-only; no audio bytes ever stored here, consistent with §3.16.
- **Future Expansion:** structure supports future per-segment confidence-based UI (e.g., highlighting low-confidence transcript regions) without schema change.

### 3.18 `camera_sessions` — [TELEMETRY]
- **Purpose:** Telemetry for an opt-in camera monitoring session — start/end time and engagement summary, not frame data.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `learning_session_id` | UUID | Yes | NULL |
| `started_at` | TIMESTAMPTZ | No | `now()` |
| `ended_at` | TIMESTAMPTZ | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `learning_session_id` → `learning_sessions.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** none.
- **Indexes:** `idx_camera_sessions_user_id_started_at`.
- **Check Constraints:** `chk_camera_sessions_ended_after_started`.
- **Enum Usage:** none.
- **Relationships:** N:1 to `users`; N:1 to `learning_sessions` (optional); 1:N to `sleep_detection_events`.
- **Timestamps / Soft Delete:** no soft delete.
- **Ownership:** `user_id = auth.uid()`.
- **Security Notes:** schema has no column capable of holding frame/image data — structural guarantee, mirroring §3.16.
- **Future Expansion:** structure supports future engagement-score aggregation without new tables.

### 3.19 `sleep_detection_events` — [TELEMETRY]
- **Purpose:** Discrete drowsiness/attention events emitted by the on-device Camera Engine — the event record only, never raw signal data.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `camera_session_id` | UUID | No | — |
| `event_type` | `attention_event_type` ENUM | No | — |
| `occurred_at` | TIMESTAMPTZ | No | `now()` |
| `duration_ms` | INTEGER | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `camera_session_id` → `camera_sessions.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** none.
- **Indexes:** `idx_sleep_detection_events_camera_session_id`.
- **Check Constraints:** `chk_sleep_detection_events_duration_non_negative`.
- **Enum Usage:** `attention_event_type` = `drowsy`, `looking_away`, `eyes_closed`, `resumed_attention`.
- **Relationships:** N:1 to `camera_sessions`.
- **Timestamps / Soft Delete:** `created_at` only, no soft delete.
- **Ownership:** derived through `camera_sessions.user_id` — low-volume table, join accepted rather than denormalizing `user_id` (§7 normalization rationale).
- **Security Notes:** event-type-only; no image data possible by schema construction.
- **Future Expansion:** `event_type` extensible without new tables.

### 3.20 `progress` — [STATE, dominant read table]
- **Purpose:** The gating source of truth — one row per (user, lesson), tracking completion status and resume position. The single most frequently read table in the system.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `lesson_id` | UUID | No | — |
| `status` | `progress_status` ENUM | No | `'not_started'` |
| `mastery_score` | NUMERIC(5,2) | Yes | NULL |
| `resume_position` | JSONB | No | `'{}'` |
| `content_version` | INTEGER | Yes | NULL |
| `started_at` | TIMESTAMPTZ | Yes | NULL |
| `completed_at` | TIMESTAMPTZ | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `lesson_id` → `lessons.id` (`ON DELETE RESTRICT`)
- **Unique Constraints:** `uq_progress_user_id_lesson_id` on (`user_id`, `lesson_id`).
- **Indexes:** `idx_progress_user_id` (the "everything for this student" pattern); unique index also serves point lookups.
- **Check Constraints:** `chk_progress_mastery_score_range` (`mastery_score BETWEEN 0 AND 100`); `chk_progress_completed_after_started`.
- **Enum Usage:** `progress_status` = `not_started`, `in_progress`, `completed`.
- **Relationships:** N:1 to `users`; N:1 to `lessons`.
- **Timestamps / Soft Delete:** no soft delete — rows are additive/updated, never removed except via account deletion cascade.
- **Ownership:** `user_id = auth.uid()` for read. **Write path:** client may `INSERT` on first lesson access (lazy creation) but `status`/`mastery_score` mutation is restricted to `service_role` (backend-enforced gating, per PRD §21.2) — a student cannot self-report lesson completion.
- **Security Notes:** the single highest-value RLS/write-restriction target in the schema; see §7.3.
- **Future Expansion:** `mastery_score` stored numeric (not boolean) so V5 richer mastery modeling is a computation change; `content_version` reserved for future version-migration decisions (§13 Versioning below).

### 3.21 `quiz_attempts` — [STATE]
- **Purpose:** One row per quiz submission — the graded result, feeding gating (`progress`) and the AI Tutor's mistake-log input.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `quiz_id` | UUID | No | — |
| `score_pct` | NUMERIC(5,2) | No | — |
| `passed` | BOOLEAN | No | — |
| `answers` | JSONB | No | — |
| `objective_scores` | JSONB | Yes | NULL |
| `attempted_at` | TIMESTAMPTZ | No | `now()` |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `quiz_id` → `quizzes.id` (`ON DELETE RESTRICT`)
- **Unique Constraints:** none — multiple attempts per (user, quiz) are expected (retakes).
- **Indexes:** `idx_quiz_attempts_user_id_quiz_id_attempted_at` composite (latest-attempt / history queries).
- **Check Constraints:** `chk_quiz_attempts_score_range` (`score_pct BETWEEN 0 AND 100`).
- **Enum Usage:** none.
- **Relationships:** N:1 to `users`; N:1 to `quizzes`. Per-question responses stored as structured JSONB in `answers` rather than a separate join table (§7 normalization rationale — answers are never queried independently of their parent attempt, and submission is a single atomic write).
- **Timestamps / Soft Delete:** immutable historical record; no soft delete, no update after grading beyond `updated_at` bookkeeping.
- **Ownership:** `user_id = auth.uid()` for read. **Write path:** `INSERT` only via `service_role` — grading, including `passed`/`score_pct` computation, is never trusted from the client (PRD §21.2).
- **Security Notes:** correctness computation happens server-side; the client submits raw selections/free-text, never a self-declared score.
- **Future Expansion:** `objective_scores` (per-objective breakdown) reserved for V5 richer mastery modeling.

### 3.22 `bookmarks` — [STATE]
- **Purpose:** User-saved references to specific lessons for quick return access.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `lesson_id` | UUID | No | — |
| `note` | TEXT | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `lesson_id` → `lessons.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** `uq_bookmarks_user_id_lesson_id` — bookmarking twice is idempotent, not duplicated.
- **Indexes:** `idx_bookmarks_user_id_created_at`.
- **Check Constraints:** none.
- **Enum Usage:** none.
- **Relationships:** N:1 to `users`; N:1 to `lessons`.
- **Timestamps / Soft Delete:** no soft delete — genuinely disposable, hard-deleted on user request.
- **Ownership:** `user_id = auth.uid()`, full client CRUD.
- **Security Notes:** standard per-user RLS; low-risk table.
- **Future Expansion:** none anticipated — deliberately simple entity.

### 3.23 `notes` — [STATE]
- **Purpose:** Free-form student notes attached to a lesson — longer-form than `bookmarks.note`.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `lesson_id` | UUID | No | — |
| `body_markdown` | TEXT | No | — |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `lesson_id` → `lessons.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** none — a user may have multiple notes per lesson.
- **Indexes:** `idx_notes_user_id_lesson_id`.
- **Check Constraints:** `chk_notes_body_not_empty`.
- **Enum Usage:** none.
- **Relationships:** N:1 to `users`; N:1 to `lessons`.
- **Timestamps / Soft Delete:** no soft delete — hard-deleted on user request.
- **Ownership:** `user_id = auth.uid()`, full client CRUD.
- **Security Notes:** standard per-user RLS.
- **Future Expansion:** stored as Markdown text; no structural change anticipated.

### 3.24 `study_statistics` — [STATE, denormalized rollup]
- **Purpose:** Daily rollup of study activity per user — avoids expensive aggregation over raw session data at read time (dashboards, streaks).
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `date` | DATE | No | — |
| `minutes_studied` | INTEGER | No | `0` |
| `lessons_completed` | SMALLINT | No | `0` |
| `quizzes_passed` | SMALLINT | No | `0` |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** `uq_study_statistics_user_id_date` — one rollup row per user per day, upserted as sessions complete.
- **Indexes:** unique index serves the primary lookup.
- **Check Constraints:** `chk_study_statistics_non_negative` (all count/minute columns `>= 0`).
- **Enum Usage:** none.
- **Relationships:** N:1 to `users`.
- **Timestamps / Soft Delete:** no soft delete.
- **Ownership:** `user_id = auth.uid()` for read; writes via `service_role` (rollup job / backend on session end).
- **Security Notes:** standard per-user RLS for read; not client-writable directly.
- **Future Expansion:** weekly/monthly rollups can be materialized views over this table rather than new base tables (§9 Materialized Views).

### 3.25 `learning_goals` — [STATE, historized]
- **Purpose:** User-configured or system-suggested daily study target (minutes or lessons), used for streak/motivation logic. Historized (one row per goal-setting event with an effective date range), not overwritten in place, so past streak calculations remain accurate against the goal active at the time.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `course_id` | UUID | Yes | NULL |
| `goal_type` | `goal_type` ENUM | No | `'minutes_per_day'` |
| `target_value` | SMALLINT | No | — |
| `effective_from` | DATE | No | — |
| `effective_to` | DATE | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `course_id` → `courses.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** none (historized by design).
- **Indexes:** `idx_learning_goals_user_id_effective_from`.
- **Check Constraints:** `chk_learning_goals_target_positive`; `chk_learning_goals_date_order` (`effective_to IS NULL OR effective_to >= effective_from`).
- **Enum Usage:** `goal_type` = `minutes_per_day`, `lessons_per_week`.
- **Relationships:** N:1 to `users`; optional N:1 to `courses`.
- **Timestamps / Soft Delete:** no soft delete — historization via `effective_from`/`effective_to` is the retention mechanism.
- **Ownership:** `user_id = auth.uid()`, full client CRUD (new goal = new row).
- **Security Notes:** standard per-user RLS.
- **Future Expansion:** nullable `course_id` already supports future per-course goals.

### 3.26 `learning_streaks` — [STATE, 1:1 extension]
- **Purpose:** Current and best streak counters per user.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `user_id` | UUID | No | — |
| `current_streak_days` | SMALLINT | No | `0` |
| `best_streak_days` | SMALLINT | No | `0` |
| `last_active_date` | DATE | Yes | NULL |
| `timezone` | TEXT | No | `'UTC'` |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `user_id` (PK-as-FK extension pattern)
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** PK itself.
- **Indexes:** PK only.
- **Check Constraints:** `chk_learning_streaks_non_negative` (`current_streak_days >= 0 AND best_streak_days >= 0`).
- **Enum Usage:** none.
- **Relationships:** 1:1 with `users`.
- **Timestamps / Soft Delete:** no soft delete.
- **Ownership:** `user_id = auth.uid()` for read; writes via `service_role` (streak computation is a backend job, not client-trusted).
- **Security Notes:** explicit `timezone` field keeps streak-day boundaries correct across user travel/timezone changes.
- **Future Expansion:** none required beyond the existing field set.

### 3.27 `achievements` — [STATE, genuine many-to-many]
- **Purpose:** Instances of a badge/milestone earned by a specific user — the join entity between `users` and `badges`.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `badge_id` | UUID | No | — |
| `earned_at` | TIMESTAMPTZ | No | `now()` |
| `created_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `badge_id` → `badges.id` (`ON DELETE RESTRICT`)
- **Unique Constraints:** `uq_achievements_user_id_badge_id` (repeatable milestones are modeled as distinct `badges` rows, e.g. separate "10-day streak"/"30-day streak" badges, rather than allowing duplicate earn rows).
- **Indexes:** `idx_achievements_user_id_earned_at`.
- **Check Constraints:** none.
- **Enum Usage:** none.
- **Relationships:** N:1 to `users`; N:1 to `badges`.
- **Timestamps / Soft Delete:** no soft delete — an earned achievement is permanent.
- **Ownership:** `user_id = auth.uid()` for read; writes via `service_role` (event-driven badge award logic).
- **Security Notes:** standard per-user RLS for read; not client-writable.
- **Future Expansion:** decoupled, event-driven population means new badge types don't require `achievements`-table changes.

### 3.28 `badges` — [CONTENT, catalog]
- **Purpose:** Catalog of achievement definitions (name, description, icon, criteria).
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `slug` | TEXT | No | — |
| `name` | TEXT | No | — |
| `description` | TEXT | Yes | NULL |
| `icon_storage_ref` | UUID | Yes | NULL |
| `criteria` | JSONB | No | `'{}'` |
| `is_active` | BOOLEAN | No | `true` |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `icon_storage_ref` → `media_files.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** `uq_badges_slug`.
- **Indexes:** `idx_badges_slug` (unique); catalog-scale table, no further indexing needed.
- **Check Constraints:** none beyond type-level.
- **Enum Usage:** none.
- **Relationships:** 1:N to `achievements`.
- **Timestamps / Soft Delete:** soft delete via `is_active` only — never hard-deleted while `achievements` reference it.
- **Ownership:** admin/system-owned.
- **Security Notes:** publicly readable (all authenticated users); write via admin role only.
- **Future Expansion:** `criteria` JSON absorbs new badge logic without new columns.

### 3.29 `notifications` — [STATE]
- **Purpose:** Record of notifications sent/pending for a user.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `type` | TEXT | No | — |
| `payload` | JSONB | No | `'{}'` |
| `sent_at` | TIMESTAMPTZ | Yes | NULL |
| `read_at` | TIMESTAMPTZ | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** none.
- **Indexes:** `idx_notifications_user_id_sent_at`; partial index `idx_notifications_unread` on `user_id` `WHERE read_at IS NULL` (unread-count queries).
- **Check Constraints:** none beyond type-level.
- **Enum Usage:** `type` is free text (`lesson_unlocked`, `badge_earned`, `streak_reminder`, ...) — kept as text rather than enum since notification kinds are expected to grow frequently and independently of a migration cycle.
- **Relationships:** N:1 to `users`.
- **Timestamps / Soft Delete:** no soft delete; `read_at` nullable until read.
- **Ownership:** `user_id = auth.uid()` for read/update (`read_at`); `INSERT` via `service_role`.
- **Security Notes:** standard per-user RLS.
- **Future Expansion:** `type`/`payload` pattern extensible to new notification kinds without schema change.

### 3.30 `media_files` — [CONTENT/STATE hybrid, storage reference]
- **Purpose:** Metadata pointer to a Supabase Storage object (avatars, lesson media, badge icons) — the database never stores binary content, only references.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `bucket` | TEXT | No | — |
| `path` | TEXT | No | — |
| `uploaded_by` | UUID | Yes | NULL |
| `original_filename` | TEXT | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `uploaded_by` → `auth.users.id` (`ON DELETE SET NULL`) — the storage object metadata may outlive the uploader's account (e.g., course assets uploaded by since-departed staff).
- **Unique Constraints:** `uq_media_files_bucket_path` on (`bucket`, `path`).
- **Indexes:** `idx_media_files_bucket_path` (unique, doubles as lookup index).
- **Check Constraints:** none beyond type-level.
- **Enum Usage:** none (`bucket` values correspond to the Storage buckets defined in §8).
- **Relationships:** referenced optionally by `profiles.avatar_storage_ref`, `courses.cover_storage_ref`, `lesson_contents.storage_reference_id`, `lesson_resources.storage_reference_id`, `badges.icon_storage_ref`; 1:1 with `storage_metadata`.
- **Timestamps / Soft Delete:** no soft delete on this table directly; orphaned rows (no longer referenced) are garbage-collected by a scheduled backend job, not a cascade.
- **Ownership:** `uploaded_by = auth.uid()` for personal uploads (avatars); admin-owned for course/badge assets.
- **Security Notes:** this table is metadata-only; actual object access control is enforced by Supabase Storage bucket policies (§8), which must be kept consistent with this table's visibility — a documented cross-system consistency requirement, not automatic.
- **Future Expansion:** bucket-scoped design allows new content-media buckets without new tables.

### 3.31 `storage_metadata` — [CONTENT/STATE hybrid, 1:1 extension of `media_files`]
- **Purpose:** Technical file properties for a stored object (MIME type, byte size, checksum, dimensions) — split from `media_files` so ownership/reference concerns stay separate from technical file properties, which are populated asynchronously after upload completes (e.g., by a Storage webhook/Edge Function) rather than at row-creation time.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `media_file_id` | UUID | No | — |
| `mime_type` | TEXT | Yes | NULL |
| `size_bytes` | BIGINT | Yes | NULL |
| `checksum_sha256` | TEXT | Yes | NULL |
| `width_px` | INTEGER | Yes | NULL |
| `height_px` | INTEGER | Yes | NULL |
| `duration_ms` | INTEGER | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `media_file_id` (PK-as-FK extension pattern, same as `settings`/`learning_streaks`)
- **Foreign Keys:** `media_file_id` → `media_files.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** PK itself.
- **Indexes:** PK only.
- **Check Constraints:** `chk_storage_metadata_size_non_negative`; `chk_storage_metadata_dimensions_non_negative`.
- **Enum Usage:** none.
- **Relationships:** 1:1 with `media_files`.
- **Timestamps / Soft Delete:** cascades with `media_files`; no independent soft delete.
- **Ownership:** inherited from `media_files.uploaded_by`.
- **Security Notes:** populated by a trusted backend/Edge Function process only, never client-supplied, since `checksum_sha256`/`size_bytes` are used for storage quota and integrity checks that must not be spoofable.
- **Future Expansion:** additional technical fields (e.g., codec, color profile) are additive columns on this table without touching `media_files`.

### 3.32 `admin_users` — [CONTENT/system]
- **Purpose:** Role-based access record for internal staff (content authors, support), distinct from a regular student `auth.users` identity.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `user_id` | UUID | No | — |
| `role` | `admin_role` ENUM | No | `'content_editor'` |
| `granted_by` | UUID | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `user_id` (PK-as-FK)
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `granted_by` → `auth.users.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** PK itself.
- **Indexes:** PK only.
- **Check Constraints:** none beyond type-level.
- **Enum Usage:** `admin_role` = `content_editor`, `support`, `superadmin`.
- **Relationships:** 1:1 with `users` (subset of users are also admins); 1:N to `admin_logs`.
- **Timestamps / Soft Delete:** no soft delete — an admin's access is revoked by row deletion, which cascades from `auth.users` deletion only; a deliberate revocation is a manual row `DELETE`, not a soft flag, since stale "inactive admin" rows carry no product value.
- **Ownership:** system-owned; not client-visible to non-admins.
- **Security Notes:** membership in this table is the sole gate for all admin-scoped RLS policies (§7.4); `role` supports finer-grained future permissions.
- **Future Expansion:** `role` enum extensible for a growing admin surface (V3 content-authoring tool).

### 3.33 `feature_flags` — [CONTENT/system]
- **Purpose:** System-wide or cohort-scoped rollout toggles (e.g., enabling a new lesson-content block type, a new provider, a UI experiment) — independent of subscription tier, driven by engineering rollout needs rather than monetization.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `key` | TEXT | No | — |
| `description` | TEXT | Yes | NULL |
| `is_enabled` | BOOLEAN | No | `false` |
| `rollout_pct` | SMALLINT | No | `0` |
| `environment` | TEXT | No | `'production'` |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** none.
- **Unique Constraints:** `uq_feature_flags_key_environment` on (`key`, `environment`).
- **Indexes:** unique index serves the primary lookup (`key` + `environment` read on backend/client boot).
- **Check Constraints:** `chk_feature_flags_rollout_pct_range` (`rollout_pct BETWEEN 0 AND 100`).
- **Enum Usage:** none (`environment` free text: `production`, `staging`, `development`).
- **Relationships:** none — standalone system table, read by both FastAPI backend and Flutter client at boot/config-refresh time.
- **Timestamps / Soft Delete:** no soft delete — flags are deleted when retired, since a stale disabled flag has no historical value the way content does.
- **Ownership:** system-owned; readable by all authenticated clients (flags gate behavior, not data), writable only by `service_role`/admin.
- **Security Notes:** contains no user data; safe to cache aggressively client-side.
- **Future Expansion:** `rollout_pct` supports gradual percentage-based rollouts without new columns; per-user override table can be added later as a genuinely new join entity if cohort-level (not just percentage) targeting becomes necessary.

### 3.34 `system_configurations` — [system]
- **Purpose:** Key-value store for operational configuration that must be changeable without a deployment (rate limits, default quiz pass threshold, AI provider routing weights, maintenance-mode flag).
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `key` | TEXT | No | — |
| `value` | JSONB | No | — |
| `description` | TEXT | Yes | NULL |
| `updated_by` | UUID | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `key` (TEXT) — a deliberate departure from the UUID-PK default; this is a pure configuration key-value store with no cross-table references, so a natural text key is simpler and matches how the backend reads it (`get_config('quiz_default_pass_threshold')`).
- **Foreign Keys:** `updated_by` → `auth.users.id` (`ON DELETE SET NULL`)
- **Unique Constraints:** PK itself.
- **Indexes:** PK only.
- **Check Constraints:** none beyond type-level.
- **Enum Usage:** none.
- **Relationships:** none — standalone.
- **Timestamps / Soft Delete:** no soft delete; `updated_at` is the change signal, `admin_logs` records who/when for auditable changes.
- **Ownership:** system-owned; readable only by `service_role` (backend), never exposed to the client directly, since some values (rate limits, provider weights) are operationally sensitive.
- **Security Notes:** no RLS policy grants client access at all — this table is `service_role`-only by omission of any `authenticated`-role policy.
- **Future Expansion:** unbounded — any new operational toggle is a new row, not a new column/table.

### 3.35 `subscription_plans` — [CONTENT, future/reserved]
- **Purpose:** Catalog of Premium/Pro/Team/Enterprise tiers — schema-reserved, not activated in V1.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `slug` | TEXT | No | — |
| `name` | TEXT | No | — |
| `price_cents` | INTEGER | Yes | NULL |
| `billing_interval` | TEXT | Yes | NULL |
| `is_active` | BOOLEAN | No | `false` |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** none.
- **Unique Constraints:** `uq_subscription_plans_slug`.
- **Indexes:** unique index on `slug`.
- **Check Constraints:** `chk_subscription_plans_price_non_negative`.
- **Enum Usage:** none (`billing_interval` free text: `monthly`, `annual`, when activated).
- **Relationships:** 1:N to `subscriptions`; 1:N to `premium_features`.
- **Timestamps / Soft Delete:** soft delete via `is_active` only.
- **Ownership:** admin/system-owned.
- **Security Notes:** not read by any V1 code path; harmless to expose publicly once activated (pricing catalog).
- **Future Expansion:** this table is itself the future-scalability entry — V4 monetization is additive.

### 3.36 `premium_features` — [CONTENT, future/reserved]
- **Purpose:** Maps which product features are gated behind which subscription plan — the entitlement catalog consumed by the backend's authorization layer once monetization activates. Distinct from `feature_flags` (§3.33): `feature_flags` gate rollout/experimentation, `premium_features` gate paid entitlement.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `plan_id` | UUID | No | — |
| `feature_key` | TEXT | No | — |
| `limit_value` | INTEGER | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `plan_id` → `subscription_plans.id` (`ON DELETE CASCADE`)
- **Unique Constraints:** `uq_premium_features_plan_id_feature_key` on (`plan_id`, `feature_key`).
- **Indexes:** `idx_premium_features_plan_id`.
- **Check Constraints:** none beyond type-level.
- **Enum Usage:** none (`feature_key` free text: `extra_courses`, `unlimited_quiz_retakes`, `priority_voice_latency`, ...).
- **Relationships:** N:1 to `subscription_plans`.
- **Timestamps / Soft Delete:** no soft delete — deleted/replaced with the plan's edit history tracked in `admin_logs` if needed.
- **Ownership:** admin/system-owned; not read by any V1 code path.
- **Security Notes:** dormant table in V1; no RLS-relevant risk until activated.
- **Future Expansion:** `limit_value` (nullable) supports both boolean-style entitlements (row exists = enabled) and quota-style entitlements (e.g., `unlimited_quiz_retakes` vs. a numeric cap) without a schema fork.

### 3.37 `subscriptions` — [STATE, future/reserved]
- **Purpose:** Per-user active subscription record.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | No | — |
| `plan_id` | UUID | No | — |
| `status` | `subscription_status` ENUM | No | `'active'` |
| `started_at` | TIMESTAMPTZ | No | `now()` |
| `ended_at` | TIMESTAMPTZ | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |
| `updated_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE CASCADE`); `plan_id` → `subscription_plans.id` (`ON DELETE RESTRICT`)
- **Unique Constraints:** none (historized, like `learning_goals`, so billing history survives plan changes) — effectively 0:1 *active* subscription per user, enforced at the application layer.
- **Indexes:** `idx_subscriptions_user_id_status`.
- **Check Constraints:** `chk_subscriptions_ended_after_started`.
- **Enum Usage:** `subscription_status` = `active`, `canceled`, `past_due`, `expired`.
- **Relationships:** N:1 to `users`; N:1 to `subscription_plans`.
- **Timestamps / Soft Delete:** no soft delete — status transitions are the record.
- **Ownership:** `user_id = auth.uid()` for read; writes via `service_role` (payment-webhook-driven when activated).
- **Security Notes:** not populated or read by any V1 code path — exists purely so monetization doesn't require a breaking migration.
- **Future Expansion:** none required beyond activation.

### 3.38 `activity_logs` — [TELEMETRY]
- **Purpose:** General-purpose structured event log (app opens, lesson starts, feature usage) backing product analytics — distinct from the domain-specific tables above.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `user_id` | UUID | Yes | NULL |
| `event_type` | TEXT | No | — |
| `payload` | JSONB | No | `'{}'` |
| `created_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `user_id` → `auth.users.id` (`ON DELETE SET NULL`) — analytics value retained in aggregate even if the PII linkage is removed on account deletion.
- **Unique Constraints:** none.
- **Indexes:** `idx_activity_logs_event_type_created_at`; `idx_activity_logs_user_id_created_at` (partial, `WHERE user_id IS NOT NULL`).
- **Check Constraints:** none beyond type-level.
- **Enum Usage:** none (`event_type` free text — expected to grow continuously).
- **Relationships:** N:1 to `users` (optional — some events are anonymous/pre-auth).
- **Timestamps / Soft Delete:** `created_at` only, immutable, no soft delete.
- **Ownership:** attributional, not compositional — see §7 normalization rationale on `SET NULL`.
- **Security Notes:** no direct client read access; consumed by backend/analytics pipeline only.
- **Future Expansion:** designed as an append-only event stream from day one; a future analytics warehouse can consume via CDC/export without schema change.

### 3.39 `admin_logs` — [TELEMETRY, polymorphic audit]
- **Purpose:** Records all administrative actions — content edits (courses/chapters/lessons/quizzes), and, as the admin surface grows, other administrative actions (e.g., support staff looking up a user's data) — via a single generalized, polymorphic pattern rather than a narrow content-only log and a separate future admin-action log.
- **Columns:**

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | UUID | No | `gen_random_uuid()` |
| `admin_user_id` | UUID | No | — |
| `action` | TEXT | No | — |
| `entity_type` | TEXT | No | — |
| `entity_id` | UUID | Yes | NULL |
| `changes` | JSONB | Yes | NULL |
| `created_at` | TIMESTAMPTZ | No | `now()` |

- **Primary Key:** `id`
- **Foreign Keys:** `admin_user_id` → `admin_users.user_id` (`ON DELETE RESTRICT`) — audit history must not silently disappear if an admin account is removed; deactivate/revoke the admin instead.
- **Unique Constraints:** none.
- **Indexes:** `idx_admin_logs_entity_type_entity_id_created_at` composite.
- **Check Constraints:** none beyond type-level.
- **Enum Usage:** none — `entity_type`/`entity_id` is a deliberate polymorphic pair (real FK per target table would make this table's schema grow indefinitely as auditable entities grow); this is the one intentional departure from "always use a real foreign key" in this schema, acceptable because this table drives investigation, not product logic, and referential integrity here is enforced at the application layer.
- **Relationships:** N:1 to `admin_users`; polymorphic reference to `courses`/`chapters`/`lessons`/`quizzes`/any future auditable entity.
- **Timestamps / Soft Delete:** `created_at` only, immutable, no soft delete — audit trails are never mutated or removed.
- **Ownership:** admin-only visibility.
- **Security Notes:** readable only by admin roles via a policy keyed on `admin_users` membership, not `user_id = auth.uid()`.
- **Future Expansion:** the generic `entity_type`/`entity_id` pattern extends to any future auditable entity without new audit tables per type.

---

## 4. Constraints

Cross-cutting constraint rules that apply across the tables in §3, summarized here rather than repeated per table:

- **Primary key constraints:** every table has exactly one primary key; UUID-typed except `system_configurations.key` (TEXT, deliberate exception, §3.34) and the PK-as-FK extension tables (`profiles.id`, `settings.user_id`, `learning_streaks.user_id`, `admin_users.user_id`, `storage_metadata.media_file_id`).
- **Foreign key constraints:** every FK has an explicit `ON DELETE` rule (`CASCADE`, `RESTRICT`, or `SET NULL` — never left at the Postgres default of `NO ACTION` without deliberate reasoning); the full cascade rationale table is in §5.
- **Unique constraints:** used for (a) natural business keys (`courses.slug`, `badges.slug`, `feature_flags.key` + `environment`), (b) idempotency guards (`bookmarks` on `user_id`+`lesson_id`, `progress` on `user_id`+`lesson_id`, `achievements` on `user_id`+`badge_id`), and (c) ordering integrity (`chapters`, `lessons`, `lesson_contents`, `quiz_questions` on `parent_id`+`order_index`).
- **Check constraints:** used for (a) range validation on scores/percentages/durations (never negative, percentages 0–100), (b) temporal ordering (`ended_at >= started_at`-style rules), and (c) "at least one of" / "exactly one of" rules where a row must reference *some* content (`lesson_contents`, `lesson_resources`). No check constraint encodes product/business logic beyond basic data integrity — gating and grading rules live in the backend (§2 rule 5, PRD §21.2).
- **Not-null constraints:** every column is `NOT NULL` unless the table spec in §3 explicitly marks it nullable; nullability is always a deliberate design signal (an optional relationship, a value populated asynchronously, or a value that legitimately may not exist yet), never an oversight.
- **Enum constraints:** implemented as native Postgres `ENUM` types (not constrained `TEXT` with a check constraint) for the fields listed per-table in §3, because these value sets are closed, small, and rarely change; fields expected to grow frequently (`activity_logs.event_type`, `notifications.type`, `admin_logs.action`/`entity_type`) are deliberately kept as `TEXT` instead, to avoid a migration every time a new event/notification kind ships.

---

## 5. Relationships

### 5.1 Cascade Rule Table

| Relationship | On Delete | On Update | Rationale |
|---|---|---|---|
| `profiles`/`settings`/`learning_streaks`/`admin_users` → `auth.users` | CASCADE | CASCADE | No meaning without the parent identity |
| `progress`/`bookmarks`/`notes`/`quiz_attempts`/`conversation_threads`/`ai_memory`/`voice_sessions`/`camera_sessions`/`notifications`/`learning_goals`/`study_statistics`/`subscriptions` → `auth.users` | CASCADE | CASCADE | Account deletion fully removes personal learning data (privacy-first principle) |
| `activity_logs.user_id` → `auth.users` | SET NULL | CASCADE | Aggregate analytics value retained without PII linkage post-deletion |
| `media_files.uploaded_by` → `auth.users` | SET NULL | CASCADE | Storage object metadata may outlive the uploader |
| `chapters` → `courses` | RESTRICT (soft-delete course instead) | CASCADE | Prevents orphaning structural content |
| `lessons` → `chapters` | RESTRICT (soft-delete instead) | CASCADE | Same rationale |
| `lesson_contents`/`lesson_resources` → `lessons` | CASCADE | CASCADE | Content blocks have no independent existence |
| `quizzes` → `lessons` | RESTRICT (soft-delete instead) | CASCADE | Grading history depends on the quiz existing |
| `quiz_questions` → `quizzes` | CASCADE | CASCADE | No independent existence |
| `quiz_answers` → `quiz_questions` | CASCADE | CASCADE | No independent existence |
| `quiz_attempts` → `quizzes` | RESTRICT | CASCADE | Historical grading records must survive quiz edits (quizzes are versioned instead, §13) |
| `progress` → `lessons` | RESTRICT | CASCADE | Gating history must survive; lessons are soft-deleted, not hard-deleted |
| `achievements` → `badges` | RESTRICT (deactivate badge instead) | CASCADE | Earned achievements are permanent regardless of catalog changes |
| `conversation_messages` → `conversation_threads` | CASCADE | CASCADE | No independent existence |
| `voice_transcripts` → `voice_sessions` | CASCADE | CASCADE | No independent existence |
| `sleep_detection_events` → `camera_sessions` | CASCADE | CASCADE | No independent existence |
| `storage_metadata` → `media_files` | CASCADE | CASCADE | Technical metadata has no meaning without the referenced object |
| `admin_logs` → `admin_users` | RESTRICT (deactivate admin instead) | CASCADE | Audit trail must be immutable and permanent |
| `premium_features`/`subscriptions` → `subscription_plans` | CASCADE / RESTRICT respectively | CASCADE | Feature mappings are cascade-owned by the plan; historical subscription billing records must survive plan edits |

**General rule (unchanged from ERD.md §8):** `CASCADE` is used only where the child genuinely has no meaning without the parent (compositional relationships). `RESTRICT` (paired with a soft-delete path at the parent level) is used everywhere a hard delete would destroy historically meaningful records. `SET NULL` is reserved for the narrow case where the relationship is attributional, not compositional.

### 5.2 Relationship Shape Summary

- **Identity chain:** `auth.users` is the single root; `profiles`, `settings`, `learning_streaks`, `admin_users` are 1:1 extensions via PK-as-FK.
- **Content hierarchy:** `courses → chapters → lessons → lesson_contents`/`lesson_resources` is a strict, ordered 1:N chain, each level's uniqueness scoped to its immediate parent. `lessons → quizzes → quiz_questions → quiz_answers` is a parallel, structurally separate assessment hierarchy.
- **Per-user state fan-out:** almost every per-user table is N:1 to `users` and (usually) also N:1 to a content entity — a direct N:1:N shape, not a many-to-many join table.
- **The one genuine many-to-many:** `achievements`, joining `users` and `badges`.
- **Conversational nesting:** `conversation_threads → conversation_messages` is 1:N; `ai_memory` is deliberately a *sibling*, not a child, of `conversation_threads` — keyed on `(user_id, objective_tag)` so it is queryable independent of which conversation produced it.
- **Session telemetry nesting:** `learning_sessions` is the loose (nullable-FK) parent of `voice_sessions` and `camera_sessions`, acknowledging that real client behavior won't always map cleanly to server-side session boundaries.
- **Polymorphic audit:** `admin_logs` uses `entity_type`/`entity_id` rather than a per-target nullable FK — the one deliberate departure from "always use a real foreign key," justified in §3.39.

---

## 6. Index Strategy

### 6.1 The Dominant Query Pattern
"Give me everything relevant about student X" (used on every AI Tutor turn and every app open) is the single most performance-critical access pattern in the system. Every per-user table carries a direct, indexed `user_id` column specifically so this pattern never requires a multi-hop join.

### 6.2 Index Design Rules
- **Composite indexes ordered `(parent_id, ordering_or_time_column)`** throughout — matches how data is actually read (ordered lists scoped to a parent), not just existence-checked.
- **Partial indexes** where a common query filters on a boolean/null condition at scale — e.g., `notifications` unread (`WHERE read_at IS NULL`), `courses` published (`WHERE is_published = true AND deleted_at IS NULL`).
- **No bare indexes on low-cardinality boolean columns** (e.g., a standalone index on `is_correct`) — not selective enough to help; always paired with a scoping column.
- **High-volume append-only tables (`conversation_messages`, `voice_transcripts`, `activity_logs`) are deliberately under-indexed** relative to other tables — parent/user + timestamp only — because over-indexing an append-heavy table trades read convenience for write latency exactly where write volume matters most.

### 6.3 Read/Write Separation
`study_statistics` exists so dashboards, streaks, and analytics never scan `learning_sessions` or `activity_logs` directly — this rollup pattern is the primary lever for keeping read latency flat as historical data grows, not indexing alone.

### 6.4 Connection Efficiency
The FastAPI backend is stateless and horizontally scalable; connection pooling via Supabase's built-in PgBouncer-based pooler is assumed as an operational dependency of that design, not a schema concern.

---

## 7. RLS Strategy

### 7.1 Default Policy Pattern (User-Owned Tables)
For every user-owned table, the baseline policy is: a row is visible and writable only when its `user_id` (or, for extension tables, its PK) equals `auth.uid()`. This is applied per-operation (`SELECT`/`INSERT`/`UPDATE`/`DELETE`), not uniformly — several tables intentionally restrict which operations the client may perform even on rows the student owns (e.g., `progress.status` and `quiz_attempts.score_pct`/`passed` are not client-writable, per §7.3).

### 7.2 Content Tables (Read-Only for Students)
`courses`, `chapters`, `lessons`, `lesson_contents`, `lesson_resources`, `quizzes`, `quiz_questions`, `badges` are readable by all authenticated users where `is_published = true`/`is_active = true` and `deleted_at IS NULL`, but writable only by `service_role` or an `admin_users`-scoped policy. Students never have direct write access to content tables.

**Exception — `quiz_answers.is_correct`:** must never be exposed via a naive "students can read all published content" policy. Reads for attempt rendering go through a view/RPC that strips `is_correct`; grading happens server-side under `service_role`, which bypasses RLS. This is called out explicitly because it's the one place a default policy would leak information that breaks quiz integrity.

### 7.3 Backend Service Role
Gating writes (`progress`), grading writes (`quiz_attempts`, including the `passed`/`score_pct` computation), streak computation (`learning_streaks`), badge awards (`achievements`), and AI memory writes (`ai_memory`) are performed by the FastAPI backend using Supabase's `service_role` key (which bypasses RLS), never by the client directly. RLS on these tables still restricts client-side `SELECT` to the owning user; client-side `INSERT`/`UPDATE` is either disabled entirely or restricted to non-gating fields (e.g., a student can create a `progress` row on first lesson access, but cannot set `status = 'completed'` themselves).

### 7.4 Admin Access
`admin_users`, `admin_logs`, `system_configurations`, and content-table write access are gated by a policy checking `EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid())`, distinct from the general per-user pattern. `system_configurations` additionally has no `authenticated`-role policy at all — it is `service_role`-only, not even admin-readable via the client.

### 7.5 Aggregate/Anonymized Tables
`activity_logs` (post-`user_id`-nulling) is not subject to per-row RLS in the same way once anonymized — access shifts to a role-based policy (analytics/admin role) rather than per-user ownership, since the data is no longer meaningfully "owned" by an individual user after `SET NULL` on deletion.

### 7.6 Deliberate Ownership Exceptions
`conversation_messages` and `voice_transcripts` carry no direct `user_id` column (§3.14, §3.17); their RLS policies join to the parent (`conversation_threads`/`voice_sessions`) to resolve `user_id = auth.uid()`. This is a deliberate, documented exception to the "denormalize `user_id` onto every row" rule (§2 rule 4), justified because these are the two highest-volume tables in the schema and the join target is a small, indexed, low-cardinality parent table — the RLS join cost is negligible, while adding `user_id` would only bloat the table's row width without improving the dominant read pattern, which is always `conversation_id`/`voice_session_id`-scoped, never a raw per-user scan of messages/transcripts directly.

---

## 8. Storage Design

Supabase Storage holds all binary content; Postgres holds only metadata references (`media_files`, `storage_metadata`) — no BLOBs in the database.

### 8.1 Buckets

| Bucket | Contents | Access |
|---|---|---|
| `avatars` | User profile pictures | Private; per-user read/write via Storage policy matching `auth.uid()` in the object path |
| `course-media` | Lesson diagrams, images, embedded media referenced by `lesson_contents` | Public-read (published content), admin-write only |
| `lesson-resources` | Slide decks, cheat sheets, datasets referenced by `lesson_resources` | Public-read (published content), admin-write only |
| `badge-icons` | Badge catalog icons | Public-read, admin-write only |

### 8.2 Path Convention
Object paths encode ownership/scope for Storage-policy matching: `avatars/{user_id}/{filename}`, `course-media/{course_id}/{lesson_id}/{filename}`, `lesson-resources/{course_id}/{lesson_id}/{filename}` — this mirrors the Postgres FK/naming conventions (§2) so Storage policies and RLS policies reason about ownership consistently.

### 8.3 Explicit Non-Use of Storage
Camera frames and voice audio are **never** written to Storage. This is a hard product/privacy constraint, called out here so a future engineer doesn't assume Storage is the "obvious place" to persist that data — `voice_sessions`/`voice_transcripts`/`camera_sessions`/`sleep_detection_events` are telemetry-only by schema construction (§3.16–3.19).

### 8.4 Storage-to-Database Consistency
Every object write to a bucket must be accompanied by a `media_files` row (and, once technical properties are known, a `storage_metadata` row); orphaned Storage objects with no `media_files` row are treated as a data-integrity issue and swept by a scheduled backend job, not silently tolerated.

---

## 9. Realtime Strategy

Realtime (Postgres logical replication via Supabase) is enabled **selectively**, not globally:

- **Enabled:** `progress` (cross-device gate/progress sync), `notifications` (live badge/unread updates), `achievements` (live "you earned a badge" moments).
- **Not enabled:** `conversation_messages`/`voice_transcripts` (live transcript delivery is handled by the dedicated voice WebSocket session, not table-level Realtime — using both would be redundant and risks ordering/duplication bugs), `activity_logs`/`voice_sessions`/`camera_sessions`/`sleep_detection_events`/`admin_logs` (telemetry, no live-UI consumer), all content tables (low write frequency; refetch-on-navigation is sufficient).

**Rationale:** each Realtime-enabled table adds replication overhead and client subscription complexity; the rule applied is "only enable Realtime where a specific UI moment genuinely needs push delivery."

**Supabase Auth trigger note:** a `handle_new_user` trigger auto-creates `profiles`, `settings`, and `learning_streaks` rows on signup, keeping the 1:1 extension tables always populated rather than requiring defensive nullable-row-existence checks throughout the application.

**Function/Trigger strategy summary:**
- `set_updated_at()` — shared `BEFORE UPDATE` trigger applied to every table with an `updated_at` column.
- `handle_new_user()` — `AFTER INSERT` trigger on `auth.users`, provisions `profiles`/`settings`/`learning_streaks` with privacy-safe defaults.
- Gating/grading/streak/badge-award logic is explicitly **not** implemented as database triggers or functions — it lives in the FastAPI backend (§2 rule 5, PRD §21.2), keeping business logic out of the database layer entirely; the only database-side functions are structural (timestamp maintenance, identity provisioning).

**Views / Materialized Views:** no materialized views are required at V1 scale. `study_statistics` already serves the rollup role a materialized view would otherwise serve, updated incrementally by the backend rather than recomputed on a refresh cycle. A `quiz_question_options_public` view (or equivalent RPC) is used to serve quiz question/answer data to students with `is_correct` stripped, per §7.2. Weekly/monthly statistics aggregations, if needed later, are the natural first candidates for a materialized view layered on top of `study_statistics`.

**Partitioning strategy:** `conversation_messages`, `voice_transcripts`, and `activity_logs` are the partitioning candidates, structured (indexed on `created_at`, minimal secondary indexing) to support future range partitioning by month/quarter on `created_at` — not activated at V1 scale, but the indexing shape chosen now avoids an expensive retrofit later (§12).

---

## 10. Backup Strategy

- **Automated daily backups** via Supabase's managed Postgres backup service (point-in-time recovery where the project tier supports it) — this is a platform-provided capability, not custom-built, and is the primary recovery mechanism for catastrophic failure or accidental destructive migration.
- **Pre-migration snapshot discipline:** any migration touching a `RESTRICT`-protected or high-value table (`progress`, `quiz_attempts`, `courses`) is preceded by a manual/CI-triggered backup checkpoint in addition to the platform's automated schedule, given these tables' role as gating/grading source-of-truth.
- **Soft-deleted and versioned content is itself a backup mechanism** for content: because `courses`/`chapters`/`lessons`/`quizzes` are soft-deleted and coarse-versioned (§13) rather than mutated destructively, most "I need the old version back" recovery scenarios for content don't require restoring from a database-level backup at all.
- **`admin_logs`** provides a secondary, queryable recovery aid for content specifically (what changed, by whom, when) distinct from a full database restore.
- **Storage backup:** Supabase Storage objects are backed by the underlying object storage provider's durability guarantees; `media_files`/`storage_metadata` rows are backed up as part of the standard Postgres backup, so a Postgres restore and a Storage-bucket state can, in principle, drift — this is a known operational risk to monitor (§8.4's consistency-sweep job doubles as a drift detector).

---

## 11. Migration Strategy

- **Sequential, versioned migration files** (standard Supabase CLI / `supabase migration` workflow) are the mechanism; this document describes the target structure migrations converge on, not the migration process itself.
- **Additive-first discipline:** new columns are added nullable-with-default wherever possible so a migration never requires a blocking table rewrite or an application-code deploy to happen in lockstep; tightening a column to `NOT NULL` is a separate, later migration once backfill is confirmed complete.
- **Enum changes:** adding a new enum value is additive and low-risk; removing or renaming an enum value requires a two-step migration (add new value, backfill/migrate rows, then remove old value) since Postgres enum types don't support in-place value removal without a type-swap.
- **RESTRICT-protected tables** (`chapters`, `lessons`, `quizzes` relative to their parents) mean structural content migrations must go through the soft-delete/unpublish path, never a destructive `DELETE`, consistent with §5.1.
- **New courses, new lesson/content types (within the existing `content_block_type`/`lesson_type` enum), new badges, new notification/activity-log event kinds** are all additive changes requiring no migration to existing rows — purely new rows or, at most, a new enum value.
- **Breaking changes** (column type changes, constraint tightening on existing data, table splits) require: (1) a backward-compatible transition period where both old and new shapes are readable, (2) a backfill job, (3) a cutover migration, (4) a cleanup migration removing the old shape — never a single-step destructive migration on a live production table.
- **Reserved/future tables** (`subscription_plans`, `subscriptions`, `premium_features`) exist specifically so V4 monetization activation is a matter of populating and reading them, not a migration event at all.

---

## 12. Scalability Notes

- **Horizontal read scaling:** the FastAPI backend is stateless (§6.4), so backend horizontal scaling is an infrastructure concern independent of this schema; the schema's contribution to scalability is keeping the dominant "everything about student X" query single-join-or-less (§6.1) so it stays fast under load without requiring backend-side caching to compensate.
- **Partitioning-ready design:** `conversation_messages`, `voice_transcripts`, `activity_logs` are indexed minimally and consistently on `created_at` (§9) specifically so time-based range partitioning is a structural, not redesign-level, change when volume warrants it.
- **Archival candidates:** `conversation_messages`, `voice_transcripts`, `activity_logs`, and superseded course-content versions are the natural candidates for rolling off to cheaper storage or a data warehouse after a retention window (no specific retention period is fixed here — a product/legal decision, not an architectural one). `progress` and `quiz_attempts` are explicitly **not** archival candidates — they remain live, queryable, per-user data for the life of the account, since they directly inform current gating/mastery state.
- **New courses, platforms, and languages are additive** at the schema level (§9 Future Expansion notes throughout §3) — the single most important scalability property of this schema is that "one course" scaling to "many courses" requires zero structural migration, only new rows.
- **Future horizontal scaling beyond Postgres vertical scaling:** if a single Postgres instance eventually becomes the bottleneck (a scale point well beyond V1's expected load), the natural first move is read-replica routing for the read-heavy content tables (§1 CONTENT workload), since those are the least write-contended and most cacheable; the per-user STATE and TELEMETRY workloads would require a more significant sharding-by-`user_id` strategy if ever necessary, which this document does not design for at V1 but does not foreclose either, given every user-owned table's consistent `user_id`-first indexing.

---

## 13. Engineering Notes

- **Normalization target:** Third Normal Form (3NF) by default, with named, documented departures: `user_id` denormalized onto per-user tables for RLS performance (§2 rule 4, with the deliberate reverse exception on `conversation_messages`/`voice_transcripts`, §7.6); `study_statistics` as a denormalized daily rollup to avoid expensive aggregation at read time; `conversations.summary`-equivalent (`conversation_threads.summary`) as a denormalized, derived-but-stored compression of message history; `quiz_attempts.answers` as structured JSONB in place of a per-question join table, because attempt answers are never queried independently of their parent attempt and are written atomically on submission.
- **Versioning strategy:** course content is versioned at the course level via `courses.content_version` — a coarse-grained strategy deliberately, because the product-level question that matters is "is a student's in-progress experience still coherent," a structural question, not a field-level one. `progress.content_version` is a reserved field (not required for V1's single-course launch, structurally trivial) so a future version can decide whether to migrate a student forward or let them finish on the version they started. Quiz versioning follows the same coarse pattern: a quiz's question bank changing is a content edit tracked in `admin_logs`, not a new `quizzes` row — `quiz_attempts` remain valid historical records regardless of later quiz edits, since an attempt records the actual questions/answers presented at the time within its own `answers` field.
- **Soft delete rule of thumb:** soft-delete anything another table's foreign key might point to historically (content entities); hard-delete anything that's a true leaf node with no downstream dependents (`notes`, `bookmarks`). Full account deletion is the one deliberate exception where hard-deleting personal data is itself the privacy-correct behavior, not a default to avoid.
- **No business logic in the database beyond what referential integrity requires.** Gating, grading, mastery calculations, streak computation, and badge-award logic all live in the FastAPI backend. The database enforces *data* integrity (foreign keys, uniqueness, check constraints); it does not enforce *product* rules. This is the single most load-bearing engineering principle in this schema and is why §7.3's `service_role`-only write paths exist for `progress`, `quiz_attempts`, `learning_streaks`, and `achievements`.
- **Design for the query pattern, not just the entity.** Every indexing decision in §6 traces back to a named, real access pattern from PRD.md, not a hypothetical one — this is the standard this document holds itself to when a future engineer proposes a new index.
- **Consistent conventions are the actual scalability mechanism.** The FK/naming/cascade/soft-delete conventions established in §2, §4, §5 are what make future structural expansion (new tables for genuinely new entities) low-friction — a new engineer reading this document should be able to predict a new table's PK/FK/cascade/index shape before reading its individual spec, because every table in §3 follows the same small rule set rather than inventing its own pattern.
