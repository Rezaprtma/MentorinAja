//**
// frontend/features/auth/logic/verification_request_controller.dart
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

class VerificationRequestController extends ChangeNotifier {
  VerificationRequestController({
    this.processingDelay = const Duration(milliseconds: 450),
  });

  final Duration processingDelay;

  bool _isProcessing = false;
  bool _disposed = false;

  bool get isProcessing => _isProcessing;

  Future<bool> proceed() async {
    _setProcessing(true);
    await Future<void>.delayed(processingDelay);
    if (_disposed) return false;
    _setProcessing(false);
    return true;
  }

  void _setProcessing(bool value) {
    if (_isProcessing == value) return;
    _isProcessing = value;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
