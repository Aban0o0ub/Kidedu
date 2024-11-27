import 'package:loginpage/features/sign_up/data/models/kid.dart';
import 'package:loginpage/core/networking/web_services.dart';

class MyRepo {
  final WebServices webServices;

  MyRepo(this.webServices);

  // Future<List<Kid>> getAllKids() async {
  //   return await webServices.getAllKids();
  // }

  Future<Kid> createNewKid(Kid newkid) async {
    var response = await webServices.createNewKid(newkid);
    print(response);
    return response;
  }

  Future<Instructor> createNewInstructor(Instructor newinstructor) async {
    var response = await webServices.createNewInstructor(newinstructor);
    print(response);
    return response;
  }
}
