/// Lesson feature public API.
///
/// Import this barrel for the Lesson Player experience: the player page, the
/// course completion page, the lesson content model and its mock generator.
library;

export 'data/mock_lesson_content.dart';
export 'data/mock_lesson_exercises.dart';
export 'domain/entities/lesson_content.dart';
export 'domain/entities/lesson_exercise.dart';
export 'presentation/pages/course_completed_page.dart';
export 'presentation/pages/course_player_page.dart';
export 'presentation/stages/game_stage.dart';
export 'presentation/stages/latihan_stage.dart';
export 'presentation/stages/lesson_stage.dart';
export 'presentation/stages/materi_stage.dart';
export 'presentation/widgets/lesson_content_block_view.dart';
export 'presentation/widgets/lesson_stage_indicator.dart';
export 'presentation/widgets/exercises/code_completion_exercise.dart';
export 'presentation/widgets/exercises/code_correction_exercise.dart';
export 'presentation/widgets/exercises/code_explanation_exercise.dart';
export 'presentation/widgets/exercises/code_writing_exercise.dart';
export 'presentation/widgets/exercises/lesson_exercise_view.dart';
export 'presentation/widgets/games/code_ordering_game.dart';
export 'presentation/widgets/games/game_view.dart';
export 'presentation/widgets/games/token_completion_game.dart';
export 'presentation/widgets/learning_navigation_bar.dart';
export 'presentation/widgets/stages/stage_intro_card.dart';
