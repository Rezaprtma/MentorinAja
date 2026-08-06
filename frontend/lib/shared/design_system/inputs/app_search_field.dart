import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Search / filter input with a leading magnifier and a clear button.
///
/// Built as a standalone [TextField] (not a form field) because search is
/// typically uncontrolled and off the form validation path. Exposes [controller]
/// for debounce or programmatic clearing.
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.hint = 'Search',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onClear,
    this.autofocus = false,
    this.enabled = true,
    this.textInputAction = TextInputAction.search,
    this.prefix,
    this.suffix,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool enabled;
  final TextInputAction textInputAction;

  /// Optional custom prefix icon replacing the default magnifier.
  final Widget? prefix;

  /// Optional custom trailing widget rendered before the clear button.
  final Widget? suffix;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _internalController;
  late final bool _ownsController;

  TextEditingController get _controller =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _internalController = TextEditingController();
  }

  @override
  void dispose() {
    if (_ownsController) _internalController.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        final showClear = widget.enabled && value.text.isNotEmpty;
        final clearBtn = showClear
            ? Semantics(
                label: 'Clear search',
                button: true,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: AppIconSizes.md,
                    color: scheme.onSurfaceVariant,
                  ),
                  onPressed: _clear,
                ),
              )
            : null;

        return TextField(
          controller: _controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon:
                widget.prefix ??
                Icon(Icons.search, color: scheme.onSurfaceVariant),
            suffixIcon: widget.suffix ?? clearBtn,
          ),
        );
      },
    );
  }
}
