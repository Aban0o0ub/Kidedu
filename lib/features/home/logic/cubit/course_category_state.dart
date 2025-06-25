part of 'course_category_cubit.dart';

@immutable
sealed class CourseCategoryState {}

final class CourseCategoryInitial extends CourseCategoryState {}

final class CourseCategoryLoading extends CourseCategoryState {}

final class GetCourseByCategorySuccess extends CourseCategoryState {
  final List<CourseData> courses;
  GetCourseByCategorySuccess(this.courses);
}

final class GetCourseByCategoryFailure extends CourseCategoryState {
  final String error;
  GetCourseByCategoryFailure(this.error);
}
/////////////////////////////////////////////////////////////////////////////
final class GetKidCoursesLoading extends CourseCategoryState {}

final class GetKidCoursesSuccess extends CourseCategoryState {
  final List<CourseData> kidCourses;
  GetKidCoursesSuccess(this.kidCourses);
}

final class GetKidCoursesFailure extends CourseCategoryState {
  final String error;
  GetKidCoursesFailure(this.error);
}
//////////////////////////////////////////////////////////////////////////////

final class TrendingCoursesLoading extends CourseCategoryState {}

final class GetTrendingCourseSuccess extends CourseCategoryState {
  final List<CourseData> courses;
  GetTrendingCourseSuccess(this.courses);
}

final class GetTrendingCourseFailure extends CourseCategoryState {
  final String error;
  GetTrendingCourseFailure(this.error);
}
/////////////////////////////////////////////////////////////////////////////

final class AllCoursesLoading extends CourseCategoryState {}

final class GetAllCourseSuccess extends CourseCategoryState {
  final List<CourseData> allCourses;
  GetAllCourseSuccess(this.allCourses);
}

final class GetAllCourseFailure extends CourseCategoryState {
  final String error;
  GetAllCourseFailure(this.error);
}