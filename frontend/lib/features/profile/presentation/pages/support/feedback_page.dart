import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

/// Feedback and suggestion form.
///
/// Lets the learner pick a category, write a message with a live character
/// counter and submit. Submission is a local mock that swaps the form for a
/// clear success state — no backend endpoint is invented.
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  static const List<String> _categories = [
    'Course',
    'Aplikasi',
    'Mentor',
    'Lainnya',
  ];

  final TextEditingController _messageController = TextEditingController();
  String _selectedCategory = 'Course';
  bool _submitted = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Scaffold(
      backgroundColor: ext.background,
      appBar: const AppAppBar(title: 'Masukan & Saran'),
      body: _submitted
          ? AppEmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: 'Masukan Terkirim',
              message:
                  'Terima kasih, masukanmu sangat berarti untuk kami. Tim akan '
                  'meninjaunya secara berkala.',
              actionLabel: 'Kirim Masukan Lagi',
              onAction: () => _reset(),
            )
          : _FeedbackForm(
              messageController: _messageController,
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) =>
                  setState(() => _selectedCategory = category),
              onMessageChanged: (_) => setState(() {}),
              onSubmit: () => _submit(),
              canSubmit: _messageController.text.trim().isNotEmpty,
            ),
    );
  }

  void _submit() {
    setState(() => _submitted = true);
  }

  void _reset() {
    _messageController.clear();
    setState(() {
      _submitted = false;
      _selectedCategory = 'Course';
    });
  }
}

/// The feedback entry form shown before submission.
class _FeedbackForm extends StatelessWidget {
  const _FeedbackForm({
    required this.messageController,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onMessageChanged,
    required this.onSubmit,
    required this.canSubmit,
  });

  final TextEditingController messageController;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onMessageChanged;
  final VoidCallback onSubmit;
  final bool canSubmit;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xl),
      child: ResponsiveContainer(
        maxWidth: 640,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsivePadding.horizontal(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bantu kami membuat MentorinAja lebih baik.',
              style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Kategori',
              style: AppTypeScale.titleSmall.copyWith(color: ext.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final category in categories)
                  AppChoiceChip(
                    label: category,
                    selected: selectedCategory == category,
                    onSelected: (_) => onCategorySelected(category),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppMultilineField(
              controller: messageController,
              label: 'Pesan',
              hint: 'Tuliskan masukan atau saranmu di sini...',
              maxLength: 500,
              onChanged: onMessageChanged,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Kirim Masukan',
              isFullWidth: true,
              enabled: canSubmit,
              onPressed: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
