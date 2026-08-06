import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic color set that adapts to the active theme.
///
/// Material 3's [ColorScheme] already covers primary/secondary/error and
/// surfaces. [AppThemeExtension] adds the product-specific roles that are not
/// part of [ColorScheme] — success, warning, info, card, divider, border, and
/// the text tones — so the whole app reads a consistent palette from one typed
/// place and every color still switches correctly between light and dark.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.background,
    required this.card,
    required this.onCard,
    required this.divider,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
  });

  /// Page background.
  final Color background;

  /// Elevated card surface.
  final Color card;
  final Color onCard;

  /// Hairline dividers.
  final Color divider;

  /// Structural borders.
  final Color border;

  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  /// Light-mode semantic palette.
  static const AppThemeExtension light = AppThemeExtension(
    background: AppColors.background,
    card: AppColors.card,
    onCard: AppColors.onCard,
    divider: AppColors.divider,
    border: AppColors.border,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textDisabled: AppColors.textDisabled,
    success: AppColors.success,
    onSuccess: AppColors.onSuccess,
    successContainer: AppColors.successContainer,
    onSuccessContainer: AppColors.onSuccessContainer,
    warning: AppColors.warning,
    onWarning: AppColors.onWarning,
    warningContainer: AppColors.warningContainer,
    onWarningContainer: AppColors.onWarningContainer,
    info: AppColors.info,
    onInfo: AppColors.onInfo,
    infoContainer: AppColors.infoContainer,
    onInfoContainer: AppColors.onInfoContainer,
  );

  /// Dark-mode semantic palette.
  static const AppThemeExtension dark = AppThemeExtension(
    background: AppDarkColors.background,
    card: AppDarkColors.card,
    onCard: AppDarkColors.onCard,
    divider: AppDarkColors.divider,
    border: AppDarkColors.border,
    textPrimary: AppDarkColors.textPrimary,
    textSecondary: AppDarkColors.textSecondary,
    textDisabled: AppDarkColors.textDisabled,
    success: AppDarkColors.success,
    onSuccess: AppDarkColors.onSuccess,
    successContainer: AppDarkColors.successContainer,
    onSuccessContainer: AppDarkColors.onSuccessContainer,
    warning: AppDarkColors.warning,
    onWarning: AppDarkColors.onWarning,
    warningContainer: AppDarkColors.warningContainer,
    onWarningContainer: AppDarkColors.onWarningContainer,
    info: AppDarkColors.info,
    onInfo: AppDarkColors.onInfo,
    infoContainer: AppDarkColors.infoContainer,
    onInfoContainer: AppDarkColors.onInfoContainer,
  );

  @override
  AppThemeExtension copyWith({
    Color? background,
    Color? card,
    Color? onCard,
    Color? divider,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return AppThemeExtension(
      background: background ?? this.background,
      card: card ?? this.card,
      onCard: onCard ?? this.onCard,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      onCard: Color.lerp(onCard, other.onCard, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
    );
  }
}
