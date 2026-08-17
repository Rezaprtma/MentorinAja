/// Course feature public API.
///
/// Import this barrel for the shared course detail experience, its entities,
/// the live progress store and the mock repositories.
library;

export 'application/learning_progress_controller.dart';
export 'data/mock_course_catalog.dart';
export 'data/mock_course_repository.dart';
export 'data/mock_progress_repository.dart';
export 'domain/entities/course_detail.dart';
export 'domain/entities/course_lesson.dart';
export 'domain/entities/course_progress.dart';
export 'domain/repositories/course_repository.dart';
export 'domain/repositories/progress_repository.dart';
export 'presentation/pages/course_detail_page.dart';
export 'presentation/widgets/course_identity_header.dart';
export 'presentation/widgets/course_outline_tile.dart';
export 'presentation/widgets/course_summary_card.dart';
