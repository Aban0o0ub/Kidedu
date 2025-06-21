import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/login/data/models/user.dart';

import '../../../sign_up/data/models/kid.dart';

class LoginRepo {
  final WebServices webServices;

  LoginRepo(this.webServices);

  Future<LoginResponse> loginUser(User loginUser) async {
    return await webServices.loginUser(loginUser);
  }

  Future<ForgetPasswordResponse> forgetPassword(
      ForgetPasswordRequest forgetPassword) async {
    try {
      return await webServices.forgetPassword(forgetPassword);
    } catch (e) {
      throw Exception('Repository: Failed to process forget password request');
    }
  }

  Future<ForgetPasswordResponse> resetPassword({
  required String token,
  required ResetPasswordRequest resetPassword,
}) async {
  try {
    return await webServices.resetPassword(
      token: token,
      resetPassword: resetPassword,
    );
  } catch (e) {
    if (e is Exception) {
      rethrow;
    }
    throw Exception('Repository: Failed to process reset password - ${e.toString()}');
  }
}
}
