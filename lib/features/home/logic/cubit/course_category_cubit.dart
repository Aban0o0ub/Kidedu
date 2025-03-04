import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart'; // ✅ استيراد @immutable
import '../../data/Repo/course_category_repo.dart';
import '../../../add_course/data/models/add_course.dart'; // ✅ استيراد CourseModel
part 'course_category_state.dart';

class CourseCategoryCubit extends Cubit<CourseCategoryState> {
  final CourseCategoryRepo courseDetailsRepo;

  CourseCategoryCubit(this.courseDetailsRepo) : super(CourseCategoryInitial());

  Future<void> emitGetCourseByCategory(String category) async {
    emit(CourseCategoryLoading());
    try {
      final newCourse = await courseDetailsRepo.getCourseByCategory(category);

      emit(GetCourseByCategorySuccess(newCourse));
    } catch (e) {
      emit(GetCourseByCategoryFailure(e.toString()));
    }
  }
}
