import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import '../../../add_course/data/models/Course_Model.dart';
import '../../../reviews/data/models/review_model.dart';

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
  Future<InstructorData> getOnlyInstructor(String id) async {
    return await webServices.getOnlyInstructor(id);
  }

  Future<List<CourseData>> getCoursesByInstructorId(String instructorId) async {
    return await webServices.getCoursesByInstructorId(instructorId);
  }

  Future<ReviewListResponseModel> getReviewsByInstructorId(String instructorId) async {
    return await webServices.getReviewsByInstructorId(instructorId);
  }
}
