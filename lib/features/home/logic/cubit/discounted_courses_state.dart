part of 'discounted_courses_cubit.dart';

@immutable
sealed class DiscountedCoursesState {}

final class DiscountedCoursesInitial extends DiscountedCoursesState {}

class DiscountedCoursesLoading extends DiscountedCoursesState {}
class GetDiscountedCourseSuccess extends DiscountedCoursesState {
  final List<CourseData> discountedCourses;
  GetDiscountedCourseSuccess(this.discountedCourses);
}
class GetDiscountedCourseFailure extends DiscountedCoursesState {
  final String error;
  GetDiscountedCourseFailure(this.error);
}