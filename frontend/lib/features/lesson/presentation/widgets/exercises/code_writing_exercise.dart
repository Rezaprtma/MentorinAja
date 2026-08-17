/// "Tulis Kode" exercise — the learner writes code from scratch.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../../domain/entities/lesson_exercise.dart';
import 'exercise_card.dart';
import 'exercise_feedback.dart';

/// Free-form code-writing exercise where the learner types actual code.
///
/// Unlike token-completion (selecting tokens) or code-correction (choosing a
/// fix), this exercise gives the learner a blank code editor and asks them to
/// produce the correct output from scratch. In [selfEvaluate] mode the answer
/// is checked on every keystroke once the field is non-empty; otherwise a submit
/// button triggers evaluation.
class CodeWritingExercise extends StatefulWidget {
  const CodeWritingExercise({
    super.key,
    required this.exercise,
    this.selfEvaluate = false,
  });

  final LessonExercise exercise;
  final bool selfEvaluate;

  @override
  State<CodeWritingExercise> createState() => _CodeWritingExerciseState();
}

class _CodeWritingExerciseState extends State<CodeWritingExercise> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _submitted = false;
  bool _correct = false;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        if (widget.selfEvaluate && _controller.text.trim().isNotEmpty) {
          _submitted = true;
          _correct = _answerIsCorrect;
        }
      });
    });
  }

  String get _expected => widget.exercise.expectedAnswer ?? '';

  bool get _answerIsCorrect {
    final input = _controller.text.trim();
    if (input.isEmpty || _expected.isEmpty) return false;
    final normalizedInput = input
        .replaceAll('\r\n', '\n')
        .split('\n')
        .map((e) => e.trimRight())
        .join('\n');
    final normalizedExpected = _expected.trim().replaceAll('\r\n', '\n');
    return normalizedInput == normalizedExpected;
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _submitted = true;
      _correct = _answerIsCorrect;
    });
  }

  void _retry() {
    setState(() {
      _controller.clear();
      _submitted = false;
      _correct = false;
      _showHint = false;
    });
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

    return ExerciseCard(
      exercise: exercise,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (exercise.code != null && exercise.code!.isNotEmpty) ...[
            _ContextCodeSurface(code: exercise.code!),
            const SizedBox(height: AppSpacing.md),
          ],
          _CodeEditorField(
            controller: _controller,
            focusNode: _focusNode,
            readOnly: _submitted && _correct,
            submitted: _submitted,
            correct: _submitted ? _correct : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (!widget.selfEvaluate) ...[
            if (_submitted && !_correct)
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  AppButton(label: 'Coba Lagi', onPressed: _retry),
                  AppButton(label: 'Periksa Lagi', onPressed: _submit),
                ],
              )
            else
              AppButton(
                label: 'Periksa Jawaban',
                isFullWidth: true,
                onPressed:
                    _controller.text.trim().isEmpty || (_submitted && _correct)
                    ? null
                    : _submit,
              ),
          ],
          if (_submitted && _correct) ...[
            const SizedBox(height: AppSpacing.sm),
            _CorrectCodeSurface(code: _expected),
          ],
          if (_showHint && !_correct) ...[
            const SizedBox(height: AppSpacing.sm),
            ExerciseHintView(hint: exercise.hint ?? ''),
          ],
          if (_submitted) ...[
            const SizedBox(height: AppSpacing.sm),
            ExerciseFeedbackPanel(
              isCorrect: _correct,
              message: _correct
                  ? 'Bagus! Kode kamu benar.'
                  : 'Belum tepat. Periksa kembali kode yang kamu tulis.',
              explanation: _correct ? exercise.explanation : null,
              hint: exercise.hint,
              onShowHint: () => setState(() => _showHint = true),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContextCodeSurface extends StatelessWidget {
  const _ContextCodeSurface({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: ext.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.xxs,
              runSpacing: AppSpacing.xxs,
              children: [
                Icon(
                  Icons.code_rounded,
                  size: AppIconSizes.xs,
                  color: ext.textSecondary,
                ),
                Text(
                  'Konteks',
                  style: AppTypeScale.labelSmall.copyWith(
                    color: ext.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: ext.border),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              code,
              style: AppTypeScale.code.copyWith(color: ext.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeEditorField extends StatelessWidget {
  const _CodeEditorField({
    required this.controller,
    required this.focusNode,
    required this.readOnly,
    required this.submitted,
    this.correct,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool readOnly;
  final bool submitted;
  final bool? correct;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    final Color borderColor;
    if (correct == true) {
      borderColor = ext.success;
    } else if (correct == false) {
      borderColor = scheme.error;
    } else {
      borderColor = ext.border;
    }

    return Semantics(
      textField: true,
      label: 'Editor kode',
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(color: borderColor, width: submitted ? 1.4 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.xxs,
                runSpacing: AppSpacing.xxs,
                children: [
                  Icon(
                    Icons.edit_rounded,
                    size: AppIconSizes.xs,
                    color: ext.textSecondary,
                  ),
                  Text(
                    'Tulis kode kamu',
                    style: AppTypeScale.labelSmall.copyWith(
                      color: ext.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: ext.border),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                readOnly: readOnly,
                maxLines: null,
                minLines: 4,
                style: AppTypeScale.code.copyWith(color: ext.textPrimary),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Ketik kode di sini…',
                  hintStyle: AppTypeScale.code.copyWith(
                    color: ext.textDisabled,
                  ),
                ),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CorrectCodeSurface extends StatelessWidget {
  const _CorrectCodeSurface({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ext.successContainer,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: ext.success),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.xxs,
              runSpacing: AppSpacing.xxs,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: AppIconSizes.xs,
                  color: ext.onSuccessContainer,
                ),
                Text(
                  'Jawaban yang benar',
                  style: AppTypeScale.labelSmall.copyWith(
                    color: ext.onSuccessContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: ext.success),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              code,
              style: AppTypeScale.code.copyWith(color: ext.onSuccessContainer),
            ),
          ),
        ],
      ),
    );
  }
}
