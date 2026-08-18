//**
// frontend/core/assets/app_icons.dart
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
import 'package:flutter/material.dart';

abstract final class AppIconPaths {
  const AppIconPaths._();

  static const String home = 'assets/icons/home.png';
  static const String homeFilled = 'assets/icons/home_filled.png';
  static const String explore = 'assets/icons/explore.png';
  static const String exploreFilled = 'assets/icons/explore_filled.png';
  static const String courses = 'assets/icons/courses.png';
  static const String coursesFilled = 'assets/icons/courses_filled.png';
  static const String profile = 'assets/icons/profile.png';
  static const String profileFilled = 'assets/icons/profile_filled.png';
  static const String progress = 'assets/icons/progress.png';
  static const String progressFilled = 'assets/icons/progress_filled.png';

  static const String bookmark = 'assets/icons/bookmark.png';
  static const String bookmarkFilled = 'assets/icons/bookmark_filled.png';
  static const String like = 'assets/icons/like.png';
  static const String likeFilled = 'assets/icons/like_filled.png';
  static const String share = 'assets/icons/share.png';
  static const String download = 'assets/icons/download.png';
  static const String downloadFilled = 'assets/icons/download_filled.png';

  static const String certificate = 'assets/icons/certificate.png';
  static const String achievement = 'assets/icons/achievement.png';
  static const String streak = 'assets/icons/streak.png';
  static const String leaderboard = 'assets/icons/leaderboard.png';
  static const String mentor = 'assets/icons/mentor.png';
  static const String quiz = 'assets/icons/quiz.png';
  static const String lesson = 'assets/icons/lesson.png';
  static const String video = 'assets/icons/video.png';
  static const String audio = 'assets/icons/audio.png';
  static const String document = 'assets/icons/document.png';

  static const String techPython = 'assets/icons/language/language-python.svg';
  static const String techPhp = 'assets/icons/language/language-php.svg';
  static const String techMysql = 'assets/icons/language/language-mysql.svg';
  static const String techJavascript =
      'assets/icons/language/language-javascript.svg';
  static const String techTypescript =
      'assets/icons/language/language-typescript.svg';
  static const String techCss = 'assets/icons/language/language-css.svg';
  static const String techLaravel =
      'assets/icons/language/language-laravel.svg';
  static const String techFlutter =
      'assets/icons/language/language-flutter.svg';
  static const String techDart = 'assets/icons/language/language-dart.svg';
  static const String techCpp = 'assets/icons/language/language-c++.svg';
  static const String techJava = 'assets/icons/language/language-java.svg';
  static const String techCsharp = 'assets/icons/language/language-c#.svg';
  static const String techKotlin = 'assets/icons/language/language-kotlin.svg';
  static const String techSwift = 'assets/icons/language/language-swift.svg';
  static const String techNodejs = 'assets/icons/language/language-nodejs.svg';
  static const String techGo = 'assets/icons/language/language-go.svg';
  static const String techPostgresql =
      'assets/icons/language/language-postgresql.svg';
  static const String techSqllite =
      'assets/icons/language/language-sqllite.svg';
  static const String techAngular =
      'assets/icons/language/language-angular.svg';
  static const String techC = 'assets/icons/language/language-c.svg';
  static const String techDjango = 'assets/icons/language/language-django.svg';
  static const String techExpress =
      'assets/icons/language/language-expresjs.svg';
  static const String techHtml = 'assets/icons/language/language-html.svg';
  static const String techNextjs = 'assets/icons/language/language-nextjs.svg';
  static const String techR = 'assets/icons/language/language-r.svg';
  static const String techReact = 'assets/icons/language/language-react.svg';
  static const String techRuby = 'assets/icons/language/language-ruby.svg';
  static const String techRust = 'assets/icons/language/language-rust.svg';
  static const String techSolidity =
      'assets/icons/language/language-solidity.svg';
  static const String techSql = 'assets/icons/language/language-sql.svg';
  static const String techTerminal =
      'assets/icons/language/language-terminal.svg';
  static const String techVuejs = 'assets/icons/language/language-vuejs.svg';

  static const String banner3 = 'assets/icons/banners/banner3.svg';

  static const String sun = 'assets/icons/sun.png';
  static const String moon = 'assets/icons/moon.png';
  static const String settings = 'assets/icons/settings.png';
  static const String notification = 'assets/icons/notification.png';
  static const String search = 'assets/icons/search.png';
  static const String filter = 'assets/icons/filter.png';
  static const String sort = 'assets/icons/sort.png';
  static const String calendar = 'assets/icons/calendar.png';
  static const String clock = 'assets/icons/clock.png';
  static const String check = 'assets/icons/check.png';
  static const String close = 'assets/icons/close.png';
  static const String arrowLeft = 'assets/icons/arrow_left.png';
  static const String arrowRight = 'assets/icons/arrow_right.png';
  static const String chevronDown = 'assets/icons/chevron_down.png';
}

abstract final class AppIcons {
  const AppIcons._();

  static const IconData homeOutlined = Icons.home_outlined;
  static const IconData homeFilled = Icons.home;
  static const IconData exploreOutlined = Icons.explore_outlined;
  static const IconData exploreFilled = Icons.explore;
  static const IconData schoolOutlined = Icons.school_outlined;
  static const IconData schoolFilled = Icons.school;
  static const IconData personOutlined = Icons.person_outlined;
  static const IconData personFilled = Icons.person;
  static const IconData barChartOutlined = Icons.bar_chart_outlined;
  static const IconData barChartFilled = Icons.bar_chart;
  static const IconData bookmarkOutlined = Icons.bookmark_outline;
  static const IconData bookmarkFilled = Icons.bookmark;
  static const IconData favoriteBorder = Icons.favorite_border;
  static const IconData favoriteFilled = Icons.favorite;
  static const IconData shareOutlined = Icons.share_outlined;
  static const IconData downloadOutlined = Icons.download_outlined;
  static const IconData downloadDone = Icons.download_done;
  static const IconData playCircle = Icons.play_circle_outline;
  static const IconData pauseCircle = Icons.pause_circle_outline;
  static const IconData checkCircle = Icons.check_circle_outline;
  static const IconData checkCircleFilled = Icons.check_circle;
  static const IconData errorOutline = Icons.error_outline;
  static const IconData wifiOff = Icons.wifi_off_outlined;
  static const IconData construction = Icons.construction;
  static const IconData search = Icons.search;
  static const IconData filterList = Icons.filter_list;
  static const IconData sort = Icons.sort;
  static const IconData calendarToday = Icons.calendar_today;
  static const IconData schedule = Icons.schedule;
  static const IconData settings = Icons.settings;
  static const IconData notifications = Icons.notifications_none;
  static const IconData darkMode = Icons.dark_mode;
  static const IconData lightMode = Icons.light_mode;
  static const IconData arrowBack = Icons.arrow_back_ios;
  static const IconData arrowForward = Icons.arrow_forward_ios;
  static const IconData chevronLeft = Icons.chevron_left;
  static const IconData chevronRight = Icons.chevron_right;
  static const IconData expandMore = Icons.expand_more;
  static const IconData expandLess = Icons.expand_less;
}
