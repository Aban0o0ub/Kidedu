import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/login/data/models/user.dart';

class LoginRepo {
  final WebServices webServices;

  LoginRepo(this.webServices);

  Future<User> loginUserKid(User loginkid) async {
    return await webServices.loginUserKid(loginkid);
  }

  Future<User> loginUserInstructor(User logininstructor) async {
    return await webServices.loginUserInstructor(logininstructor);
  }
}
