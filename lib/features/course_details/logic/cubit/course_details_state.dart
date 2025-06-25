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
//////////////////////////////////////////////////////////////////////
final class EndCourseLoading extends CourseDetailsState {}

class EndCourseSuccess extends CourseDetailsState {
final EndCourseResponse endcourse;
  EndCourseSuccess(this.endcourse);
}

class EndCourseFailure extends CourseDetailsState {
  final String error;

  EndCourseFailure(this.error);
}
