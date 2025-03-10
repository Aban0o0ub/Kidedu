part of 'course_category_cubit.dart'; // ✅ يجب أن يكون السطر الوحيد

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
