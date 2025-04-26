part of 'my_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

class LoginKidSuccess extends LoginState {
  final LoginResponse loginResponse;
  LoginKidSuccess(this.loginResponse);
}

class LoginInstructorSuccess extends LoginState {
  final LoginResponse loginResponse;
  LoginInstructorSuccess(this.loginResponse);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}
