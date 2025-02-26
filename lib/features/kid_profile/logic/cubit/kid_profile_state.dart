part of 'kid_profile_cubit.dart';

@immutable
sealed class KidProfileState {}

final class KidProfileInitial extends KidProfileState {}

final class MyLoading extends KidProfileState {}

class GetSingleKid extends KidProfileState {
  final KidData kid;

  GetSingleKid(this.kid);
}

class UpdateKidProfile extends KidProfileState {
  final KidResponse kid;

  UpdateKidProfile(this.kid);
}

class MyFailure extends KidProfileState {
  final String error;

  MyFailure(this.error);
}
