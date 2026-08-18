//**
// frontend/features/profile/presentation/pages/edit_profile_page.dart
//
// frontend:
// Screen/page. Menampilkan UI dan menerima user interactions.
//
// backend:
// Future: akan membutuhkan backend data dan API calls.
//
// api:
// Future: akan melakukan API calls melalui controllers/repositories.
//
// qa:
// QA perlu memvalidasi UI rendering, user interactions, dan navigation.
//**
import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../logic/profile_controller.dart';
import '../../mock_profile_photos.dart';
import '../widgets/profile_photo_avatar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const int _maxUsernameLength = 30;

  late final ProfileController _profile = ProfileController.instance;
  late final TextEditingController _usernameController = TextEditingController(
    text: _profile.username,
  );
  late final String _originalUsername = _profile.username;
  late final String? _originalPhotoUrl = _profile.photoUrl;

  String? _selectedPhotoUrl;
  String? _usernameError;

  String get _trimmedUsername => _usernameController.text.trim();

  bool get _usernameChanged => _trimmedUsername != _originalUsername;

  bool get _photoChanged => _selectedPhotoUrl != _originalPhotoUrl;

  bool get _hasChanges => _usernameChanged || _photoChanged;

  bool get _isUsernameValid => _trimmedUsername.isNotEmpty;

  bool get _canSave => _hasChanges && _isUsernameValid;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _handleUsernameChanged(String value) {
    setState(() {
      _usernameError = _validateUsername(value);
    });
  }

  String? _validateUsername(String value) {
    if (value.trim().isEmpty) return 'Username tidak boleh kosong.';
    return null;
  }

  Future<void> _pickPhoto() async {
    final photo = await AppBottomSheet.show<ProfilePhoto>(
      context,
      title: 'Ubah Foto Profil',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PhotoOption(
            icon: Icons.photo_library_outlined,
            label: 'Pilih dari Galeri',
            onTap: () => Navigator.of(context).pop(MockProfilePhotos.gallery),
          ),
          const SizedBox(height: AppSpacing.xs),
          _PhotoOption(
            icon: Icons.photo_camera_outlined,
            label: 'Ambil Foto',
            onTap: () => Navigator.of(context).pop(MockProfilePhotos.camera),
          ),
          const SizedBox(height: AppSpacing.xs),
          _PhotoOption(
            icon: Icons.close_rounded,
            label: 'Batal',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
    if (photo != null && mounted) {
      setState(() => _selectedPhotoUrl = photo.id);
    }
  }

  Future<void> _confirmDiscard() async {
    final discard = await AppConfirmationDialog.show(
      context,
      title: 'Batalkan perubahan?',
      message: 'Perubahan yang kamu buat belum disimpan.',
      confirmLabel: 'Buang Perubahan',
      cancelLabel: 'Batal',
      isDestructive: true,
    );
    if (discard && mounted) {
      Navigator.of(context).pop();
    }
  }

  void _save() {
    _profile.updateProfile(
      username: _trimmedUsername,
      photoUrl: _selectedPhotoUrl,
    );
    AppToast.show(
      context,
      title: 'Profil berhasil diperbarui.',
      message: 'Perubahan profilmu sudah tersimpan.',
      severity: AppFeedbackSeverity.success,
    );
    Navigator.of(context).pop();
  }

  Widget _buildAvatar() {
    final scheme = Theme.of(context).colorScheme;
    final previewUsername = _trimmedUsername.isEmpty
        ? _originalUsername
        : _trimmedUsername;
    return Stack(
      children: [
        ProfilePhotoAvatar(
          username: previewUsername,
          photoUrl: _selectedPhotoUrl,
          size: 120,
          borderWidth: 3,
          borderColor: scheme.primary.withValues(alpha: 0.18),
        ),
        Positioned(
          right: 2,
          bottom: 2,
          child: AppIconButton(
            icon: Icons.edit_rounded,
            tooltip: 'Ubah foto profil',
            onPressed: _pickPhoto,
            iconSize: AppIconSizes.md,
            color: scheme.onPrimary,
            backgroundColor: scheme.primary,
            borderColor: context.appColors.background,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _confirmDiscard();
      },
      child: Scaffold(
        backgroundColor: context.appColors.background,
        appBar: const AppAppBar(title: 'Edit Profil'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: AppSpacing.xxl,
            bottom: AppSpacing.xxxl,
          ),
          child: ResponsiveContainer(
            maxWidth: 480,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsivePadding.horizontal(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: _buildAvatar()),
                const SizedBox(height: AppSpacing.xxl),
                AppTextField(
                  controller: _usernameController,
                  label: 'Username',
                  error: _usernameError,
                  maxLength: _maxUsernameLength,
                  textInputAction: TextInputAction.done,
                  onChanged: _handleUsernameChanged,
                  onSubmitted: (_) {
                    if (_canSave) _save();
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Simpan Perubahan',
                  variant: AppButtonVariant.primary,
                  isFullWidth: true,
                  enabled: _canSave,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoOption extends StatelessWidget {
  const _PhotoOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.large),
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        ),
        child: Row(
          children: [
            Icon(icon, size: AppIconSizes.lg, color: scheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.md),
            Text(label, style: AppTypeScale.bodyLarge),
          ],
        ),
      ),
    );
  }
}
