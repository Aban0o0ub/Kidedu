import 'package:loginpage/features/add_course/data/models/add_course.dart';
import '../../../../core/networking/web_services.dart';

class AddCourseRepo {
  final WebServices webServices;

  AddCourseRepo(this.webServices);

  Future<CourseModel> addNewCourse(CourseModel newCourse) async {
    return await webServices.addNewCourse(newCourse, 'Bearer AMOORE');
  }
}
