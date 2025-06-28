import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/course_details/data/repo/course_details_repo.dart';
import '../../../add_course/data/models/Course_Model.dart';
part 'course_details_state.dart';

class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  final CourseDetailsRepo courseDetailsRepo;

  CourseDetailsCubit(this.courseDetailsRepo) : super(CourseDetailsInitial());

  Future<void> emitGetSingleCourse(String id) async {
    emit(CourseDetailsLoading());
    try {
      if (id.isEmpty) {
        throw Exception('Course ID is not available');
      }

      final newCourse = await courseDetailsRepo.getCourseById(id);
      emit(GetCourseSuccess(newCourse));
    } catch (e) {
      emit(GetCourseFailure(e.toString()));
    }
  }

  Future<void> emitInstructorEndCourse(EndCourseRequest request) async {
    emit(EndCourseLoading());
    try {
      final response = await courseDetailsRepo.instructorEndCourse(request);
      emit(EndCourseSuccess(response));
    } catch (e) {
      emit(EndCourseFailure(e.toString()));
    }
  }

  Future<void> emitKidEndCourse(EndCourseRequest request) async {
    emit(EndCourseLoading());
    try {
      final response = await courseDetailsRepo.kidEndCourse(request);
      emit(EndCourseSuccess(response));
    } catch (e) {
      emit(EndCourseFailure(e.toString()));
    }
  }
}
