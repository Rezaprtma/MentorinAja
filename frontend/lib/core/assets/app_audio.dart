//**
// frontend/core/assets/app_audio.dart
//
// frontend:
// Asset management. Menyediakan paths dan konfigurasi untuk icons, images, fonts.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi asset loading dan rendering.
//**
abstract final class AppAudio {
  const AppAudio._();

  static const String sfxClick = 'assets/audio/sfx/click.mp3';

  static const String sfxSuccess = 'assets/audio/sfx/success.mp3';

  static const String sfxError = 'assets/audio/sfx/error.mp3';

  static const String sfxAchievement = 'assets/audio/sfx/achievement.mp3';

  static const String sfxLevelUp = 'assets/audio/sfx/level_up.mp3';

  static const String sfxNotification = 'assets/audio/sfx/notification.mp3';

  static const String sfxStreak = 'assets/audio/sfx/streak.mp3';

  static const String sfxCorrect = 'assets/audio/sfx/correct.mp3';

  static const String sfxWrong = 'assets/audio/sfx/wrong.mp3';

  static const String sfxPageTurn = 'assets/audio/sfx/page_turn.mp3';

  static const String musicIntro = 'assets/audio/music/intro.mp3';

  static const String musicHome = 'assets/audio/music/home.mp3';

  static const String musicLearning = 'assets/audio/music/learning.mp3';

  static const String musicFocus = 'assets/audio/music/focus.mp3';

  static const String musicCelebration = 'assets/audio/music/celebration.mp3';

  static const String voiceWelcome = 'assets/audio/voice/welcome.mp3';

  static const String voiceOnboarding = 'assets/audio/voice/onboarding.mp3';

  static const String ambientStudy = 'assets/audio/ambient/study.mp3';

  static const String ambientNature = 'assets/audio/ambient/nature.mp3';

  static const String ambientCoffeeShop =
      'assets/audio/ambient/coffee_shop.mp3';

  static const String notifPush = 'assets/audio/notification/push.mp3';

  static const String notifReminder = 'assets/audio/notification/reminder.mp3';

  static const String notifAchievement =
      'assets/audio/notification/achievement.mp3';
}
