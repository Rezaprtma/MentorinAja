/// Editable objectives list for the course editor.
///
/// Renders each objective with a remove action and an inline text field to add
/// a new one. Appends happen through [onAdd]; deletions through [onRemove].
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

class CourseObjectiveEditor extends StatefulWidget {
  const CourseObjectiveEditor({
    super.key,
    required this.objectives,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> objectives;
  final ValueChanged<String> onAdd;
  final ValueChanged<int> onRemove;

  @override
  State<CourseObjectiveEditor> createState() => _CourseObjectiveEditorState();
}

class _CourseObjectiveEditorState extends State<CourseObjectiveEditor> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    widget.onAdd(value);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'TUJUAN PEMBELAJARAN',
          style: AppTypeScale.labelMedium.copyWith(
            color: ext.textSecondary,
            letterSpacing: 1.25,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (widget.objectives.isEmpty)
          Text(
            'Belum ada tujuan. Tambahkan tujuan yang ingin dicapai pelajar.',
            style: AppTypeScale.bodySmall.copyWith(color: ext.textSecondary),
          )
        else
          for (var i = 0; i < widget.objectives.length; i++) ...[
            _ObjectiveRow(
              index: i,
              text: widget.objectives[i],
              onRemove: () => widget.onRemove(i),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppTextField(
                controller: _controller,
                label: 'Tujuan baru',
                hint: 'Contoh: Mampu menulis program sederhana',
                onSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppButton(label: 'Tambah', onPressed: _submit),
          ],
        ),
      ],
    );
  }
}

class _ObjectiveRow extends StatelessWidget {
  const _ObjectiveRow({
    required this.index,
    required this.text,
    required this.onRemove,
  });

  final int index;
  final String text;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${index + 1}',
            style: AppTypeScale.labelSmall.copyWith(
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTypeScale.bodyMedium.copyWith(color: ext.textPrimary),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: AppIconSizes.md,
            color: ext.textDisabled,
          ),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
