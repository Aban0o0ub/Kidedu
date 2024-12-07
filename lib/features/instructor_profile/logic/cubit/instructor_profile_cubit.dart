import 'package:bloc/bloc.dart';
import 'package:loginpage/features/instructor_profile/data/Repo/ins_profile_repo.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import 'package:meta/meta.dart';

part 'instructor_profile_state.dart';

class InstructorProfileCubit extends Cubit<InstructorProfileState> {
  final InstructorProfileRepo instructorProfileRepo;

  InstructorProfileCubit(this.instructorProfileRepo)
      : super(InstructorProfileInitial());

  Future<void> emitGetSingleInstructor(int instructorId) async {
    emit(MyLoading());
    try {
      final instructor =
          await instructorProfileRepo.getInstructorById(instructorId);
      emit(GetSingleInstructor(instructor));
    } catch (e) {
      emit(MyFailure(e.toString()));
    }
  }

  Future<void> emitUpdateKidProfile(Instructor instructor) async {
    emit(MyLoading());
    try {
      final updatedInstructor = await instructorProfileRepo
          .updateInstructorProfile(instructor.id!, instructor.toJson());
      emit(UpdateInstructorProfile(updatedInstructor));
    } catch (e) {
      emit(MyFailure(e.toString()));
    }
  }
}
