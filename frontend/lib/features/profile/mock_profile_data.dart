/// Temporary identity data backing the Profile screen.
///
/// These values are mock data used only for UI development. They are replaced
/// by the authentication and profile endpoints in a later phase, so screens
/// must never branch on this module's specifics.
library;

abstract final class MockProfileData {
  /// Mock learner display name, kept in sync with the Home greeting.
  static const String displayName = 'Rina';

  /// Mock learner email shown in the identity card.
  static const String email = 'rina@mentorinaja.id';
}
