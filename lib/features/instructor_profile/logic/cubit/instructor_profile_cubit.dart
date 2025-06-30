import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/instructor_profile/data/Repo/ins_profile_repo.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

part 'instructor_profile_state.dart';

class InstructorProfileCubit extends Cubit<InstructorProfileState> {
  final InstructorProfileRepo instructorProfileRepo;

  InstructorProfileCubit(this.instructorProfileRepo)
      : super(InstructorProfileInitial());

  Future<void> emitGetInstructorProfile() async {
    emit(InstructorProfileLoading());
    try {
      final instructor = await instructorProfileRepo.getInstructorProfile();
      emit(InstructorProfileSuccess(instructor));
    } catch (e) {
      print('Cubit error: $e');
      emit(InstructorProfileFailure('there is an error'));
    }
  }

  Future<void> emitUpdateInstructorProfile({
    InstructorData? instructorData,
    String? bio,
    String? experience,
    String? name,
    String? phoneNumber,
    String? email,
    String? governorate,
    String? title,
  }) async {
    emit(UpdateInstructorLoading());
    try {
      InstructorData dataToUpdate;

      if (instructorData != null) {
        dataToUpdate = instructorData;
      } else {
        final currentState = state;
        InstructorData? currentData;

        if (currentState is InstructorProfileSuccess) {
          currentData = currentState.instructor;
        }

        dataToUpdate = InstructorData(
          name: name ?? currentData?.name ?? '',
          phoneNumber: phoneNumber ?? currentData?.phoneNumber ?? '',
          email: email ?? currentData?.email ?? '',
          governorate: governorate ?? currentData?.governorate ?? '',
          title: title ?? currentData?.title ?? '',
          bio: bio ?? currentData?.bio ?? '',
          experience: experience ?? currentData?.experience ?? '',
        );
      }

      final updatedInstructor =
          await instructorProfileRepo.updateInstructorProfile(dataToUpdate);

      emit(UpdateInstructorSuccess(updatedInstructor));

      emit(InstructorProfileSuccess(updatedInstructor.data!.instructor!));
    } catch (e) {
      emit(UpdateInstructorFailure(e.toString()));
    }
  }

  Future<void> emitGetOnlyInstructor(String id) async {
    emit(InstructorProfileLoading());
    try {
      final instructor = await instructorProfileRepo.getOnlyInstructor(id);
      emit(InstructorProfileSuccess(instructor));
    } catch (e) {
      print('Cubit error: $e');
      emit(InstructorProfileFailure('there is an error'));
    }
  }
}
