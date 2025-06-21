import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

class KidProfileRepo {
  final WebServices webServices;

  KidProfileRepo(this.webServices);

  Future<KidData> getKidProfile() async {
    return await webServices.getKidByToken();
  }

  Future<KidResponse> updateKidProfile(KidData kidData) async {
    return await webServices.updateKidProfile(kidData);
  }
}
