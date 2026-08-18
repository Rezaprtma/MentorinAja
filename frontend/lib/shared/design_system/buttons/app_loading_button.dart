//**
// frontend/shared/design_system/buttons/app_loading_button.dart
//
// frontend:
// Design system widget. Menyediakan reusable UI components.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
import 'package:flutter/material.dart';

import 'app_button.dart';

class AppLoadingButton extends StatelessWidget {
  const AppLoadingButton({
    super.key,
    required this.label,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      variant: variant,
      size: size,
      isFullWidth: isFullWidth,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      onPressed: null,
      isLoading: true,
    );
  }
}
