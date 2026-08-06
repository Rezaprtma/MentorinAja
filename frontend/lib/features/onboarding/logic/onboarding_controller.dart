import 'package:flutter/foundation.dart';

/// Manages onboarding page state and navigation decisions.
///
/// Exposes immutable snapshots for the UI layer. Performs no widget
/// operations — pure state holder.
class OnboardingController extends ChangeNotifier {
  OnboardingController({this.totalPages = 3});

  final int totalPages;

  int _currentPage = 0;

  /// Zero-based index of the visible page.
  int get currentPage => _currentPage;

  /// Whether the current page is the last page.
  bool get isLastPage => _currentPage == totalPages - 1;

  /// Whether the current page is the first page.
  bool get isFirstPage => _currentPage == 0;

  /// Updates the current page when the [PageController] reports a change.
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
