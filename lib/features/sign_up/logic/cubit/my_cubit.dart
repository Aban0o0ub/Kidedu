import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import 'package:loginpage/features/sign_up/data/repo/my_repo.dart';

part 'my_state.dart';

class MyCubit extends Cubit<MyState> {
  final MyRepo myRepo;
  MyCubit(this.myRepo) : super(MyInitial());

  void emitCreateNewKid(KidData newKid) async {
    try {
      if (isClosed) return;
      emit(MyLoading());

      await myRepo.createNewKid(newKid);

      if (isClosed) return;
      emit(CreateNewKidSuccess(newKid));
    } catch (e) {
      if (isClosed) return;

      final rawMessage = e.toString();
      String message = "Something went wrong";

      if (rawMessage.contains("SIGN_UP_FAILED")) {
        message = "SIGN_UP_FAILED";
      }

      emit(MyFailure(message));
    }
  }

  void emitCreateNewInstructor(InstructorData newInstructor) async {
    try {
      if (isClosed) return;
      emit(MyLoading());
      print("Request Data: ${newInstructor.toJson()}");
      await myRepo.createNewInstructor(newInstructor);
      if (isClosed) return;
      emit(CreateNewInstructorSuccess(newInstructor));
    } catch (e) {
      if (isClosed) return;
      final rawMessage = e.toString();
      final message = rawMessage.contains("SIGN_UP_FAILED")
          ? "SIGN_UP_FAILED"
          : rawMessage
              .replaceAll("Exception:", "")
              .replaceAll("Error creating new instructor:", "")
              .trim();
      emit(MyFailure(message));
    }
  }
}
