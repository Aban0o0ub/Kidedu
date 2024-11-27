part of 'my_cubit.dart';

@immutable
sealed class MyState {}

final class MyInitial extends MyState {}

final class MyLoading extends MyState {}

class LoginKidSuccess extends MyState {
  final User loginkid;

  LoginKidSuccess(this.loginkid);
}

class LoginInstructorSuccess extends MyState {
  final User logininstructor;

  LoginInstructorSuccess(this.logininstructor);
}

class MyFailure extends MyState {
  final String error;

  MyFailure(this.error);
}
