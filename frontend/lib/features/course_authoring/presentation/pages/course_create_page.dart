//**
// frontend/features/course_authoring/presentation/pages/course_create_page.dart
//
// frontend:
// Screen/page. Menampilkan UI dan menerima user interactions.
//
// backend:
// Future: akan membutuhkan backend data dan API calls.
//
// api:
// Future: akan melakukan API calls melalui controllers/repositories.
//
// qa:
// QA perlu memvalidasi UI rendering, user interactions, dan navigation.
//**
library;

import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/enums/enums.dart';

import '../../data/mock_course_authoring_repository.dart';
import '../../domain/entities/course_authoring_draft.dart';
import '../../domain/entities/draft_status.dart';
import '../../domain/entities/lesson_draft.dart';
import '../../domain/repositories/course_authoring_repository.dart';
import '../widgets/course_logo_selector.dart';

class CourseCreatePage extends StatefulWidget {
  const CourseCreatePage({super.key, this.repository, this.onCreated});

  final CourseAuthoringRepository? repository;

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

  static const List<String> _levels = ['Pemula', 'Menengah', 'Mahir'];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _totalModulesController = TextEditingController(text: '1');

  String? _category;
  String? _level;
  ProgrammingLanguage? _selectedLanguage;

  final List<TextEditingController> _moduleTitleControllers = [
    TextEditingController(),
  ];
  final List<String?> _modulePdfPaths = [null];

  bool get _canCreate {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _category == null ||
        _level == null ||
        _selectedLanguage == null) {
      return false;
    }

    for (var i = 0; i < _moduleTitleControllers.length; i++) {
      if (_moduleTitleControllers[i].text.trim().isEmpty ||
          _modulePdfPaths[i] == null) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _totalModulesController.addListener(_adjustModuleFields);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _totalModulesController.dispose();
    for (final controller in _moduleTitleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _adjustModuleFields() {
    final text = _totalModulesController.text.trim();
    final count = int.tryParse(text) ?? 0;
    if (count <= 0) return;

    setState(() {
      while (_moduleTitleControllers.length < count) {
        _moduleTitleControllers.add(TextEditingController());
        _modulePdfPaths.add(null);
      }
      while (_moduleTitleControllers.length > count) {
        final last = _moduleTitleControllers.removeLast();
        last.dispose();
        _modulePdfPaths.removeLast();
      }
    });
  }

  void _handleChanged(String _) => setState(() {});

  void _simulatePdfUpload(int index) {
    setState(() {
      final name = _moduleTitleControllers[index].text.trim().replaceAll(
        ' ',
        '_',
      );
      final sanitizedName = name.isEmpty ? 'modul_${index + 1}' : name;
      _modulePdfPaths[index] = 'assets/pdfs/${sanitizedName.toLowerCase()}.pdf';
    });
  }

  void _create() {
    if (!_formKey.currentState!.validate()) return;

    final lessons = <LessonDraft>[];
    for (var i = 0; i < _moduleTitleControllers.length; i++) {
      lessons.add(
        LessonDraft(
          id: 'lesson-${DateTime.now().millisecondsSinceEpoch}-$i',
          title: _moduleTitleControllers[i].text.trim(),
          description:
              'Deskripsi modul ${i + 1} untuk course ${_titleController.text.trim()}.',
          order: i,
          materialPdfPath: _modulePdfPaths[i],
        ),
      );
    }

    final draft = CourseAuthoringDraft(
      id: 'draft-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category!,
      language: _selectedLanguage!.displayName,
      level: _level!,
      targetAudience: 'Semua level',
      objectives: const ['Memahami materi pokok course'],
      status: DraftStatus.draft,
      updatedAt: DateTime.now(),
      lessons: lessons,
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
    final scheme = Theme.of(context).colorScheme;

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
                      'Lengkapi informasi dasar dan modul sebelum mempublikasikan.',
                ),
                const SizedBox(height: AppSpacing.lg),
                CourseLogoSelector(
                  selectedLanguage: _selectedLanguage,
                  onLanguageSelected: (lang) =>
                      setState(() => _selectedLanguage = lang),
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
                  initialValue: _level,
                  items: _levels,
                  label: 'Level',
                  hint: 'Pilih level',
                  validator: (value) => value == null ? 'Pilih level.' : null,
                  onChanged: (value) => setState(() => _level = value),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _totalModulesController,
                  label: 'Jumlah Modul',
                  hint: 'Contoh: 3',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final num = int.tryParse(value ?? '');
                    if (num == null || num <= 0) {
                      return 'Jumlah modul minimal 1.';
                    }
                    return null;
                  },
                  onChanged: _handleChanged,
                ),
                const SizedBox(height: AppSpacing.lg),
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'MODUL BELAJAR',
                  style: AppTypeScale.labelMedium.copyWith(
                    color: ext.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                for (var i = 0; i < _moduleTitleControllers.length; i++) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppRadius.large),
                      border: Border.all(color: ext.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Modul ${i + 1}',
                          style: AppTypeScale.titleSmall.copyWith(
                            color: ext.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppTextField(
                          controller: _moduleTitleControllers[i],
                          label: 'Judul Modul',
                          hint: 'Contoh: Mengenal Variabel',
                          onChanged: _handleChanged,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Dokumen Materi PDF',
                          style: AppTypeScale.labelSmall.copyWith(
                            color: ext.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: ext.card,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.small,
                                  ),
                                  border: Border.all(color: ext.border),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.picture_as_pdf_rounded,
                                      color: _modulePdfPaths[i] != null
                                          ? scheme.error
                                          : ext.textDisabled,
                                      size: AppIconSizes.md,
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Text(
                                        _modulePdfPaths[i] != null
                                            ? _modulePdfPaths[i]!
                                                  .split('/')
                                                  .last
                                            : 'Belum ada file terpilih',
                                        style: AppTypeScale.bodySmall.copyWith(
                                          color: _modulePdfPaths[i] != null
                                              ? ext.textPrimary
                                              : ext.textDisabled,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            AppButton(
                              label: 'Pilih PDF',
                              variant: AppButtonVariant.outlined,
                              size: AppButtonSize.small,
                              onPressed: () => _simulatePdfUpload(i),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                const SizedBox(height: AppSpacing.lg),
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
