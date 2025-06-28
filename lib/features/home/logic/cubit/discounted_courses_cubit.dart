import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/Repo/course_category_repo.dart';
import '../../../add_course/data/models/Course_Model.dart';
part 'discounted_courses_state.dart';

class DiscountedCoursesCubit extends Cubit<DiscountedCoursesState> {
  final CourseCategoryRepo courseDetailsRepo;
  DiscountedCoursesCubit(this.courseDetailsRepo)
      : super(DiscountedCoursesInitial());

  Future<void> emitGetDiscountedCourses() async {
    emit(DiscountedCoursesLoading());
    try {
      final List<CourseData> discountedCourses =
          await courseDetailsRepo.getTopDiscounts();
      emit(GetDiscountedCourseSuccess(discountedCourses));
    } catch (e) {
      emit(GetDiscountedCourseFailure(e.toString()));
    }
  }
}
