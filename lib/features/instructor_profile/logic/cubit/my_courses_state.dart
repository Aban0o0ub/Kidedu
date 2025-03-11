part of 'my_courses_cubit.dart';

@immutable
sealed class MyCoursesState {}

final class MyCoursesInitial extends MyCoursesState {}

final class MyCoursesLoading extends MyCoursesState {}

final class GetMyCoursesSuccess extends MyCoursesState {
  final List<CourseData> courses;
  GetMyCoursesSuccess(this.courses);
}

final class GetMyCoursesFailure extends MyCoursesState {
  final String error;
  GetMyCoursesFailure(this.error);
}