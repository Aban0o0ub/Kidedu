part of 'course_category_cubit.dart'; // ✅ يجب أن يكون السطر الوحيد

@immutable
sealed class CourseCategoryState {}

final class CourseCategoryInitial extends CourseCategoryState {}

final class CourseCategoryLoading extends CourseCategoryState {}

final class GetCourseByCategorySuccess extends CourseCategoryState {
  final CourseModel newCourse;
  GetCourseByCategorySuccess(this.newCourse);
}

final class GetCourseByCategoryFailure extends CourseCategoryState {
  final String error;
  GetCourseByCategoryFailure(this.error);
}
