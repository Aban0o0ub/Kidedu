part of 'kid_profile_cubit.dart';

@immutable
sealed class KidProfileState {}

final class KidProfileInitial extends KidProfileState {}

final class KidProfileLoading extends KidProfileState {}

class KidProfileSuccess extends KidProfileState {
  final KidData kid;
  KidProfileSuccess(this.kid);
}

class KidProfileFailure extends KidProfileState {
  final String error;
  KidProfileFailure(this.error);
}

final class UpdateKidLoading extends KidProfileState {}

class UpdateKidProfile extends KidProfileState {
  final KidResponse kid;

  UpdateKidProfile(this.kid);
}

class UpdateKidFailure extends KidProfileState {
  final String error;
  UpdateKidFailure(this.error);
}


final class ChangePasswordLoading extends KidProfileState {}

final class ChangePasswordSuccess extends KidProfileState {}

class ChangePasswordFailure extends KidProfileState {
  final String error;
  ChangePasswordFailure(this.error);
}