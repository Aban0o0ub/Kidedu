import '../../../../../core/networking/web_services.dart';
import '../../../add_course/data/models/add_course.dart';

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
}

