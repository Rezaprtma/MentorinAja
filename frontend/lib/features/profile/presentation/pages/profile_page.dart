/// Profile tab root — the learner's account and settings.
///
/// Leads with the centered [ProfileIdentity], then groups settings into
/// Preferensi, Dukungan, and Legal sections rendered by
/// [ProfileSettingsSection], and ends with a destructive sign-out row. Mock
/// actions surface through [AppNotificationService] toasts; the Tema row
/// reflects the app-wide [ThemeModeController] state and reopens the picker.
/// The page scrolls, supports pull-to-refresh through the shared [mockRefresh]
/// seam, and constrains itself with [ResponsiveContainer] for tablets and
/// desktops.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/data/mock_refresh.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../mock_profile_data.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_identity.dart';
import '../widgets/profile_setting_row.dart';
import '../widgets/profile_settings_section.dart';
import '../widgets/profile_sheets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.onSignOut});

  /// Confirms sign-out; when null a mock success toast is shown instead.
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: AppSafeArea(
        child: RefreshIndicator(
          onRefresh: mockRefresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.xxxl + AppSpacing.md,
            ),
            child: ResponsiveContainer(
              maxWidth: 720,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsivePadding.horizontal(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ProfileHeader(),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileIdentity(
                    displayName: MockProfileData.displayName,
                    email: MockProfileData.email,
                    onEdit: () => _mockToast(context, 'Edit Profil'),
                  ),
                  ProfileSettingsSection(
                    title: 'Preferensi',
                    rows: [
                      AnimatedBuilder(
                        animation: ThemeModeController.instance,
                        builder: (context, _) => ProfileSettingRow(
                          icon: Icons.dark_mode_outlined,
                          title: 'Tema',
                          value: themeModeLabel(
                            ThemeModeController.instance.mode,
                          ),
                          onTap: () => showThemeSheet(context),
                        ),
                      ),
                      ProfileSettingRow(
                        icon: Icons.notifications_outlined,
                        title: 'Notifikasi',
                        onTap: () => _mockToast(context, 'Notifikasi'),
                      ),
                      ProfileSettingRow(
                        icon: Icons.language_outlined,
                        title: 'Bahasa',
                        value: 'Bahasa Indonesia',
                        onTap: () => _mockToast(context, 'Bahasa'),
                      ),
                    ],
                  ),
                  ProfileSettingsSection(
                    title: 'Dukungan',
                    rows: [
                      ProfileSettingRow(
                        icon: Icons.feedback_outlined,
                        title: 'Masukan & Saran',
                        onTap: () => _mockToast(context, 'Masukan & Saran'),
                      ),
                      ProfileSettingRow(
                        icon: Icons.help_outline,
                        title: 'Pusat Bantuan',
                        onTap: () => _mockToast(context, 'Pusat Bantuan'),
                      ),
                      ProfileSettingRow(
                        icon: Icons.info_outline,
                        title: 'Tentang MentorinAja',
                        onTap: () => showAboutSheet(context),
                      ),
                    ],
                  ),
                  ProfileSettingsSection(
                    title: 'Legal',
                    rows: [
                      ProfileSettingRow(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Kebijakan Privasi',
                        onTap: () => _mockToast(context, 'Kebijakan Privasi'),
                      ),
                      ProfileSettingRow(
                        icon: Icons.article_outlined,
                        title: 'Kebijakan Pengguna',
                        onTap: () => _mockToast(context, 'Kebijakan Pengguna'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xl),
                    child: ProfileSettingRow(
                      icon: Icons.logout,
                      title: 'Keluar',
                      destructive: true,
                      showChevron: false,
                      onTap: () => _confirmSignOut(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Keluar dari Akun?',
      message: 'Kamu akan kembali ke layar masuk.',
      confirmLabel: 'Keluar',
      cancelLabel: 'Batal',
      isDestructive: true,
    );
    if (!confirmed || !context.mounted) return;
    if (onSignOut != null) {
      onSignOut!();
      return;
    }
    AppToast.show(
      context,
      title: 'Berhasil Keluar',
      message: 'Kamu telah keluar dari akun (simulasi).',
      severity: AppFeedbackSeverity.success,
    );
  }

  void _mockToast(BuildContext context, String feature) {
    AppToast.show(
      context,
      title: feature,
      message: 'Fitur ini sedang dalam pengembangan.',
      severity: AppFeedbackSeverity.info,
    );
  }
}
