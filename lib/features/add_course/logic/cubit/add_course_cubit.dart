import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/add_course.dart';
import '../../data/repo/add_course_repo.dart';
part 'add_course_state.dart';

class AddCourseCubit extends Cubit<AddCourseState> {
  final AddCourseRepo addCourseRepo;
  AddCourseCubit(this.addCourseRepo) : super(AddCourseInitial());

 void emitAddCourse(CourseRequest newCourse) async {
  try {
    if (isClosed) return;
    emit(AddCourseLoading());

    CourseResponse courseResponse = await addCourseRepo.addNewCourse(newCourse);

    if (isClosed) return;
    emit(AddCourseSuccess(courseResponse));
  } catch (e) {
    if (isClosed) return;
    emit(AddCourseFailure(e.toString()));
  }
}

}
