import '../entities/tutor_message.dart';

/// Repository seam for future AI Tutor integration.
abstract interface class TutorRepository {
  /// Produces the assistant reply for [message] within [context].
  Future<TutorMessage> reply({
    required TutorLessonContext context,
    required String message,
  });
}
