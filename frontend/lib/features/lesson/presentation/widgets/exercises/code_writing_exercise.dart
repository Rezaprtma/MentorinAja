//**
// frontend/features/lesson/presentation/widgets/exercises/code_writing_exercise.dart
//
// frontend:
// Reusable widget. Menampilkan komponen UI yang dapat digunakan di berbagai places.
//
// backend:
// Future: akan memerlukan backend API untuk validasi kode nyata.
//
// api:
// Menyediakan seam untuk integrasi API backend di masa depan.
//
// qa:
// QA perlu memvalidasi code editor, output terminal, dan success feedback.
//**
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../../domain/entities/lesson_exercise.dart';
import '../../widgets/learning_navigation_bar.dart';

class CodeWritingExercise extends StatefulWidget {
  const CodeWritingExercise({
    super.key,
    required this.exercise,
    this.selfEvaluate = false,
    this.onSuccess,
  });

  final LessonExercise exercise;
  final bool selfEvaluate;
  final VoidCallback? onSuccess;

  @override
  State<CodeWritingExercise> createState() => _CodeWritingExerciseState();
}

class _CodeWritingExerciseState extends State<CodeWritingExercise> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  final List<String> _undoStack = [];
  final List<String> _redoStack = [];
  bool _isUndoingOrRedoing = false;

  bool _submitted = false;
  bool _correct = false;
  bool _isRunning = false;
  bool _isTerminalCollapsed = false;

  String _terminalOutput = '';
  String? _terminalError;

  @override
  void initState() {
    super.initState();
    final initialCode = widget.exercise.code ?? '';
    _controller = TextEditingController(text: initialCode);
    _undoStack.add(_controller.text);
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    if (_isUndoingOrRedoing) return;
    final text = _controller.text;
    if (_undoStack.isEmpty || _undoStack.last != text) {
      if (_undoStack.length > 50) _undoStack.removeAt(0);
      _undoStack.add(text);
      _redoStack.clear();
      setState(() {});
    }
  }

  void _undo() {
    if (_undoStack.length > 1) {
      setState(() {
        _isUndoingOrRedoing = true;
        final current = _undoStack.removeLast();
        _redoStack.add(current);
        final prev = _undoStack.last;
        _controller.text = prev;
        _controller.selection = TextSelection.collapsed(offset: prev.length);
        _isUndoingOrRedoing = false;
      });
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      setState(() {
        _isUndoingOrRedoing = true;
        final next = _redoStack.removeLast();
        _undoStack.add(next);
        _controller.text = next;
        _controller.selection = TextSelection.collapsed(offset: next.length);
        _isUndoingOrRedoing = false;
      });
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _controller.text));
    AppToast.show(
      context,
      title: 'Kode Disalin',
      message: 'Kode berhasil disalin ke clipboard.',
      severity: AppFeedbackSeverity.info,
    );
  }

  void _clearCode() {
    setState(() {
      _controller.clear();
    });
  }

  void _saveDraft() {
    AppToast.show(
      context,
      title: 'Kode Disimpan',
      message: 'Draft kode berhasil disimpan.',
      severity: AppFeedbackSeverity.success,
    );
  }

  Future<void> _submit() async {
    final code = _controller.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isRunning = true;
      _submitted = true;
      _isTerminalCollapsed = false;
      _terminalOutput = 'Executing...';
      _terminalError = null;
    });

    // Code execution simulation & Validation Seam
    final result = await _runAndValidateCode(code);

    if (!mounted) return;

    setState(() {
      _isRunning = false;
      _correct = result.correct;
      _terminalOutput = result.output;
      _terminalError = result.correct ? null : result.feedback;
    });

    if (_correct) {
      widget.onSuccess?.call();
      if (mounted) {
        AppToast.show(
          context,
          title: 'Modul Selesai!',
          message: 'Kamu telah berhasil menyelesaikan latihan ini.',
          severity: AppFeedbackSeverity.success,
        );
      }
    }
  }

  Future<_CodeValidationResult> _runAndValidateCode(String sourceCode) async {
    // Simulating delay for compiler execution
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // Simulated parser: extract print/log outputs
    final output = _simulateExecution(sourceCode);

    // Flexible correctness check (output-based check rather than exact string matching)
    final isCorrect = _checkCorrectnessSemantically(sourceCode, output);

    return _CodeValidationResult(
      correct: isCorrect,
      output: output,
      feedback: isCorrect
          ? 'Process finished with exit code 0'
          : 'SyntaxError / AssertionError: Hasil kode belum sesuai dengan ekspektasi.',
    );
  }

  String _simulateExecution(String code) {
    // Python print
    final pyMatches = RegExp(
      r'''print\s*\(\s*['"](.*?)['"]\s*\)''',
    ).allMatches(code);
    if (pyMatches.isNotEmpty) {
      return pyMatches.map((m) => m.group(1)).join('\n');
    }

    // JS/TS console.log
    final jsMatches = RegExp(
      r'''console\.log\s*\(\s*['"](.*?)['"]\s*\)''',
    ).allMatches(code);
    if (jsMatches.isNotEmpty) {
      return jsMatches.map((m) => m.group(1)).join('\n');
    }

    return 'No standard output produced.';
  }

  bool _checkCorrectnessSemantically(String code, String output) {
    final expected = widget.exercise.expectedAnswer?.trim() ?? '';
    if (expected.isEmpty) return true;

    // Check if the simulation output matches expected answer
    if (output.trim().toLowerCase() == expected.toLowerCase()) {
      return true;
    }

    // Semantic seam fallback
    return false;
  }

  String _fileNameForExercise() {
    final title = (widget.exercise.title ?? '').toLowerCase();
    if (title.contains('javascript') || title.contains('js')) return 'main.js';
    if (title.contains('typescript') || title.contains('ts')) return 'main.ts';
    if (title.contains('dart') || title.contains('flutter')) return 'main.dart';
    if (title.contains('java')) return 'Main.java';
    if (title.contains('c++') || title.contains('cpp')) return 'main.cpp';
    if (title.contains('c#')) return 'Program.cs';
    if (title.contains('go')) return 'main.go';
    if (title.contains('rust')) return 'main.rs';
    if (title.contains('php')) return 'index.php';
    if (title.contains('kotlin')) return 'Main.kt';
    if (title.contains('swift')) return 'main.swift';
    if (title.contains('html')) return 'index.html';
    if (title.contains('css')) return 'styles.css';
    if (title.contains('sql')) return 'query.sql';
    return 'main.py';
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final exercise = widget.exercise;
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final fileName = _fileNameForExercise();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header & Instructions (collapsible when keyboard is open to maximize coding area)
        if (!isKeyboardOpen) ...[
          Text(
            exercise.title ?? 'Latihan Coding',
            style: AppTypeScale.titleMedium.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (exercise.instruction != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              exercise.instruction!,
              style: AppTypeScale.bodySmall.copyWith(
                color: ext.textSecondary,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (exercise.code != null && exercise.code!.isNotEmpty) ...[
            _ContextCodeSurface(code: exercise.code!),
            const SizedBox(height: AppSpacing.md),
          ],
        ],

        // IDE Workspace Container
        Expanded(
          child: _CodeEditorWorkspace(
            fileName: fileName,
            controller: _controller,
            focusNode: _focusNode,
            readOnly: _submitted && _correct,
            onUndo: _undo,
            onRedo: _redo,
            onCopy: _copyToClipboard,
            onClear: _clearCode,
            onRun: _submit,
            onSave: _saveDraft,
            canUndo: _undoStack.length > 1,
            canRedo: _redoStack.isNotEmpty,
            canRun: !(_submitted && _correct) && !_isRunning,
            canSave: !_isRunning,
            isRunning: _isRunning,
            submitted: _submitted,
            correct: _correct,
            terminalOutput: _terminalOutput,
            terminalError: _terminalError,
            isTerminalCollapsed: _isTerminalCollapsed,
            onToggleTerminal: () {
              setState(() {
                _isTerminalCollapsed = !_isTerminalCollapsed;
              });
            },
          ),
        ),

        // Bottom space safety margin to avoid LearningNavigationBar overlay
        if (!isKeyboardOpen)
          const SizedBox(height: LearningNavigationBar.reservedContentSpace),
      ],
    );
  }
}

