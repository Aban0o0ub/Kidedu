part of 'earnings_cubit.dart';

@immutable
sealed class EarningsState {}

final class EarningsInitial extends EarningsState {}

final class InstructorEarningsLoading extends EarningsState {}

class InstructorEarningsSuccess extends EarningsState {
  final EarningsResponseModel earningsData;

  InstructorEarningsSuccess(this.earningsData);
}

class InstructorEarningsFailure extends EarningsState {
  final String error;

  InstructorEarningsFailure(this.error);
}
///////////////////////////////////////////////////////////////////
final class KidEduEarningsLoading extends EarningsState {}

class KidEduEarningsSuccess extends EarningsState {
  final AdminStatsResponseModel ourEarnings;

  KidEduEarningsSuccess(this.ourEarnings);
}

class KidEduEarningsFailure extends EarningsState {
  final String error;

  KidEduEarningsFailure(this.error);
}