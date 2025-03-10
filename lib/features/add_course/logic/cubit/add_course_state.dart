part of 'add_course_cubit.dart';

@immutable
sealed class AddCourseState {}

final class AddCourseInitial extends AddCourseState {}

final class AddCourseLoading extends AddCourseState {}

class AddCourseSuccess extends AddCourseState {
  final CourseResponse newCourse;

  AddCourseSuccess(this.newCourse);
}

class AddCourseFailure extends AddCourseState {
  final String error;

  AddCourseFailure(this.error);
}
