/// Mentor course creation form.
///
/// Collects the required course identity fields — title, description, category,
/// language and level — validates them, then persists a new draft through
/// [CourseAuthoringRepository] and navigates into the course editor. Category,
/// language and level pick from curated lists via the shared dropdown field.
library;

import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';

import '../../data/mock_course_authoring_repository.dart';
import '../../domain/entities/course_authoring_draft.dart';
import '../../domain/entities/draft_status.dart';
import '../../domain/repositories/course_authoring_repository.dart';

class CourseCreatePage extends StatefulWidget {
  const CourseCreatePage({super.key, this.repository, this.onCreated});

  /// Injected for tests; defaults to the shared in-memory mock repository.
  final CourseAuthoringRepository? repository;

  /// Overrides the post-create navigation (used by tests).
  final void Function(CourseAuthoringDraft draft)? onCreated;

  @override
  State<CourseCreatePage> createState() => _CourseCreatePageState();
}

class _CourseCreatePageState extends State<CourseCreatePage> {
  static const List<String> _categories = [
    'Pemrograman',
    'Mobile',
    'Web',
    'Data Science',
    'Desain',
  ];

  static const List<String> _languages = [
    'Python',
    'Dart',
    'JavaScript',
    'Kotlin',
    'Java',
    'Swift',
  ];

  static const List<String> _levels = ['Pemula', 'Menengah', 'Mahir'];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _category;
  String? _language;
  String? _level;

  bool get _canCreate =>
      _titleController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty &&
      _category != null &&
      _language != null &&
      _level != null;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleChanged(String _) => setState(() {});

  void _create() {
    if (!_formKey.currentState!.validate()) return;

    final draft = CourseAuthoringDraft(
      id: 'draft-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category!,
      language: _language!,
      level: _level!,
      targetAudience: 'Semua level',
      status: DraftStatus.draft,
      updatedAt: DateTime.now(),
    );

    final repo = widget.repository ?? MockCourseAuthoringRepository.instance;
    repo.createDraft(draft);

    if (widget.onCreated != null) {
      widget.onCreated!(draft);
      return;
    }
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.resolve(AppRoutes.mentorCourseEditor, {'courseId': draft.id}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Scaffold(
      backgroundColor: ext.background,
      appBar: const AppAppBar(title: 'Buat Course'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppPageHeader(
                  title: 'Informasi Course',
                  subtitle:
                      'Lengkapi informasi dasar sebelum menyusun pelajaran.',
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _titleController,
                  label: 'Nama Course',
                  hint: 'Contoh: Dasar Python',
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama course tidak boleh kosong.';
                    }
                    return null;
                  },
                  onChanged: _handleChanged,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _descriptionController,
                  label: 'Deskripsi',
                  hint: 'Jelaskan isi dan tujuan course ini.',
                  maxLines: 3,
                  minLines: 2,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi tidak boleh kosong.';
                    }
                    return null;
                  },
                  onChanged: _handleChanged,
                ),
                const SizedBox(height: AppSpacing.md),
                AppDropdownField.strings(
                  initialValue: _category,
                  items: _categories,
                  label: 'Kategori',
                  hint: 'Pilih kategori',
                  validator: (value) =>
                      value == null ? 'Pilih kategori course.' : null,
                  onChanged: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: AppSpacing.md),
                AppDropdownField.strings(
                  initialValue: _language,
                  items: _languages,
                  label: 'Bahasa Pemrograman',
                  hint: 'Pilih bahasa',
                  validator: (value) =>
                      value == null ? 'Pilih bahasa pemrograman.' : null,
                  onChanged: (value) => setState(() => _language = value),
                ),
                const SizedBox(height: AppSpacing.md),
                AppDropdownField.strings(
                  initialValue: _level,
                  items: _levels,
                  label: 'Level',
                  hint: 'Pilih level',
                  validator: (value) => value == null ? 'Pilih level.' : null,
                  onChanged: (value) => setState(() => _level = value),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Buat Course',
                  isFullWidth: true,
                  size: AppButtonSize.large,
                  onPressed: _canCreate ? _create : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
