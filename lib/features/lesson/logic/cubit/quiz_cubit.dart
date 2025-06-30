import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../data/models/quiz.dart';
import '../../data/repo/quiz_repo.dart';
part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final QuizRepo quizRepo;
  QuizCubit(this.quizRepo) : super(QuizInitial());

  Future<void> emitAddQuiz(AddQuizRequest request) async {
    emit(AddQuizLoading());

    try {
      final response = await quizRepo.addQuiz(request);
      emit(AddQuizSuccess(response));
    } catch (e) {
      emit(AddQuizFailure(e.toString()));
    }
  }

  Future<void> emitSubmitQuiz(SubmitQuizRequest request) async {
    emit(SubmitQuizLoading());

    try {
      final response = await quizRepo.submitQuiz(request);
      emit(SubmitQuizSuccess(response));
    } catch (e) {
      emit(SubmitQuizFailure(e.toString()));
    }
  }

  Future<void> emitGetQuizzes(String lessonId) async {
    emit(GetQuizzesLoading());

    try {
      final quizzes = await quizRepo.getQuizzes(lessonId);
      emit(GetQuizzesSuccess(quizzes.quizzes));
    } catch (e) {
      emit(GetQuizzesFailure(e.toString()));
    }
  }
}
