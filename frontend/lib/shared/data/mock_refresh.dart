/// Simulated network refresh shared by mock-driven screens.
///
/// Returns a future that resolves after [delay] to mimic the latency of a
/// remote data fetch so [RefreshIndicator] has a visible settling state during
/// development. Replaced by real repository calls once APIs are available.
Future<void> mockRefresh({Duration delay = const Duration(milliseconds: 900)}) {
  return Future<void>.delayed(delay);
}