class _CodeEditorWorkspace extends StatelessWidget {
  const _CodeEditorWorkspace({
    required this.fileName,
    required this.controller,
    required this.focusNode,
    required this.readOnly,
    required this.onUndo,
    required this.onRedo,
    required this.onCopy,
    required this.onClear,
    required this.onRun,
    required this.onSave,
    required this.canUndo,
    required this.canRedo,
    required this.canRun,
    required this.canSave,
    required this.isRunning,
    required this.submitted,
    required this.correct,
    required this.terminalOutput,
    required this.terminalError,
    required this.isTerminalCollapsed,
    required this.onToggleTerminal,
  });

  final String fileName;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool readOnly;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onCopy;
  final VoidCallback onClear;
  final VoidCallback onRun;
  final VoidCallback onSave;
  final bool canUndo;
  final bool canRedo;
  final bool canRun;
  final bool canSave;
  final bool isRunning;
  final bool submitted;
  final bool correct;
  final String terminalOutput;
  final String? terminalError;
  final bool isTerminalCollapsed;
  final VoidCallback onToggleTerminal;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme-driven surfaces based on app Theme Mode (No forced dark mode!)
    final editorBg = isDark
        ? const Color(0xFF17191D)
        : scheme.surfaceContainerLowest;
    final editorHeaderBg = isDark
        ? const Color(0xFF1B1E23)
        : scheme.surfaceContainerLow;
    final codeTextColor = isDark ? const Color(0xFFEDEFF2) : ext.textPrimary;
    final lineNumbersColor = isDark
        ? const Color(0xFF6F7782)
        : ext.textSecondary.withValues(alpha: 0.6);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: editorBg,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: ext.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Header Toolbar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm + 2,
              vertical: AppSpacing.xs,
            ),
            color: editorHeaderBg,
            child: Row(
              children: [
                Icon(
                  Icons.insert_drive_file_outlined,
                  size: AppIconSizes.xs,
                  color: scheme.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  fileName,
                  style: AppTypeScale.labelSmall.copyWith(
                    color: isDark ? const Color(0xFFB0B7C3) : ext.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),

                // Action: Run (Primary Accent Hero)
                _toolbarActionButton(
                  icon: isRunning
                      ? Icons.hourglass_empty_rounded
                      : Icons.play_arrow_rounded,
                  tooltip: 'Jalankan kode',
                  onPressed: canRun ? onRun : null,
                  isPrimary: true,
                  scheme: scheme,
                  ext: ext,
                  isDark: isDark,
                ),
                const SizedBox(width: 4),

                // Action: Save (Secondary Outlined/Neutral)
                _toolbarActionButton(
                  icon: Icons.save_rounded,
                  tooltip: 'Simpan kode',
                  onPressed: canSave ? onSave : null,
                  isPrimary: false,
                  scheme: scheme,
                  ext: ext,
                  isDark: isDark,
                ),

                _verticalSeparator(ext),

                // Tools: Undo / Redo
                _toolbarToolButton(
                  icon: Icons.undo_rounded,
                  tooltip: 'Urungkan',
                  onPressed: canUndo ? onUndo : null,
                  isDark: isDark,
                ),
                _toolbarToolButton(
                  icon: Icons.redo_rounded,
                  tooltip: 'Ulangi',
                  onPressed: canRedo ? onRedo : null,
                  isDark: isDark,
                ),

                _verticalSeparator(ext),

                // Utilities: Copy / Clear
                _toolbarToolButton(
                  icon: Icons.copy_all_rounded,
                  tooltip: 'Salin kode',
                  onPressed: onCopy,
                  isDark: isDark,
                ),
                _toolbarToolButton(
                  icon: Icons.clear_all_rounded,
                  tooltip: 'Bersihkan kode',
                  onPressed: onClear,
                  isDark: isDark,
                ),
              ],
            ),
          ),

          // Code Editing Area
          Expanded(
            child: _CodeEditorContent(
              controller: controller,
              focusNode: focusNode,
              readOnly: readOnly,
              textColor: codeTextColor,
              lineNumbersColor: lineNumbersColor,
            ),
          ),

          // Integrated Terminal Panel (Part of the same workspace container!)
          _TerminalPanel(
            fileName: fileName,
            isCorrect: correct,
            output: terminalOutput,
            errorText: terminalError,
            submitted: submitted,
            isRunning: isRunning,
            isCollapsed: isTerminalCollapsed,
            onToggle: onToggleTerminal,
            isDark: isDark,
            ext: ext,
            scheme: scheme,
          ),
        ],
      ),
    );
  }

  Widget _verticalSeparator(AppThemeExtension ext) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(width: 1, height: 16, color: ext.border),
    );
  }

  Widget _toolbarActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    required bool isPrimary,
    required ColorScheme scheme,
    required AppThemeExtension ext,
    required bool isDark,
  }) {
    final bgColor = onPressed == null
        ? Colors.transparent
        : isPrimary
        ? scheme.primary
        : (isDark ? const Color(0xFF22262C) : scheme.surfaceContainerHigh);
    final iconColor = onPressed == null
        ? (isDark ? const Color(0xFF565D66) : const Color(0xFFB0B7C3))
        : isPrimary
        ? scheme.onPrimary
        : (isDark ? const Color(0xFFEDEFF2) : ext.textPrimary);

    return Semantics(
      label: tooltip,
      button: true,
      enabled: onPressed != null,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.small),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.small),
              border: !isPrimary && onPressed != null
                  ? Border.all(color: ext.border)
                  : null,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
        ),
      ),
    );
  }

  Widget _toolbarToolButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    required bool isDark,
  }) {
    return Semantics(
      label: tooltip,
      button: true,
      enabled: onPressed != null,
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 16),
          color: isDark ? const Color(0xFFEDEFF2) : const Color(0xFF1D2939),
          disabledColor: isDark
              ? const Color(0xFF565D66)
              : const Color(0xFFB0B7C3),
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ),
    );
  }
}

