/// MentorinAja Design System — reusable UI component library.
///
/// Import this barrel to access every design-system widget:
///
/// ```dart
/// import 'package:frontend/shared/design_system/design_system.dart';
/// ```
///
/// Components are grouped by category and consume the design tokens defined in
/// `core/theme/`. They are feature-agnostic, state-management-free and
/// Material 3 compliant.
library;

// -------------------------------------------------------------------------
// Core tokens (re-export for convenience)
// -------------------------------------------------------------------------
export '../../core/theme/theme.dart';

// -------------------------------------------------------------------------
// Animations
// -------------------------------------------------------------------------
export 'animations/app_animated_button.dart';
export 'animations/app_animated_container.dart';
export 'animations/app_fade.dart';
export 'animations/app_scale.dart';

// -------------------------------------------------------------------------
// Avatar
// -------------------------------------------------------------------------
export 'avatar/app_avatar.dart';

// -------------------------------------------------------------------------
// Badges
// -------------------------------------------------------------------------
export 'badges/app_badge.dart';

// -------------------------------------------------------------------------
// Buttons
// -------------------------------------------------------------------------
export 'buttons/app_button.dart';
export 'buttons/app_floating_action_button.dart';
export 'buttons/app_icon_button.dart';
export 'buttons/app_loading_button.dart';

// -------------------------------------------------------------------------
// Cards
// -------------------------------------------------------------------------
export 'cards/app_base_card.dart';
export 'cards/app_course_card.dart';
export 'cards/app_elevated_card.dart';
export 'cards/app_info_card.dart';
export 'cards/app_outlined_card.dart';
export 'cards/app_stat_card.dart';

// -------------------------------------------------------------------------
// Chips
// -------------------------------------------------------------------------
export 'chips/app_chips.dart';

// -------------------------------------------------------------------------
// Dialogs
// -------------------------------------------------------------------------
export 'dialogs/app_alert_dialog.dart';
export 'dialogs/app_bottom_sheet.dart';
export 'dialogs/app_confirmation_dialog.dart';
export 'dialogs/app_loading_dialog.dart';

// -------------------------------------------------------------------------
// Extensions
// -------------------------------------------------------------------------
export 'extensions/context_extensions.dart';

// -------------------------------------------------------------------------
// Feedback
// -------------------------------------------------------------------------
export 'feedback/app_banner.dart';
export 'feedback/app_snack_bar.dart';
export 'feedback/app_toast.dart';

// -------------------------------------------------------------------------
// Inputs
// -------------------------------------------------------------------------
export 'inputs/app_checkbox.dart';
export 'inputs/app_dropdown_field.dart';
export 'inputs/app_multiline_field.dart';
export 'inputs/app_otp_field.dart';
export 'inputs/app_radio.dart';
export 'inputs/app_search_field.dart';
export 'inputs/app_switch.dart';
export 'inputs/app_text_field.dart';

// -------------------------------------------------------------------------
// Layout
// -------------------------------------------------------------------------
export 'layout/app_container.dart';
export 'layout/app_divider.dart';
export 'layout/app_gap.dart';
export 'layout/app_safe_area.dart';
export 'layout/app_scrollable_page.dart';
export 'layout/app_section.dart';

// -------------------------------------------------------------------------
// Lists
// -------------------------------------------------------------------------
export 'lists/app_course_tile.dart';
export 'lists/app_profile_tile.dart';
export 'lists/app_settings_tile.dart';
export 'lists/app_tile.dart';

// -------------------------------------------------------------------------
// Loaders
// -------------------------------------------------------------------------
export 'loaders/app_circular_loader.dart';
export 'loaders/app_empty_state.dart';
export 'loaders/app_linear_loader.dart';
export 'loaders/app_shimmer.dart';
export 'loaders/app_skeleton.dart';

// -------------------------------------------------------------------------
// Navigation
// -------------------------------------------------------------------------
export 'navigation/app_app_bar.dart';
export 'navigation/app_bottom_navigation.dart';
export 'navigation/app_page_header.dart';
export 'navigation/app_section_header.dart';
