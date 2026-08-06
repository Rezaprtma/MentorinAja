import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../logic/auth_strings.dart';
import '../../logic/otp_verification_controller.dart';
import '../widgets/auth_scaffold.dart';
import 'otp_verification_config.dart';

/// Verification-code step, reusable across the app.
///
/// Driven by [OtpVerificationConfig], it collects a digit code with auto-focus,
/// paste and a resend countdown. Errors shake the boxes; a verified code shows
/// a brief success state before navigating to
/// [OtpVerificationConfig.destination].
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    this.config = const OtpVerificationConfig(),
  });

  /// Copy, code length and destination behaviour for this instance.
  final OtpVerificationConfig config;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late final OtpVerificationController _controller;
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
    final verified = await _controller.verify();
    if (!mounted || !verified) return;

    await Future<void>.delayed(AppDurations.slowest);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, widget.config.destination);
  }

  void _resend() {
    if (!_controller.canResend) return;
    _controller.resend();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return AuthScaffold(
      appBar: AppBar(),
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final busy = _controller.isVerifying;
          final verified = _controller.isVerified;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppGap(AppSpacing.xl),
              Text(
                widget.config.title,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppGap.xs,
              Text(
                widget.config.subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              if (_target.isNotEmpty) ...[
                AppGap.xs,
                Text(
                  _target,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const AppGap(AppSpacing.xl),
              _ShakeBox(
                trigger: _controller.errorEpoch,
                child: AppOtpField(
                  length: widget.config.length,
                  autofocus: widget.config.autofocus,
                  autofillHints: widget.config.autofillHints,
                  enabled: !busy && !verified,
                  error: _controller.error,
                  onChanged: _controller.updateCode,
                  onCompleted: (_) => _verify(),
                ),
              ),
              AppGap.lg,
              if (verified)
                _SuccessNotice(message: widget.config.successMessage)
              else
                _ResendRow(
                  label: _controller.countdownLabel,
                  resendButtonLabel: widget.config.resendButtonLabel,
                  canResend: _controller.canResend,
                  onResend: _resend,
                ),
              const AppGap(AppSpacing.xl),
              AppButton(
                onPressed: busy || verified ? null : _verify,
                label: widget.config.buttonLabel,
                isFullWidth: true,
                size: AppButtonSize.large,
                isLoading: busy,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Replays a horizontal shake whenever [trigger] changes (e.g. on OTP error).
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

/// Countdown + resend action beneath the code boxes.
class _ResendRow extends StatelessWidget {
  const _ResendRow({
    required this.label,
    required this.resendButtonLabel,
    required this.canResend,
    required this.onResend,
  });

  final String label;
  final String resendButtonLabel;
  final bool canResend;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.schedule, size: AppIconSizes.sm, color: colors.textDisabled),
        AppGap.xs,
        Text(
          canResend
              ? AuthStrings.otpCanResend
              : '${AuthStrings.otpResendIn} $label',
          style: textTheme.labelMedium?.copyWith(color: colors.textSecondary),
        ),
        AppGap.xs,
        TextButton(
          onPressed: canResend ? onResend : null,
          child: Text(resendButtonLabel),
        ),
      ],
    );
  }
}

/// Brief success confirmation shown after a verified code.
class _SuccessNotice extends StatelessWidget {
  const _SuccessNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: AppIconSizes.md, color: colors.success),
        AppGap.xs,
        Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: colors.success),
        ),
      ],
    );
  }
}
