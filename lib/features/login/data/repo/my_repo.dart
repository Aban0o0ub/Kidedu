import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/login/data/models/user.dart';

import '../../../sign_up/data/models/kid.dart';

class LoginRepo {
  final WebServices webServices;

  LoginRepo(this.webServices);

  Future<LoginResponse> loginUser(User loginUser) async {
    return await webServices.loginUser(loginUser);
  }
}
