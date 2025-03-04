import '../../../../../core/networking/web_services.dart';
import '../../../add_course/data/models/add_course.dart';

class CourseCategoryRepo {
  final WebServices webServices;

  CourseCategoryRepo(this.webServices);

  Future <CourseModel> getCourseByCategory(String category) async {
    return await webServices.getCourseByCategory(category);
  }
}