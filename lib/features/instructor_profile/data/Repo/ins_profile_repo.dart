import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import '../../../add_course/data/models/Course_Model.dart';

class InstructorProfileRepo {
  final WebServices webServices;

  InstructorProfileRepo(this.webServices);

  Future<InstructorData> getInstructorProfile() async {
    return await webServices.getInstructorByToken();
  }

  Future<InstructorResponse> updateInstructorProfile(InstructorData instructorData) async {
    return await webServices.updateInstructorProfile(instructorData);
  }

  Future<List<CourseData>> getMyCourses() async {
    try {
      return await webServices.getAllCoursesByInstructor();
    } catch (e) {
      throw Exception("Error fetching courses: ${e.toString()}");
    }
  }
}
