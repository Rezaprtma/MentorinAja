/// Editable list of material content blocks for an authored lesson.
///
/// Renders one card per block: a dropdown to pick the block type and a content
/// field. List-type blocks (bullet, numbered, checklist) treat each line as an
/// item; code blocks expose an extra language label. Adding a block appends a
/// fresh paragraph. The widget is fully controlled — [blocks] and [onChanged]
/// drive the state so the parent persists every edit.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/enums/enums.dart';
import 'package:frontend/shared/design_system/design_system.dart';

import '../../domain/entities/material_block_draft.dart';

class MaterialBlockEditor extends StatelessWidget {
  const MaterialBlockEditor({
    super.key,
    required this.blocks,
    required this.onChanged,
  });

  final List<MaterialBlockDraft> blocks;
  final ValueChanged<List<MaterialBlockDraft>> onChanged;

  void _update(int index, MaterialBlockDraft block) {
    final updated = [...blocks];
    updated[index] = block;
    onChanged(updated);
  }

  void _remove(int index) {
    final updated = [...blocks]..removeAt(index);
    onChanged(updated);
  }

  void _add() {
    onChanged([
      ...blocks,
      MaterialBlockDraft(
        id: 'mb-${DateTime.now().millisecondsSinceEpoch}',
        type: LessonContentBlockType.paragraph,
        order: blocks.length,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < blocks.length; i++) ...[
          _MaterialBlockCard(
            key: ValueKey(blocks[i].id),
            block: blocks[i],
            onChanged: (block) => _update(i, block),
            onRemove: () => _remove(i),
          ),
          if (i < blocks.length - 1) const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: 'Tambah Blok Materi',
          leadingIcon: Icons.add,
          variant: AppButtonVariant.outlined,
          size: AppButtonSize.small,
          onPressed: _add,
        ),
      ],
    );
  }
}

class _MaterialBlockCard extends StatelessWidget {
  const _MaterialBlockCard({
    super.key,
    required this.block,
    required this.onChanged,
    required this.onRemove,
  });

  final MaterialBlockDraft block;
  final ValueChanged<MaterialBlockDraft> onChanged;
  final VoidCallback onRemove;

  bool get _isListType =>
      block.type == LessonContentBlockType.bulletList ||
      block.type == LessonContentBlockType.numberedList ||
      block.type == LessonContentBlockType.checklist;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppDropdownField<LessonContentBlockType>(
                  initialValue: block.type,
                  label: 'Tipe Blok',
                  items: LessonContentBlockType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(_blockTypeLabel(type)),
                        ),
                      )
                      .toList(),
                  onChanged: (type) {
                    if (type == null) return;
                    onChanged(block.copyWith(type: type));
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: AppIconSizes.sm,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: onRemove,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            initialValue: _isListType
                ? block.items.join('\n')
                : (block.text ?? ''),
            label: _isListType ? 'Isi (satu per baris)' : 'Isi',
            hint: _isListType
                ? 'Tulis tiap poin pada baris terpisah.'
                : 'Tulis isi blok di sini.',
            maxLines: 5,
            minLines: 2,
            onChanged: (value) {
              if (_isListType) {
                final items = value
                    .split('\n')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                onChanged(block.copyWith(items: items, text: null));
              } else {
                onChanged(block.copyWith(text: value, items: []));
              }
            },
          ),
          if (block.type == LessonContentBlockType.code) ...[
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              initialValue: block.label ?? '',
              label: 'Label Bahasa',
              hint: 'Contoh: Python',
              onChanged: (value) => onChanged(block.copyWith(label: value)),
            ),
          ],
        ],
      ),
    );
  }
}

/// Human-readable Bahasa Indonesia label for a content block type.
String _blockTypeLabel(LessonContentBlockType type) {
  return switch (type) {
    LessonContentBlockType.paragraph => 'Paragraf',
    LessonContentBlockType.heading => 'Judul',
    LessonContentBlockType.subheading => 'Sub Judul',
    LessonContentBlockType.code => 'Kode',
    LessonContentBlockType.bulletList => 'Daftar Poin',
    LessonContentBlockType.numberedList => 'Daftar Bernomor',
    LessonContentBlockType.checklist => 'Daftar Ceklis',
    LessonContentBlockType.tip => 'Tips',
    LessonContentBlockType.warning => 'Peringatan',
    LessonContentBlockType.example => 'Contoh',
    LessonContentBlockType.summary => 'Ringkasan',
    LessonContentBlockType.exercise => 'Latihan',
  };
}
