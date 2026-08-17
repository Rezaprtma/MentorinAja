/// Profile tab root — the learner's account and settings.
///
/// Leads with the centered [ProfileIdentity] fed by [ProfileController], then
/// groups settings into Preferensi, Dukungan, and Legal sections rendered by
/// [ProfileSettingsSection], and ends with a destructive sign-out row. Edit
/// Profil opens the focused editor; remaining mock actions surface through
/// [AppNotificationService] toasts; the Preferensi rows open lightweight
/// bottom sheets ([showThemeSheet], [showNotificationSettingsSheet],
/// [showLanguageSheet]) while content-heavy support and legal pages navigate
/// normally. The page scrolls, supports pull-to-refresh through the shared
/// [mockRefresh] seam, and constrains itself with [ResponsiveContainer] for
/// tablets and desktops.
library;

import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/data/mock_refresh.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../logic/profile_controller.dart';
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
                  AnimatedBuilder(
                    animation: ProfileController.instance,
                    builder: (context, _) {
                      final profile = ProfileController.instance;
                      return ProfileIdentity(
                        username: profile.username,
                        email: profile.email,
                        photoUrl: profile.photoUrl,
                        onEdit: () => _open(context, AppRoutes.editProfile),
                      );
                    },
                  ),
                  if (ProfileController.instance.isMentor) ...[
                    ProfileSettingsSection(
                      title: 'Mentor',
                      rows: [
                        ProfileSettingRow(
                          icon: Icons.school_outlined,
                          title: 'Kelola Course',
                          onTap: () => _open(context, AppRoutes.mentorCourses),
                        ),
                      ],
                    ),
                  ],
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
                        onTap: () => showNotificationSettingsSheet(context),
                      ),
                      ProfileSettingRow(
                        icon: Icons.language_outlined,
                        title: 'Bahasa',
                        value: 'Bahasa Indonesia',
                        onTap: () => showLanguageSheet(context),
                      ),
                    ],
                  ),
                  ProfileSettingsSection(
                    title: 'Dukungan',
                    rows: [
                      ProfileSettingRow(
                        icon: Icons.feedback_outlined,
                        title: 'Masukan & Saran',
                        onTap: () => _open(context, AppRoutes.feedback),
                      ),
                      ProfileSettingRow(
                        icon: Icons.help_outline,
                        title: 'Pusat Bantuan',
                        onTap: () => _open(context, AppRoutes.helpCenter),
                      ),
                      ProfileSettingRow(
                        icon: Icons.info_outline,
                        title: 'Tentang MentorinAja',
                        onTap: () => _open(context, AppRoutes.about),
                      ),
                    ],
                  ),
                  ProfileSettingsSection(
                    title: 'Legal',
                    rows: [
                      ProfileSettingRow(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Kebijakan Privasi',
                        onTap: () => _open(context, AppRoutes.privacyPolicy),
                      ),
                      ProfileSettingRow(
                        icon: Icons.article_outlined,
                        title: 'Kebijakan Pengguna',
                        onTap: () => _open(context, AppRoutes.userPolicy),
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

  void _open(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }
}
