import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

class KidProfileRepo {
  final WebServices webServices;

  KidProfileRepo(this.webServices);

  Future<Kid> getKidById(int kidId) async {
    return await webServices.getKidById(kidId);
  }

  Future<Kid> updateKidProfile(int kidId, Map<String, dynamic> kidData) async {
    var response = await webServices.updateKidProfile(kidId, kidData);
    return response;
  }
}
