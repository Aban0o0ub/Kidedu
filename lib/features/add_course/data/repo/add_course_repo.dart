import 'package:loginpage/features/add_course/data/models/Course_Model.dart';
import '../../../../core/helper/cache_helper.dart';
import '../../../../core/networking/web_services.dart';

class AddCourseRepo {
  final WebServices webServices;

  AddCourseRepo(this.webServices);

  Future<CourseResponse> addNewCourse(CourseRequest newCourse) async {
  print("Starting addNewCourse...");
  String? token = await CacheHelper.getData(key: "token");
  print("Retrieved Token: $token");

  if (token == null) {
    throw Exception('Token is missing');
  }

  return await webServices.addNewCourse(newCourse);
}

  Future<CourseResponse> updateCourse(String courseId, Map<String, dynamic> data) async {
    return await webServices.updateCourse(
      courseId: courseId,
      data: data,
    );
  }

}
