import 'package:loginpage/features/add_course/data/models/add_course.dart';
import '../../../../core/helper/cache_helper.dart';
import '../../../../core/networking/web_services.dart';

class AddCourseRepo {
  final WebServices webServices;

  AddCourseRepo(this.webServices);

  Future<CourseModel> addNewCourse(CourseModel newCourse) async {
    print("Starting addNewCourse...");
    String? token = await CacheHelper.getData(key: "token");
    print("Retrieved Token: $token");

    if (token == null) {
      throw Exception('Token is missing');
    }

    return await webServices.addNewCourse(newCourse);
  }
}
