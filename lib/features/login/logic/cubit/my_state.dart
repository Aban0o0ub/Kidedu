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

//////////////////////////////////////////////////////
final class ForgetPasswordLoading extends LoginState {}

class ForgetPasswordSuccess extends LoginState {
  final ForgetPasswordResponse response;
  ForgetPasswordSuccess(this.response);
}

class ForgetPasswordFailure extends LoginState {
  final String error;
  ForgetPasswordFailure(this.error);
}

//////////////////////////////////////////////////////
final class ResetPasswordLoading extends LoginState {}

class ResetPasswordSuccess extends LoginState {
  final ForgetPasswordResponse response;
  ResetPasswordSuccess(this.response);
}

class ResetPasswordFailure extends LoginState {
  final String error;
  ResetPasswordFailure(this.error);
}