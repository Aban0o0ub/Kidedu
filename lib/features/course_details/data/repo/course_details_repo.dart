import '../../../../core/networking/web_services.dart';
import '../../../add_course/data/models/add_course.dart';

class CourseDetailsRepo {
  final WebServices webServices;

  CourseDetailsRepo(this.webServices);

  Future<CourseModel> getCourseById(int courseId) async {
    return await webServices.getCourseById(
        courseId, 'Bearer THIS-IS-THE-SECRET-KEY(AMOORE)');
  }
}
