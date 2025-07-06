import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/login/data/models/user.dart';
import 'package:loginpage/features/login/data/repo/my_repo.dart';
import 'package:loginpage/core/helper/auth_service.dart';

import '../../../sign_up/data/models/kid.dart';

part 'my_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo myRepo;

  LoginCubit(this.myRepo) : super(LoginInitial());

 Future<void> emitLoginUser({required User user}) async {
  emit(LoginLoading());
  try {
    LoginResponse response = await myRepo.loginUser(user);
    
    // حفظ بيانات المستخدم في Cache
    String? userName;
    if (response.role == 'kid' && response.kid != null) {
      userName = response.kid!.name;
    } else if (response.role == 'instructor' && response.instructor != null) {
      userName = response.instructor!.name;
    }
    
    // حفظ جلسة المستخدم
    await AuthService.saveUserSession(
      role: response.role ?? '',
      email: user.email ?? '',
      userId: response.userId,
      userName: userName,
    );
    
    // ✅ تعامل مع جميع الأدوار بما في ذلك الأدمن
    if (response.role == 'kid') {
      emit(LoginKidSuccess(response));
    } else if (response.role == 'instructor') {
      emit(LoginInstructorSuccess(response));
    } else if (response.role == 'admin') {
      // ✅ إضافة التعامل مع الأدمن
      emit(LoginAdminSuccess(response));
    } else {
      emit(LoginFailure('role is incorrect ${response.role}'));
    }
  } catch (e) {
    final errorString = e.toString();
    String errorMessage;
    
    if (errorString.contains('kid not found')) {
      errorMessage = "This kid user isn't found. Please make sure of your email and password.";
    } else if (errorString.contains('instructor not found')) {
      errorMessage = "This instructor user isn't found. Please make sure of your email and password.";
    } else if (errorString.contains('Invalid credentials')) {
      errorMessage = "Invalid email or password. Please try again.";
    } else if (errorString.contains('Invalid role')) {
      errorMessage = "Invalid role selected. Please try again.";
    } else {
      errorMessage = "Login failed. Please make sure of your email and password.";
    }
    
    emit(LoginFailure(errorMessage));
  }
}

  Future<void> emitForgetPassword({
    required String email,
    required String? role,
  }) async {
    emit(ForgetPasswordLoading());

    if (role == null || role.isEmpty) {
      emit(ForgetPasswordFailure('Please select a role.'));
      return;
    }
    if (email.isEmpty) {
      emit(ForgetPasswordFailure('Please enter your email.'));
      return;
    }

    try {
      final request = ForgetPasswordRequest(email: email, role: role);
      final response = await myRepo.forgetPassword(request);
      emit(ForgetPasswordSuccess(response));
    } catch (e) {
      // Parse error message better
      String errorMessage = 'Something went wrong. Please try again.';
      if (e.toString().contains('Server error:')) {
        errorMessage =
            e.toString().replaceFirst('Exception: Server error: ', '');
      }
      emit(ForgetPasswordFailure(errorMessage));
    }
  }

  Future<void> emitResetPassword({
  required String newPassword,
  required String token,
}) async {
  emit(ResetPasswordLoading());
  
  try {
    if (newPassword.isEmpty) {
      emit(ResetPasswordFailure('Password cannot be empty'));
      return;
    }
    if (token.isEmpty) {
      emit(ResetPasswordFailure('Invalid reset token'));
      return;
    }
    
    final request = ResetPasswordRequest(newPassword: newPassword);
    
    final response = await myRepo.resetPassword(
      token: token,
      resetPassword: request,
    );
    
    emit(ResetPasswordSuccess(response));
    
  } catch (e) {
    String errorMessage = _extractErrorMessage(e.toString());
    emit(ResetPasswordFailure(errorMessage));
  }
}

String _extractErrorMessage(String error) {
    if (error.contains('Server error:')) {
      return error.replaceFirst('Exception: Server error: ', '');
    } else if (error.contains('Network error:')) {
      return 'Network connection failed. Please check your internet.';
    }
    return 'This user isn\'t found. Please make sure of your email and password.';
  }

}

class RoleCubit extends Cubit<String?> {
  RoleCubit() : super(null);

  void selectRole(String role) {
    emit(role);
  }

  void clearRole() {
    emit(null);
  }

  /// تسجيل خروج المستخدم ومسح جميع البيانات المحفوظة
  Future<void> logout() async {
    await AuthService.logout();
    clearRole();
  }

  /// تحديث الدور من البيانات المحفوظة
  void loadSavedRole() {
    final savedRole = AuthService.getUserRole();
    if (savedRole != null) {
      emit(savedRole);
    }
  }

  // Helper method
  bool get hasRole => state != null && state!.isNotEmpty;
}


