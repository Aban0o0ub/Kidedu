import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

import '../../../../core/helper/cache_helper.dart';
import '../../../add_course/data/models/Course_Model.dart';

class InstructorProfileRepo {
  final WebServices webServices;

  InstructorProfileRepo(this.webServices);

  Future<InstructorData> getInstructorProfile() async {
    String? token = await CacheHelper.getData(key: "token");
    if (token == null) {
      throw Exception('Token is missing');
    }

    return await webServices.getInstructorByToken();
  }

//   Future<Instructor> updateInstructorProfile(
//       String instructorId, Map<String, dynamic> instructorData) async {
//     var response = await webServices.updateInstructorProfile(
//         instructorId, instructorData, 'Bearer THIS-IS-THE-SECRET-KEY(AMOORE)');
//     return response;
//   }
  Future<List<CourseData>> getMyCourses() async {
    try {
      return await webServices.getAllCoursesByInstructor();
    } catch (e) {
      throw Exception("Error fetching courses: ${e.toString()}");
    }
  }
 }
