import 'package:loginpage/features/sign_up/data/models/kid.dart';
import 'package:loginpage/core/networking/web_services.dart';

class MyRepo {
  final WebServices kidServices;

  MyRepo(this.kidServices);
  Future<List<Kid>> getAllKids() async {
    var response = await kidServices.getAllKids();
    return response
        .map((singlekid) => Kid.fromJson(singlekid.toJson()))
        .toList();
  }
}
