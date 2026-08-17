import 'package:flutter/material.dart';

import '../mock_profile_data.dart';

/// App-wide editable profile state singleton.
///
/// The single source of truth for the learner's username and profile photo,
/// shared by the Profile page and the Edit Profil page. Seeded from
/// [MockProfileData] so both screens agree until the profile API lands. Email
/// stays read-only on this seam.
class ProfileController extends ChangeNotifier {
  ProfileController._();

  /// Shared instance used by the Profile and Edit Profil screens.
  static final ProfileController instance = ProfileController._();

  String _username = MockProfileData.displayName;
  String? _photoUrl;

  /// Current editable username.
  String get username => _username;

  /// Read-only email displayed on the Profile page.
  String get email => MockProfileData.email;

  /// Whether the account holds mentor privileges to manage courses.
  bool get isMentor => true;

  /// Selected profile photo identifier; null when no photo is set.
  String? get photoUrl => _photoUrl;

  /// Persists an edited username and/or photo across the current session.
  ///
  /// Only provided values are applied; username is trimmed before storage.
  /// No-ops when nothing actually changed.
  void updateProfile({String? username, String? photoUrl}) {
    final nextUsername = username?.trim();
    final usernameChanged =
        nextUsername != null &&
        nextUsername.isNotEmpty &&
        nextUsername != _username;
    final photoChanged = photoUrl != null && photoUrl != _photoUrl;
    if (!usernameChanged && !photoChanged) return;

    if (usernameChanged) _username = nextUsername;
    if (photoChanged) _photoUrl = photoUrl;
    notifyListeners();
  }

  /// Restores the seeded defaults (used by tests and previews).
  void reset() {
    _username = MockProfileData.displayName;
    _photoUrl = null;
    notifyListeners();
  }
}
