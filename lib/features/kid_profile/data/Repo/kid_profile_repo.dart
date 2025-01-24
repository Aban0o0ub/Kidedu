import 'package:bson/bson.dart';
import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

class KidProfileRepo {
  final WebServices webServices;

  KidProfileRepo(this.webServices);

  Future<Kid> getKidById(ObjectId kidId) async {
    return await webServices.getKidById(kidId.oid);
  }

  Future<Kid> updateKidProfile(
      ObjectId kidId, Map<String, dynamic> kidData) async {
    var response =
        await webServices.updateKidProfile(kidId.toHexString(), Kid());
    print(response);
    return response;
  }
}
