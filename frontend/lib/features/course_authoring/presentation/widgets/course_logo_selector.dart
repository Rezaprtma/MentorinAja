//**
// frontend/features/course_authoring/presentation/widgets/course_logo_selector.dart
//
// frontend:
// Reusable widget. Menampilkan komponen UI yang dapat digunakan di berbagai places.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:frontend/shared/enums/enums.dart';
import 'package:frontend/shared/design_system/design_system.dart';

class CourseLogoSelector extends StatelessWidget {
  const CourseLogoSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
    this.label = 'Logo Course',
    this.hint = 'Pilih logo untuk identitas course',
  });

  final ProgrammingLanguage? selectedLanguage;
  final ValueChanged<ProgrammingLanguage> onLanguageSelected;
  final String label;
  final String hint;

  void _showPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LogoPickerSheet(
        selectedLanguage: selectedLanguage,
        onSelected: onLanguageSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypeScale.labelLarge.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          hint,
          style: AppTypeScale.bodySmall.copyWith(color: ext.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        InkWell(
          onTap: () => _showPicker(context),
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: selectedLanguage != null
                  ? scheme.primaryContainer.withValues(alpha: 0.08)
                  : scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border.all(
                color: selectedLanguage != null
                    ? scheme.primary.withValues(alpha: 0.5)
                    : ext.border,
                width: selectedLanguage != null ? 1.5 : 1,
              ),
            ),
            child: _buildPreviewContent(context, ext, scheme),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewContent(
    BuildContext context,
    AppThemeExtension ext,
    ColorScheme scheme,
  ) {
    if (selectedLanguage != null) {
      return Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: ext.border),
            ),
            child: Center(
              child: SvgPicture.asset(
                selectedLanguage!.iconPath,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
                semanticsLabel: selectedLanguage!.displayName,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedLanguage!.displayName,
                  style: AppTypeScale.titleMedium.copyWith(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Logo course terpilih',
                  style: AppTypeScale.bodySmall.copyWith(
                    color: ext.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Ganti',
            style: AppTypeScale.labelMedium.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: ext.border),
          ),
          child: Center(
            child: Icon(Icons.add_rounded, size: 28, color: ext.textDisabled),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Belum ada logo',
                style: AppTypeScale.titleMedium.copyWith(
                  color: ext.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Pilih identitas visual course',
                style: AppTypeScale.bodySmall.copyWith(color: ext.textDisabled),
              ),
            ],
          ),
        ),
        Text(
          'Pilih',
          style: AppTypeScale.labelMedium.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LogoPickerSheet extends StatefulWidget {
  const _LogoPickerSheet({
    required this.selectedLanguage,
    required this.onSelected,
  });

  final ProgrammingLanguage? selectedLanguage;
  final ValueChanged<ProgrammingLanguage> onSelected;

  @override
  State<_LogoPickerSheet> createState() => _LogoPickerSheetState();
}

class _LogoPickerSheetState extends State<_LogoPickerSheet> {
  late final TextEditingController _searchController;
  late List<ProgrammingLanguage> _filteredLanguages;

  // Flattened list of all languages from categories
  static final List<ProgrammingLanguage> _allLanguages = _flattenCategories();

  static List<ProgrammingLanguage> _flattenCategories() {
    final List<ProgrammingLanguage> result = [];
    result.addAll([
      ProgrammingLanguage.python,
      ProgrammingLanguage.javascript,
      ProgrammingLanguage.typescript,
      ProgrammingLanguage.java,
      ProgrammingLanguage.c,
      ProgrammingLanguage.cpp,
      ProgrammingLanguage.csharp,
      ProgrammingLanguage.dart,
      ProgrammingLanguage.go,
      ProgrammingLanguage.rust,
      ProgrammingLanguage.php,
      ProgrammingLanguage.kotlin,
      ProgrammingLanguage.swift,
      ProgrammingLanguage.r,
      ProgrammingLanguage.ruby,
      ProgrammingLanguage.html,
      ProgrammingLanguage.css,
      ProgrammingLanguage.react,
      ProgrammingLanguage.vuejs,
      ProgrammingLanguage.angular,
      ProgrammingLanguage.nextjs,
      ProgrammingLanguage.flutter,
      ProgrammingLanguage.nodejs,
      ProgrammingLanguage.express,
      ProgrammingLanguage.django,
      ProgrammingLanguage.laravel,
      ProgrammingLanguage.mysql,
      ProgrammingLanguage.postgresql,
      ProgrammingLanguage.sqlite,
      ProgrammingLanguage.sql,
      ProgrammingLanguage.solidity,
      ProgrammingLanguage.terminal,
    ]);
    return result;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredLanguages = List.from(_allLanguages);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _filteredLanguages = List.from(_allLanguages);
      });
      return;
    }

    setState(() {
      _filteredLanguages = _allLanguages.where((lang) {
        return lang.displayName.toLowerCase().contains(query) ||
            lang.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 600;
    final crossAxisCount = isWide ? 5 : 3;
    final childAspectRatio = isWide ? 0.85 : 0.9;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: ext.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.extraLarge),
            ),
          ),
          child: Column(
            children: [
              _buildDragHandle(ext),
              _buildHeader(context, ext, scheme),
              _buildSearchField(context, ext, scheme),
              const Divider(height: 1),
              Expanded(
                child: _buildGrid(
                  context,
                  ext,
                  scheme,
                  scrollController,
                  crossAxisCount,
                  childAspectRatio,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(AppThemeExtension ext) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: ext.border,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppThemeExtension ext,
    ColorScheme scheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Text(
            'Pilih Logo Course',
            style: AppTypeScale.titleLarge.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close_rounded, color: ext.textSecondary),
            tooltip: 'Tutup pemilih logo',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(
    BuildContext context,
    AppThemeExtension ext,
    ColorScheme scheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: AppSearchField(
        controller: _searchController,
        hint: 'Cari teknologi...',
        prefix: Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    AppThemeExtension ext,
    ColorScheme scheme,
    ScrollController scrollController,
    int crossAxisCount,
    double childAspectRatio,
  ) {
    if (_filteredLanguages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: ext.textDisabled),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Tidak ada teknologi ditemukan',
              style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Coba kata kunci lain',
              style: AppTypeScale.bodySmall.copyWith(color: ext.textDisabled),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: _filteredLanguages.length,
      itemBuilder: (context, index) {
        final lang = _filteredLanguages[index];
        final isSelected = widget.selectedLanguage == lang;
        return _LogoGridItem(
          language: lang,
          isSelected: isSelected,
          onTap: () {
            widget.onSelected(lang);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _LogoGridItem extends StatelessWidget {
  const _LogoGridItem({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final ProgrammingLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      label:
          '${language.displayName}${isSelected ? ', dipilih' : ', tidak dipilih'}',
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? scheme.primaryContainer.withValues(alpha: 0.15)
                : scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(
              color: isSelected ? scheme.primary : ext.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        language.iconPath,
                        width: 36,
                        height: 36,
                        fit: BoxFit.contain,
                        semanticsLabel: language.displayName,
                      ),
                      if (isSelected)
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: scheme.onPrimary,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: scheme.primary.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: scheme.onPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                language.displayName,
                style: AppTypeScale.labelSmall.copyWith(
                  color: isSelected ? scheme.primary : ext.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
