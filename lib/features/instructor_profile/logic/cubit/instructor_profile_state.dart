part of 'instructor_profile_cubit.dart';

@immutable
sealed class InstructorProfileState {}

final class InstructorProfileInitial extends InstructorProfileState {}

final class InstructorProfileLoading extends InstructorProfileState {}

class InstructorProfileSuccess extends InstructorProfileState {
  final InstructorData instructor;
  InstructorProfileSuccess(this.instructor);
}

class InstructorProfileFailure extends InstructorProfileState {
  final String error;
  InstructorProfileFailure(this.error);
}

final class UpdateInstructorLoading extends InstructorProfileState {}

class UpdateInstructorSuccess extends InstructorProfileState {
  final InstructorResponse instructor;
  UpdateInstructorSuccess(this.instructor);
}

class UpdateInstructorFailure extends InstructorProfileState {
  final String error;
  UpdateInstructorFailure(this.error);
}

