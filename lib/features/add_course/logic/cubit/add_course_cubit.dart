import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import '../../data/models/Course_Model.dart';
import '../../data/repo/add_course_repo.dart';
part 'add_course_state.dart';

class AddCourseCubit extends Cubit<AddCourseState> {
  final AddCourseRepo addCourseRepo;
  AddCourseCubit(this.addCourseRepo) : super(AddCourseInitial());

  void emitAddCourse(BuildContext context, CourseRequest newCourse,
      {bool goToLessons = false}) async {
    try {
      if (isClosed) return;
      emit(AddCourseLoading());
      CourseResponse courseResponse =
          await addCourseRepo.addNewCourse(newCourse);
      if (isClosed) return;
      emit(AddCourseSuccess(courseResponse));
      if (goToLessons) {
        context.go(
          Routes.addLessonPage,
          extra: {'courseId': courseResponse.data?.id},
        );
      } else {
        context.go(Routes.instructorProfilePage);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Course created successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(AddCourseFailure(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void emitUpdateCourse(
    BuildContext context,
    String courseId,
    Map<String, dynamic> updatedCourseData,
  ) async {
    try {
      if (isClosed) return;
      emit(AddCourseLoading());

      CourseResponse courseResponse =
          await addCourseRepo.updateCourse(courseId, updatedCourseData);

      if (isClosed) return;
      emit(AddCourseSuccess(courseResponse));

      // ❌ شيل التنقل من هنا برضو
    } catch (e) {
      if (isClosed) return;
      emit(AddCourseFailure(e.toString()));
    }
  }
}