class _CodeEditorContent extends StatefulWidget {
  const _CodeEditorContent({
    required this.controller,
    required this.focusNode,
    required this.readOnly,
    required this.textColor,
    required this.lineNumbersColor,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool readOnly;
  final Color textColor;
  final Color lineNumbersColor;

  @override
  State<_CodeEditorContent> createState() => _CodeEditorContentState();
}

class _CodeEditorContentState extends State<_CodeEditorContent> {
  int _lineCount = 1;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateLines);
    _updateLines();
  }

  @override
  void didUpdateWidget(covariant _CodeEditorContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_updateLines);
      widget.controller.addListener(_updateLines);
      _updateLines();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateLines);
    super.dispose();
  }

  void _updateLines() {
    final text = widget.controller.text;
    final count = text.isEmpty ? 1 : text.split('\n').length;
    if (count != _lineCount) {
      setState(() {
        _lineCount = count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line Numbers Gutter
          Container(
            width: 36,
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            alignment: Alignment.topRight,
            child: Text(
              List.generate(_lineCount, (i) => '${i + 1}').join('\n'),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.5,
                color: widget.lineNumbersColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),

          // Code Text Field (Seamlessly blended into editor background - NO WHITE BOX)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Semantics(
                textField: true,
                label: 'Editor kode',
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  readOnly: widget.readOnly,
                  maxLines: null,
                  minLines: 8,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.5,
                    color: widget.textColor,
                  ),
                  decoration: const InputDecoration(
                    fillColor: Colors.transparent,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  enableSuggestions: false,
                ),
              ),
            ),
          ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    final editorBg = isDark
        ? const Color(0xFF17191D)
        : scheme.surfaceContainerLowest;
    final editorHeaderBg = isDark
        ? const Color(0xFF1B1E23)
        : scheme.surfaceContainerLow;
    final editorTextColor = isDark ? const Color(0xFFEDEFF2) : ext.textPrimary;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: editorBg,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: ext.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs + 2,
            ),
            color: editorHeaderBg,
            child: Row(
              children: [
                Icon(
                  Icons.code_rounded,
                  size: AppIconSizes.xs,
                  color: isDark ? const Color(0xFFB0B7C3) : ext.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Konteks',
                  style: AppTypeScale.labelSmall.copyWith(
                    color: isDark ? const Color(0xFFB0B7C3) : ext.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              code,
              style: AppTypeScale.code.copyWith(
                color: editorTextColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalPanel extends StatelessWidget {
  const _TerminalPanel({
    required this.fileName,
    required this.isCorrect,
    required this.output,
    required this.errorText,
    required this.submitted,
    required this.isRunning,
    required this.isCollapsed,
    required this.onToggle,
    required this.isDark,
    required this.ext,
    required this.scheme,
  });

  final String fileName;
  final bool isCorrect;
  final String output;
  final String? errorText;
  final bool submitted;
  final bool isRunning;
  final bool isCollapsed;
  final VoidCallback onToggle;
  final bool isDark;
  final AppThemeExtension ext;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    // Theme-driven terminal surface colors (No random dark blue / slate in light theme)
    final terminalBg = isDark
        ? const Color(0xFF0C0E10)
        : scheme.surfaceContainerLow;
    final terminalHeaderBg = isDark
        ? const Color(0xFF17191D)
        : scheme.surfaceContainerHigh;
    final dividerColor = ext.border;
    final outputTextColor = isDark ? const Color(0xFFEDEFF2) : ext.textPrimary;
    final promptColor = isDark ? const Color(0xFF6F7782) : ext.textSecondary;

    return Container(
      decoration: BoxDecoration(
        color: terminalBg,
        border: Border(top: BorderSide(color: dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Terminal Header Row
          InkWell(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs + 2,
              ),
              color: terminalHeaderBg,
              child: Row(
                children: [
                  Icon(
                    Icons.terminal_rounded,
                    size: 16,
                    color: isRunning
                        ? scheme.primary
                        : submitted
                        ? (isCorrect ? ext.success : scheme.error)
                        : ext.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'TERMINAL',
                    style: AppTypeScale.labelSmall.copyWith(
                      color: isRunning
                          ? scheme.primary
                          : submitted
                          ? (isCorrect ? ext.success : scheme.error)
                          : ext.textPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isRunning
                          ? scheme.primary.withValues(alpha: 0.15)
                          : submitted
                          ? (isCorrect
                                ? ext.success.withValues(alpha: 0.15)
                                : scheme.error.withValues(alpha: 0.15))
                          : (isDark
                                ? const Color(0xFF22262C)
                                : scheme.surfaceContainerHighest),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isRunning
                          ? 'RUNNING'
                          : submitted
                          ? (isCorrect ? 'SUCCESS' : 'ERROR')
                          : 'READY',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: isRunning
                            ? scheme.primary
                            : submitted
                            ? (isCorrect ? ext.success : scheme.error)
                            : ext.textSecondary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isCollapsed
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: ext.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          // Terminal Output Scrollable Area
          if (!isCollapsed)
            Container(
              constraints: BoxConstraints(maxHeight: submitted ? 120 : 60),
              padding: const EdgeInsets.all(AppSpacing.md),
              color: terminalBg,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (submitted || isRunning) ...[
                      Text(
                        '\$ python $fileName',
                        style: AppTypeScale.code.copyWith(
                          color: promptColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (isRunning)
                        Text(
                          'Executing code...',
                          style: AppTypeScale.code.copyWith(
                            color: ext.textSecondary,
                            fontSize: 12,
                          ),
                        )
                      else if (isCorrect) ...[
                        Text(
                          output,
                          style: AppTypeScale.code.copyWith(
                            color: outputTextColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Process finished with exit code 0',
                          style: AppTypeScale.code.copyWith(
                            color: ext.success,
                            fontSize: 11,
                          ),
                        ),
                      ] else ...[
                        // Error Output Traceback Look
                        Text(
                          'Traceback (most recent call last):\n'
                          '  File "$fileName", line 2, in <module>\n'
                          '${errorText ?? "AssertionError: Hasil output belum sesuai."}',
                          style: AppTypeScale.code.copyWith(
                            color: scheme.error,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Process finished with exit code 1',
                          style: AppTypeScale.code.copyWith(
                            color: scheme.error,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ] else
                      Text(
                        'Terminal ready. Press Run in the toolbar to execute.',
                        style: AppTypeScale.code.copyWith(
                          color: ext.textDisabled,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CodeValidationResult {
  final bool correct;
  final String output;
  final String? feedback;

  const _CodeValidationResult({
    required this.correct,
    required this.output,
    this.feedback,
  });
}
