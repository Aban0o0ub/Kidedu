part of 'achievment_cubit.dart';

@immutable
sealed class AchievmentState {}

final class AchievmentInitial extends AchievmentState {}

final class GetMyPointsLoading extends AchievmentState {}

class GetMyPointsSuccess extends AchievmentState {
  final MyPointsData response;

  GetMyPointsSuccess(this.response);
}

class GetMyPointsFailure extends AchievmentState {
  final String error;

  GetMyPointsFailure(this.error);
}