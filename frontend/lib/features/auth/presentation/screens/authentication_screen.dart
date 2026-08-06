import 'package:flutter/material.dart';

import 'package:frontend/core/core.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../logic/auth_strings.dart';
import '../widgets/auth_ambient_background.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/google_auth_button.dart';

/// Premium authentication landing — the single visual entry point.
///
/// The Auth hero is the identity; no heading competes with it. Below it sit the
/// primary CTA (Continue with Google), a divider, the Create Account action and
/// a Sign In text link, with Terms & Privacy pinned to the bottom of the
/// viewport on every screen size.
class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  void _continueWithGoogle(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(AuthStrings.googleUnavailable),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      maxWidth: 400,
      background: const AuthAmbientBackground(),
      contentBuilder: (context, constraints) {
        final h = constraints.maxHeight;
        final heroSize = (constraints.maxWidth * 0.55).clamp(200.0, 300.0);
        final gapHero = (h * 0.015).clamp(12.0, 20.0);

        return IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Positions the hero slightly lower so it becomes the focal point.
              const Spacer(flex: 3),
              Center(
                child: AppFadeIn(
                  duration: AppDurations.slower,
                  child: AppLottie(
                    AppAnimations.authWelcome,
                    width: heroSize,
                    height: heroSize,
                    semanticsLabel: 'Welcome animation',
                  ),
                ),
              ),
              SizedBox(height: gapHero),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GoogleAuthButton(
                      onPressed: () => _continueWithGoogle(context),
                    ),
                    const AppGap(AppSpacing.sm),
                    const _OrDivider(),
                    const AppGap(AppSpacing.sm),
                    AppButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.createAccount),
                      label: AuthStrings.createAccountButton,
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                      isFullWidth: true,
                    ),
                    const AppGap(AppSpacing.sm),
                    _SignInPrompt(
                      onSignIn: () =>
                          Navigator.pushNamed(context, AppRoutes.signIn),
                    ),
                  ],
                ),
              ),
              // Pushes Terms to the bottom across all screen sizes.
              const Spacer(flex: 2),
              const SafeArea(
                top: false,
                left: false,
                right: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md),
                    child: _TermsFooter(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Hairline "or" separator with a centered label.
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: AppDivider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            AuthStrings.orDivider,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ),
        const Expanded(child: AppDivider()),
      ],
    );
  }
}

/// "Already have an account?" prompt with a primary-colored Sign In link.
///
/// Rendered as a single horizontal line — the prefix text never wraps.
class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AuthStrings.alreadyHaveAccount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.appColors.textSecondary,
          ),
          softWrap: false,
        ),
        const SizedBox(width: AppSpacing.xxs),
        TextButton(
          onPressed: onSignIn,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          child: Text(
            AuthStrings.signInButton,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Static terms and privacy confirmation.
class _TermsFooter extends StatelessWidget {
  const _TermsFooter();

  @override
  Widget build(BuildContext context) {
    return Text(
      AuthStrings.termsFooter,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: context.appColors.textDisabled,
        height: 1.5,
      ),
    );
  }
}
