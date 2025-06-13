import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/lesson.dart';
import '../../data/repo/lesson_repo.dart';
import 'package:flutter/material.dart';
part 'lesson_state.dart';

class LessonCubit extends Cubit<LessonState> {
  final LessonRepo lessonRepo;
  LessonCubit(this.lessonRepo) : super(LessonInitial());

  Future<void> emitAddLesson(LessonCreateRequest request) async {
    emit(AddLessonLoading());

    try {
      final response = await lessonRepo.addLesson(request);
      emit(AddLessonSuccess(response));
    } catch (e) {
      emit(AddLessonFailure(e.toString()));
    }
  }

  Future<void> emitGetLesson(String sectionId) async {
    if (sectionId.isEmpty) {
      emit(GetLessonFailure('Section ID is not available'));
      return;
    }

    emit(GetLessonLoading());
    try {
      final response = await lessonRepo.getLesson(sectionId);
      emit(GetLessonSuccess(response));
    } catch (e) {
      emit(GetLessonFailure(e.toString()));
    }
  }
}
