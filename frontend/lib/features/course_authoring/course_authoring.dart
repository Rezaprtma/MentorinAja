//**
// frontend/features/course_authoring/course_authoring.dart
//
// frontend:
// Source file. Bagian dari MentorinAja frontend.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi file behavior sesuai dengan purpose.
//**
library;

export 'data/mock_course_authoring_repository.dart';
export 'domain/entities/course_authoring_draft.dart';
export 'domain/entities/draft_status.dart';
export 'domain/entities/lesson_draft.dart';
export 'domain/entities/publish_validation.dart';
export 'domain/repositories/course_authoring_repository.dart';
export 'logic/authoring_preview_adapter.dart';
export 'presentation/pages/course_create_page.dart';
export 'presentation/pages/course_editor_page.dart';
export 'presentation/pages/course_list_page.dart';
export 'presentation/pages/lesson_editor_page.dart';
export 'presentation/widgets/publish_validation_panel.dart';
