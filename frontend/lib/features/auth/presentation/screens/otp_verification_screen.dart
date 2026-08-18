//**
// frontend/features/auth/presentation/screens/otp_verification_screen.dart
//
// frontend:
// Source file. Bagian dari MentorinAja frontend.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi file behavior sesuai dengan purpose.
//**
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../logic/auth_strings.dart';
import '../../logic/otp_verification_controller.dart';
import '../widgets/auth_scaffold.dart';
import 'otp_verification_config.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    this.config = const OtpVerificationConfig(),
  });

  final OtpVerificationConfig config;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late final OtpVerificationController _controller;
  final GlobalKey<AppOtpInputState> _otpKey = GlobalKey<AppOtpInputState>();
  String _target = '';

  @override
  void initState() {
    super.initState();
    _controller = OtpVerificationController(length: widget.config.length);
    _controller.startCountdown();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argument = ModalRoute.of(context)?.settings.arguments;
    if (argument is String && argument != _target) {
      _target = argument;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_controller.isVerifying || _controller.isVerified) return;
    final verified = await _controller.verify();
    if (!mounted) return;

    if (!verified) {
      AppNotificationService.show(
        context,
        type: AppNotificationType.error,
        title: AuthStrings.otpErrorTitle,
        message: _controller.error ?? AuthStrings.otpErrorMessage,
        actionLabel: 'Try again',
      );
      return;
    }

    AppNotificationService.show(
      context,
      type: AppNotificationType.success,
      title: AuthStrings.otpSuccessTitle,
      message: AuthStrings.otpSuccessMessage,
      actionLabel: 'Got it',
    );

    await Future<void>.delayed(AppDurations.slowest);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, widget.config.destination);
  }

  void _resend() {
    if (!_controller.canResend) return;
    _controller.resend();
    AppNotificationService.show(
      context,
      type: AppNotificationType.info,
      title: AuthStrings.otpResendInfoTitle,
      message: AuthStrings.otpResendInfoMessage,
      actionLabel: 'Got it',
    );
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (!mounted) return;
    _otpKey.currentState?.pasteValue(data?.text ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return AuthScaffold(
      maxWidth: 440,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      contentBuilder: (context, constraints) {
        final keySize = (constraints.maxWidth / 5).clamp(48.0, 68.0);

        return IntrinsicHeight(
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              final busy = _controller.isVerifying;
              final inputEnabled = !busy && !_controller.isVerified;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppGap(AppSpacing.lg),
                  Text(
                    widget.config.title,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppGap.xs,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Text(
                      widget.config.subtitle,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                  AppGap.lg,
                  if (_target.isNotEmpty) _EmailTarget(target: _target),
                  AppGap.lg,
                  _ShakeBox(
                    trigger: _controller.errorEpoch,
                    child: AppOtpInput(
                      key: _otpKey,
                      length: widget.config.length,
                      maxWidth: (constraints.maxWidth - AppSpacing.md * 2)
                          .clamp(200.0, 360.0),
                      enabled: inputEnabled,
                      hasError: _controller.error != null,
                      onChanged: _controller.updateCode,
                      onCompleted: (_) => _verify(),
                    ),
                  ),
                  AppGap.md,
                  _ResendRow(
                    label: _controller.countdownLabel,
                    canResend: _controller.canResend,
                    onResend: _resend,
                  ),
                  AppGap.md,
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: inputEnabled ? _paste : null,
                      style: TextButton.styleFrom(
                        foregroundColor: colors.textSecondary,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text(AuthStrings.otpPaste),
                    ),
                  ),
                  const AppGap(AppSpacing.xl),
                  AppButton(
                    onPressed: busy ? null : _verify,
                    label: widget.config.buttonLabel,
                    isFullWidth: true,
                    size: AppButtonSize.large,
                    isLoading: busy,
                  ),
                  const Spacer(flex: 2),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          MediaQuery.paddingOf(context).bottom + AppSpacing.sm,
                    ),
                    child: AppNumericKeypad(
                      keySize: keySize,
                      enabled: inputEnabled,
                      onDigit: (digit) => _otpKey.currentState?.append(digit),
                      onBackspace: () => _otpKey.currentState?.removeLast(),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _EmailTarget extends StatelessWidget {
  const _EmailTarget({required this.target});

  final String target;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mail_outline,
              size: AppIconSizes.md,
              color: colors.textSecondary,
            ),
            AppGap.xs,
            Text(
              target,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            TextButton(
              onPressed: () => Navigator.maybePop(context),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text(AuthStrings.otpEmailEdit),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow({
    required this.label,
    required this.canResend,
    required this.onResend,
  });

  final String label;
  final bool canResend;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    if (canResend) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AuthStrings.otpDidNotReceive,
            style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(width: AppSpacing.xxs),
          TextButton(
            onPressed: onResend,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
            child: const Text(AuthStrings.otpResendAction),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.schedule, size: AppIconSizes.sm, color: colors.textDisabled),
        AppGap.xs,
        Text(
          '${AuthStrings.otpResendIn} $label',
          style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _ShakeBox extends StatefulWidget {
  const _ShakeBox({required this.trigger, required this.child});

  final int trigger;
  final Widget child;

  @override
  State<_ShakeBox> createState() => _ShakeBoxState();
}

class _ShakeBoxState extends State<_ShakeBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  int _lastTrigger = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.slower,
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: AppEasing.decelerate,
    );
  }

  @override
  void didUpdateWidget(_ShakeBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != _lastTrigger) {
      _lastTrigger = widget.trigger;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final decay = 1 - _progress.value;
        final dx = math.sin(_progress.value * math.pi * 5) * 8 * decay;
        return Transform.translate(offset: Offset(dx, 0), child: widget.child);
      },
    );
  }
}
