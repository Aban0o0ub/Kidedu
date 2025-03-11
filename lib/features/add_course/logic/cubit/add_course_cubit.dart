import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../instructor_profile/ui/views/instructor_profile_page.dart';
import '../../data/models/add_course.dart';
import '../../data/repo/add_course_repo.dart';
part 'add_course_state.dart';

class AddCourseCubit extends Cubit<AddCourseState> {
  final AddCourseRepo addCourseRepo;
  AddCourseCubit(this.addCourseRepo) : super(AddCourseInitial());

 void emitAddCourse(BuildContext context, CourseRequest newCourse) async {
  try {
    if (isClosed) return;
    emit(AddCourseLoading());

    CourseResponse courseResponse = await addCourseRepo.addNewCourse(newCourse);

    if (isClosed) return;
    emit(AddCourseSuccess(courseResponse));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InstructorProfilePage()),
    );
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


}
