import '../../../../core/networking/web_services.dart';
import '../../../add_course/data/models/Course_Model.dart';

class CourseDetailsRepo {
  final WebServices webServices;

  CourseDetailsRepo(this.webServices);

  Future<CourseData> getCourseById(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('Course ID cannot be empty');
      }

      final courseData = await webServices.getCourseById(id);
      return courseData;
    } catch (e) {
      throw Exception(
          "Error fetching course details for ID: $id. ${e.toString()}");
    }
  }

  Future<EndCourseResponse> instructorEndCourse(
      EndCourseRequest endCourse) async {
    return await webServices.instructorEndCourse(endCourse);
  }

  Future<EndCourseResponse> kidEndCourse(EndCourseRequest endCourse) async {
    return await webServices.kidEndCourse(endCourse);
  }
}
