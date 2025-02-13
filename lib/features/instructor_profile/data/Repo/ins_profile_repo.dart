import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

import '../../../../core/helper/cache_helper.dart';

class InstructorProfileRepo {
  final WebServices webServices;

  InstructorProfileRepo(this.webServices);

  Future<Instructor> getInstructorById(String instructorId) async {
    String? token = await CacheHelper.getData(key: "token");
    if (token == null) {
      throw Exception('Token is missing');
    }

    return await webServices.getInstructorById(instructorId, 'Bearer $token');
  }

  Future<Instructor> updateInstructorProfile(
      String instructorId, Map<String, dynamic> instructorData) async {
    var response = await webServices.updateInstructorProfile(
        instructorId, instructorData, 'Bearer THIS-IS-THE-SECRET-KEY(AMOORE)');
    return response;
  }
}
