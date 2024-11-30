import 'package:loginpage/features/sign_up/data/models/kid.dart';
import 'package:loginpage/core/networking/web_services.dart';

class MyRepo {
  final WebServices webServices;

  MyRepo(this.webServices);

  // Future<List<Kid>> getAllKids() async {
  //   return await webServices.getAllKids();
  // }

  Future<Kid> createNewKid(Kid newkid) async {
    return await webServices.createNewKid(newkid);
  }

  Future<Instructor> createNewInstructor(Instructor newinstructor) async {
    return await webServices.createNewInstructor(newinstructor);
  }
}
