import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/course_details/data/repo/course_details_repo.dart';
import '../../../add_course/data/models/add_course.dart';
part 'course_details_state.dart';

class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  final CourseDetailsRepo courseDetailsRepo;
  CourseDetailsCubit(this.courseDetailsRepo) : super(CourseDetailsInitial());

  Future<void> emitGetSingleCourse(int courseId) async {
    emit(CourseDetailsLoading());
    try {
      final newCourse = await courseDetailsRepo.getCourseById(courseId);
      emit(GetCourseSuccess(newCourse));
    } catch (e) {
      emit(GetCourseFailure(e.toString()));
    }
  }
}
