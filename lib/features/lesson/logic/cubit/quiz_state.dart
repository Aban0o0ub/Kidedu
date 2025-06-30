part of 'quiz_cubit.dart';

@immutable
sealed class QuizState {}

final class QuizInitial extends QuizState {}

final class AddQuizLoading extends QuizState {}

class AddQuizSuccess extends QuizState {
  final AddQuizResponse newQuiz;

  AddQuizSuccess(this.newQuiz);
}

class AddQuizFailure extends QuizState {
  final String error;

  AddQuizFailure(this.error);
}
///////////////////////////////////////////////////////////////////////
final class SubmitQuizLoading extends QuizState {}

class SubmitQuizSuccess extends QuizState {
  final SubmitQuizResponse submitQuiz;

  SubmitQuizSuccess(this.submitQuiz);
}

class SubmitQuizFailure extends QuizState {
  final String error;

  SubmitQuizFailure(this.error);
}
////////////////////////////////////////////////////////////////////////
final class GetQuizzesLoading extends QuizState {}

class GetQuizzesSuccess extends QuizState {
 final List<QuizListItem> quizzes;

  GetQuizzesSuccess(this.quizzes);
}

class GetQuizzesFailure extends QuizState {
  final String error;

  GetQuizzesFailure(this.error);
}