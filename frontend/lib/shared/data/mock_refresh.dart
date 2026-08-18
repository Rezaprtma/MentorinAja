//**
// frontend/shared/data/mock_refresh.dart
//
// frontend:
// Shared data. Menyediakan common mock data dan utilities.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi data coverage dan edge cases.
//**
Future<void> mockRefresh({Duration delay = const Duration(milliseconds: 900)}) {
  return Future<void>.delayed(delay);
}
