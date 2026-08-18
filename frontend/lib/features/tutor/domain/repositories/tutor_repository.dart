//**
// frontend/features/tutor/domain/repositories/tutor_repository.dart
//
// frontend:
// Repository interface. Mendefinisikan kontrak data untuk feature.
//
// backend:
// Future: akan diimplementasikan dengan real backend calls.
//
// api:
// Future: akan menjadi integration point untuk backend APIs.
//
// qa:
// QA perlu memvalidasi data flow dan error handling.
//**
import '../entities/tutor_message.dart';

abstract interface class TutorRepository {
  Future<TutorMessage> reply({
    required TutorLessonContext context,
    required String message,
  });
}
