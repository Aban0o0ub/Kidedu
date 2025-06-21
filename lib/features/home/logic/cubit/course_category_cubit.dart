import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/Repo/course_category_repo.dart';
import '../../../add_course/data/models/Course_Model.dart';
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

   Future<void> emitGetKidCourses() async {
  emit(GetKidCoursesLoading());
  try {
    final List<CourseData> myCourses = await courseDetailsRepo.getKidCourses(); 
    emit(GetKidCoursesSuccess(myCourses));
  } catch (e) {
    emit(GetKidCoursesFailure(e.toString()));
  }
}

Future<void> emitGetTrendingCourses() async {
  print('🔥 Starting trending courses fetch...');
  emit(TrendingCoursesLoading());
  try {
    final List<CourseData> trendCourses = await courseDetailsRepo.getTrendingCourses();
    print('🔥 Cubit received ${trendCourses.length} courses');
    emit(GetTrendingCourseSuccess(trendCourses));
    print('🔥 Emitted GetTrendingCourseSuccess');
  } catch (e) {
    print('🔥 Cubit Error: ${e.toString()}');
    emit(GetTrendingCourseFailure(e.toString()));
  }
}
}
