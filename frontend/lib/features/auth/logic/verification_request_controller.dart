import 'package:flutter/foundation.dart';

/// State for the authentication entry step.
///
/// Owns the email slice of the flow: whether the "Continue" transition is in
/// progress. It performs no backend work — a future verification service sends
/// the code — it only sequences the UI before navigation to the OTP step.
class VerificationRequestController extends ChangeNotifier {
  VerificationRequestController({
    this.processingDelay = const Duration(milliseconds: 450),
  });

  /// How long the transition is shown as busy so the loading state is visible.
  final Duration processingDelay;

  bool _isProcessing = false;
  bool _disposed = false;

  /// Whether the Continue action is running.
  bool get isProcessing => _isProcessing;

  /// Runs the Continue transition for the entry step.
  ///
  /// Resolves to `true` when navigation to the verification step may proceed.
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
