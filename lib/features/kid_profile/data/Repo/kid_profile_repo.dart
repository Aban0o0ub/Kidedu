import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import '../../../../core/helper/cache_helper.dart';

class KidProfileRepo {
  final WebServices webServices;

  KidProfileRepo(this.webServices);

  // Future<Kid> getKidById(String kidId) async {
  //   return await webServices.getKidById(
  //       kidId, 'Bearer THIS-IS-THE-SECRET-KEY(AMOORE)');
  // }
  Future<KidData> getKidProfile() async {
  String? token = await CacheHelper.getData(key: "token");
  if (token == null) {
    throw Exception('Token is missing');
  }

  return await webServices.getKidByToken(); 
}


  Future<KidResponse> updateKidProfile(
      String kidId, Map<String, dynamic> kidData) async {
    var response = await webServices.updateKidProfile(
        kidId, KidResponse(), 'Bearer THIS-IS-THE-SECRET-KEY(AMOORE)');
    print(response);
    return response;
  }
}
