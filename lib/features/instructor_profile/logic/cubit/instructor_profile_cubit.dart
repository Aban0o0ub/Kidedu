import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/instructor_profile/data/Repo/ins_profile_repo.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

part 'instructor_profile_state.dart';

class InstructorProfileCubit extends Cubit<InstructorProfileState> {
  final InstructorProfileRepo instructorProfileRepo;

  InstructorProfileCubit(this.instructorProfileRepo)
      : super(InstructorProfileInitial());

  Future<void> emitGetSingleInstructor(String instructorId) async {
    emit(MyLoading());
    try {
      final instructor =
          await instructorProfileRepo.getInstructorProfile();
      emit(GetSingleInstructor(instructor));
    } catch (e) {
      emit(MyFailure(e.toString()));
    }
  }

  // Future<void> emitUpdateKidProfile(NewInstructor instructor) async {
  //   emit(MyLoading());
  //   try {
  //     final updatedInstructor = await instructorProfileRepo
  //         .updateInstructorProfile(instructor.id!, instructor.toJson());
  //     emit(UpdateInstructorProfile(updatedInstructor));
  //   } catch (e) {
  //     emit(MyFailure(e.toString()));
  //   }
  // }
}
