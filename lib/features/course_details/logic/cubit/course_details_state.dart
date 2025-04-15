part of 'course_details_cubit.dart';

@immutable
sealed class CourseDetailsState {}

final class CourseDetailsInitial extends CourseDetailsState {}

final class CourseDetailsLoading extends CourseDetailsState {}

class GetCourseSuccess extends CourseDetailsState {
final CourseData course;
  GetCourseSuccess(this.course);
}

class GetCourseFailure extends CourseDetailsState {
  final String error;

  GetCourseFailure(this.error);
}
