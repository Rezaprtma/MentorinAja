/// Bottom-sheet builders for the Profile tab preferences.
///
/// [showThemeSheet] hosts the color-mode picker driven by
/// [ThemeModeController], [showNotificationSettingsSheet] hosts the local
/// notification toggles, and [showLanguageSheet] presents the language picker.
/// All three are thin helpers that reuse [AppBottomSheet] and the design-system
/// radio/switch components without carrying page state.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Displays the theme selection sheet and applies the chosen mode.
///
/// The sheet observes [ThemeModeController.instance] so the icon-based options
/// track the active mode live, then records new choices through the same
/// controller. Each option leads with its semantic icon — sun, moon, system —
/// and the selected icon adopts the brand active color.
Future<void> showThemeSheet(BuildContext context) {
  return AppBottomSheet.show(
    context,
    title: 'Tema',
    subtitle: 'Pilih tampilan aplikasi.',
    child: AnimatedBuilder(
      animation: ThemeModeController.instance,
      builder: (context, _) {
        final mode = ThemeModeController.instance.mode;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ThemeModeOption(
              icon: Icons.light_mode_rounded,
              label: 'Terang',
              selected: mode == ThemeMode.light,
              onTap: () =>
                  ThemeModeController.instance.setMode(ThemeMode.light),
            ),
            const SizedBox(height: AppSpacing.xs),
            _ThemeModeOption(
              icon: Icons.dark_mode_rounded,
              label: 'Gelap',
              selected: mode == ThemeMode.dark,
              onTap: () => ThemeModeController.instance.setMode(ThemeMode.dark),
            ),
            const SizedBox(height: AppSpacing.xs),
            _ThemeModeOption(
              icon: Icons.brightness_auto_rounded,
              label: 'Ikuti Sistem',
              selected: mode == ThemeMode.system,
              onTap: () =>
                  ThemeModeController.instance.setMode(ThemeMode.system),
            ),
          ],
        );
      },
    ),
  );
}

/// Displays the notification preference sheet.
///
/// Holds the same local toggle state the former page did — persistence is
/// deliberately not invented in this phase.
Future<void> showNotificationSettingsSheet(BuildContext context) {
  return AppBottomSheet.show(
    context,
    title: 'Notifikasi',
    subtitle: 'Atur notifikasi yang ingin kamu terima.',
    child: const _NotificationSettingsSheet(),
  );
}

/// Displays the language selection sheet.
///
/// Bahasa Indonesia is the active product language; other locales are marked
/// as planned so the list stays honest without inventing a translation
/// pipeline.
Future<void> showLanguageSheet(BuildContext context) {
  return AppBottomSheet.show(
    context,
    title: 'Bahasa',
    subtitle: 'Pilih bahasa aplikasi.',
    child: const AppRadioGroup<String>(
      groupValue: 'id',
      onChanged: _noop,
      options: [
        AppRadioOption(value: 'id', label: 'Bahasa Indonesia'),
        AppRadioOption(
          value: 'en',
          label: 'English',
          subtitle: 'Segera hadir.',
          enabled: false,
        ),
      ],
    ),
  );
}

void _noop(String? value) {}

/// Renders the Indonesian label for the active [ThemeMode].
///
/// Shared by the theme sheet and the Preferensi row so a single source keeps
/// the picker and the page's current-value label in sync.
String themeModeLabel(ThemeMode mode) => switch (mode) {
  ThemeMode.light => 'Terang',
  ThemeMode.dark => 'Gelap',
  ThemeMode.system => 'Ikuti Sistem',
};

/// Local toggle state for the notification preference sheet.
class _NotificationSettingsSheet extends StatefulWidget {
  const _NotificationSettingsSheet();

  @override
  State<_NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState
    extends State<_NotificationSettingsSheet> {
  bool _courseUpdates = true;
  bool _studyReminders = true;
  bool _achievements = true;
  bool _latestNews = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSwitch(
            value: _courseUpdates,
            onChanged: (value) => setState(() => _courseUpdates = value),
            label: 'Pembaruan Course',
          ),
          AppSwitch(
            value: _studyReminders,
            onChanged: (value) => setState(() => _studyReminders = value),
            label: 'Pengingat Belajar',
          ),
          AppSwitch(
            value: _achievements,
            onChanged: (value) => setState(() => _achievements = value),
            label: 'Pencapaian & Progress',
          ),
          AppSwitch(
            value: _latestNews,
            onChanged: (value) => setState(() => _latestNews = value),
            label: 'Kabar Terbaru',
          ),
        ],
      ),
    );
  }
}

class _ThemeModeOption extends StatelessWidget {
  const _ThemeModeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? scheme.primary : ext.textDisabled,
              size: AppIconSizes.lg,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTypeScale.bodyLarge.copyWith(
                color: ext.textPrimary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
