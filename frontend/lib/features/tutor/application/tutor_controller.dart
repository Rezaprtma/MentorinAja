//**
// frontend/features/tutor/application/tutor_controller.dart
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

import '../data/mock_tutor_repository.dart';
import '../domain/entities/tutor_message.dart';
import '../domain/repositories/tutor_repository.dart';

class TutorController extends ChangeNotifier {
  TutorController({
    required TutorLessonContext context,
    TutorRepository? repository,
  }) : _context = context,
       _repository = repository ?? const MockTutorRepository() {
    _messages = [
      TutorMessage(
        role: TutorMessageRole.assistant,
        text:
            'Aku siap bantu di pelajaran ${context.lessonTitle}. Mau jelaskan konsep, cari error, atau minta petunjuk?',
        createdAt: DateTime.now(),
      ),
    ];
  }

  final TutorLessonContext _context;
  final TutorRepository _repository;

  late List<TutorMessage> _messages;
  bool _isThinking = false;

  List<TutorMessage> get messages => List.unmodifiable(_messages);
  bool get isThinking => _isThinking;

  String get contextTitle {
    final stage = _context.stageTitle;
    return stage == null ? 'Tanya sambil belajar.' : 'Membantu $stage';
  }

  bool get conversationStarted => _messages.length > 1;

  static const suggestedPrompts = [
    'Jelaskan bagian ini',
    'Kenapa kode ini error?',
    'Bisa kasih petunjuk?',
    'Aku masih bingung',
  ];

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isThinking) return;

    _messages = [
      ..._messages,
      TutorMessage(
        role: TutorMessageRole.learner,
        text: trimmed,
        createdAt: DateTime.now(),
      ),
    ];
    _isThinking = true;
    notifyListeners();

    final reply = await _repository.reply(context: _context, message: trimmed);
    _messages = [..._messages, reply];
    _isThinking = false;
    notifyListeners();
  }
}
