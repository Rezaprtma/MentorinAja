//**
// frontend/features/onboarding/logic/onboarding_controller.dart
//
// frontend:
// Controller. Mengelola state dan business logic untuk feature.
//
// backend:
// Future: akan membutuhkan backend persistence dan API integration.
//
// api:
// Future: akan melakukan API calls melalui repositories.
//
// qa:
// QA perlu memvalidasi state transitions dan edge cases.
//**
import 'package:flutter/foundation.dart';

class OnboardingController extends ChangeNotifier {
  OnboardingController({this.totalPages = 3});

  final int totalPages;

  int _currentPage = 0;

  int get currentPage => _currentPage;

  bool get isLastPage => _currentPage == totalPages - 1;

  bool get isFirstPage => _currentPage == 0;

  void onPageChanged(int page) {
    if (_isDisposed || page == _currentPage) return;
    _currentPage = page;
    notifyListeners();
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
