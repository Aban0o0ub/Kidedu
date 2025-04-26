import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/login/data/models/user.dart';
import 'package:loginpage/features/login/data/repo/my_repo.dart';

import '../../../sign_up/data/models/kid.dart';

part 'my_state.dart';
class LoginCubit extends Cubit<LoginState> {
  final LoginRepo myRepo;

  LoginCubit(this.myRepo) : super(LoginInitial());

  Future<void> emitLoginUser({required User user}) async {
  emit(LoginLoading());

  try {
    LoginResponse response = await myRepo.loginUser(user);

    if (response.role == 'kid') {
      emit(LoginKidSuccess(response));
    } else if (response.role == 'instructor') {
      emit(LoginInstructorSuccess(response));
    } else {
      emit(LoginFailure('role is incorrect ${response.role}'));
    }
  } catch (e) {
    emit(LoginFailure('error: ${e.toString()}'));
  }
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
}
