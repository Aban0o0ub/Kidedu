import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart'; 
import '../../data/Repo/ins_profile_repo.dart';
import '../../../add_course/data/models/Course_Model.dart';
part 'my_courses_state.dart';

class MyCoursesCubit extends Cubit<MyCoursesState> {
  final InstructorProfileRepo instructorProfileRepo;

  MyCoursesCubit(this.instructorProfileRepo) : super(MyCoursesInitial());

 Future<void> emitGetMyCourses() async {
  emit(MyCoursesLoading());
  try {
    final List<CourseData> myCourses = await instructorProfileRepo.getMyCourses(); 
    emit(GetMyCoursesSuccess(myCourses));
  } catch (e) {
    emit(GetMyCoursesFailure(e.toString()));
  }
}

}