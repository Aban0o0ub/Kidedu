part of 'lesson_cubit.dart';


@immutable
sealed class LessonState {}

final class LessonInitial extends LessonState {}

final class AddLessonLoading extends LessonState {}

class AddLessonSuccess extends LessonState {
  final LessonResponse newLesson;

  AddLessonSuccess(this.newLesson);
}

class AddLessonFailure extends LessonState {
  final String error;

  AddLessonFailure(this.error);
}
////////////////////////////////////////////////////////////////////////
final class GetLessonLoading extends LessonState {}

class GetLessonSuccess extends LessonState {
  final LessonListResponse response;

  GetLessonSuccess(this.response);
}

class GetLessonFailure extends LessonState {
  final String error;

  GetLessonFailure(this.error);
}