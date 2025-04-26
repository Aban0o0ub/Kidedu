import '../../../../../core/networking/web_services.dart';
import '../../../add_course/data/models/Course_Model.dart';

class CourseCategoryRepo {
  final WebServices webServices;

  CourseCategoryRepo(this.webServices);

Future<List<CourseData>> getCourseByCategory(String category) async {
    try {
      return await webServices.getCourseByCategory(category);
    } catch (e) {
      throw Exception("Error fetching courses: ${e.toString()}");
    }
  }

  Future<List<CourseData>> getKidCourses() async {
    try {
      return await webServices.getAllCoursesByKid();
    } catch (e) {
      throw Exception("Error fetching courses: ${e.toString()}");
    }
  }
}

