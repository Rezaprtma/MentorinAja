//**
// frontend/features/auth/presentation/screens/create_account_screen.dart
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
import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';

import '../../logic/auth_strings.dart';
import '../../logic/auth_validators.dart';
import '../../logic/verification_request_controller.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/google_auth_sign_in_button.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  late final VerificationRequestController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VerificationRequestController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_controller.isProcessing) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final acceded = await _controller.proceed();
    if (!mounted || !acceded) return;
    Navigator.pushNamed(
      context,
      AppRoutes.otpVerification,
      arguments: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      maxWidth: 400,
      contentBuilder: (context, constraints) {
        return ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AuthStrings.createTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const AppGap(AppSpacing.xl),
                          AppTextField(
                            controller: _usernameController,
                            label: AuthStrings.usernameLabel,
                            hint: AuthStrings.usernameHint,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [
                              AutofillHints.username,
                              AutofillHints.newUsername,
                            ],
                            prefixIcon: const Icon(Icons.person_outline),
                            showClearButton: true,
                            validator: AuthValidators.username,
                          ),
                          const AppGap(AppSpacing.lg),
                          AppTextField(
                            controller: _emailController,
                            label: AuthStrings.emailLabel,
                            hint: AuthStrings.emailHint,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.email],
                            prefixIcon: const Icon(Icons.mail_outline),
                            showClearButton: true,
                            onSubmitted: (_) => _continue(),
                            validator: AuthValidators.email,
                          ),
                          const AppGap(AppSpacing.xl),
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: AppButton(
                                onPressed: () => _continue(),
                                label: AuthStrings.continueButton,
                                variant: AppButtonVariant.primary,
                                size: AppButtonSize.large,
                                isLoading: _controller.isProcessing,
                              ),
                            ),
                          ),
                          const AppGap(AppSpacing.lg),
                          const _OrDivider(),
                          const AppGap(AppSpacing.lg),
                          const GoogleAuthSignInButton(),
                          const AppGap(AppSpacing.xxl),
                          _AuthBottomLink(
                            prefix: AuthStrings.alreadyHaveAccount,
                            link: AuthStrings.signInButton,
                            onLink: () =>
                                Navigator.pushNamed(context, AppRoutes.signIn),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  const SafeArea(
                    top: false,
                    bottom: true,
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
      },
    );
  }
}

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

class _AuthBottomLink extends StatelessWidget {
  const _AuthBottomLink({
    required this.prefix,
    required this.link,
    required this.onLink,
  });

  final String prefix;
  final String link;
  final VoidCallback onLink;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prefix,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        GestureDetector(
          onTap: onLink,
          child: Text(
            link,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

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
