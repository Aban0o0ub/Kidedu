import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/login/data/models/user.dart';
import 'package:loginpage/features/login/data/repo/my_repo.dart';

part 'my_state.dart';

class LoginCubit extends Cubit<MyState> {
  final LoginRepo myRepo;
  LoginCubit(this.myRepo) : super(MyInitial());

  void emitLoginUserKid(User loginkid) async {
    emit(MyLoading());
    try {
      await myRepo.loginUserKid(loginkid);
      emit(LoginKidSuccess(loginkid));
    } catch (e) {
      emit(MyFailure(e.toString()));
    }
  }

  void emitLoginUserInstructor(User logininstructor) async {
    emit(MyLoading());
    try {
      await myRepo.loginUserInstructor(logininstructor);
      emit(LoginInstructorSuccess(logininstructor));
    } catch (e) {
      emit(MyFailure(e.toString()));
    }
  }
}
