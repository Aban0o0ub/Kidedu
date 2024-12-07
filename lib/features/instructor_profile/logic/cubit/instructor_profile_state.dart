part of 'instructor_profile_cubit.dart';

@immutable
sealed class InstructorProfileState {}

final class InstructorProfileInitial extends InstructorProfileState {}

final class MyLoading extends InstructorProfileState {}

class GetSingleInstructor extends InstructorProfileState {
  final Instructor instructor;

  GetSingleInstructor(this.instructor);
}

class UpdateInstructorProfile extends InstructorProfileState {
  final Instructor instructor;

  UpdateInstructorProfile(this.instructor);
}

class MyFailure extends InstructorProfileState {
  final String error;

  MyFailure(this.error);
}
