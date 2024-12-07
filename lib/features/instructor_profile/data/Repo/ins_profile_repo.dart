import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

class InstructorProfileRepo {
  final WebServices webServices;

  InstructorProfileRepo(this.webServices);

  Future<Instructor> getInstructorById(int instructorId) async {
    return await webServices.getInstructorById(instructorId);
  }

  Future<Instructor> updateInstructorProfile(
      int instructorId, Map<String, dynamic> instructorData) async {
    var response =
        await webServices.updateInstructorProfile(instructorId, instructorData);
    return response;
  }
}
