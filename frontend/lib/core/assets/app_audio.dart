/// Audio asset paths organized by category.
///
/// No audio playback is implemented — this is pure architecture. When an
/// audio package is added, `AppAudioPlayer` wrapper handles playback.
///
/// Asset files do not exist yet. Add them under `assets/audio/` and the
/// constants resolve automatically.
abstract final class AppAudio {
  const AppAudio._();

  // -------------------------------------------------------------------------
  // Sound effects (SFX)
  // -------------------------------------------------------------------------

  /// Button click feedback.
  static const String sfxClick = 'assets/audio/sfx/click.mp3';

  /// Success chime.
  static const String sfxSuccess = 'assets/audio/sfx/success.mp3';

  /// Error buzz.
  static const String sfxError = 'assets/audio/sfx/error.mp3';

  /// Achievement fanfare.
  static const String sfxAchievement = 'assets/audio/sfx/achievement.mp3';

  /// Level up sound.
  static const String sfxLevelUp = 'assets/audio/sfx/level_up.mp3';

  /// Notification ping.
  static const String sfxNotification = 'assets/audio/sfx/notification.mp3';

  /// Streak maintained.
  static const String sfxStreak = 'assets/audio/sfx/streak.mp3';

  /// Quiz correct answer.
  static const String sfxCorrect = 'assets/audio/sfx/correct.mp3';

  /// Quiz wrong answer.
  static const String sfxWrong = 'assets/audio/sfx/wrong.mp3';

  /// Page turn.
  static const String sfxPageTurn = 'assets/audio/sfx/page_turn.mp3';

  // -------------------------------------------------------------------------
  // Music
  // -------------------------------------------------------------------------

  /// Background music for splash / onboarding.
  static const String musicIntro = 'assets/audio/music/intro.mp3';

  /// Background music for home / dashboard.
  static const String musicHome = 'assets/audio/music/home.mp3';

  /// Background music for learning / course.
  static const String musicLearning = 'assets/audio/music/learning.mp3';

  /// Background music for quiz (focus mode).
  static const String musicFocus = 'assets/audio/music/focus.mp3';

  /// Celebration music.
  static const String musicCelebration = 'assets/audio/music/celebration.mp3';

  // -------------------------------------------------------------------------
  // Voice / narration
  // -------------------------------------------------------------------------

  /// Welcome voiceover.
  static const String voiceWelcome = 'assets/audio/voice/welcome.mp3';

  /// Onboarding narration.
  static const String voiceOnboarding = 'assets/audio/voice/onboarding.mp3';

  // -------------------------------------------------------------------------
  // Ambient
  // -------------------------------------------------------------------------

  /// Subtle ambient sound for study mode.
  static const String ambientStudy = 'assets/audio/ambient/study.mp3';

  /// Nature ambience.
  static const String ambientNature = 'assets/audio/ambient/nature.mp3';

  /// Coffee shop ambience.
  static const String ambientCoffeeShop =
      'assets/audio/ambient/coffee_shop.mp3';

  // -------------------------------------------------------------------------
  // Notifications
  // -------------------------------------------------------------------------

  /// Push notification sound.
  static const String notifPush = 'assets/audio/notification/push.mp3';

  /// Reminder sound.
  static const String notifReminder = 'assets/audio/notification/reminder.mp3';

  /// Achievement notification.
  static const String notifAchievement =
      'assets/audio/notification/achievement.mp3';
}
