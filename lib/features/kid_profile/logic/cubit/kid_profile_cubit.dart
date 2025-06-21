import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/kid_profile/data/Repo/kid_profile_repo.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

part 'kid_profile_state.dart';

class KidProfileCubit extends Cubit<KidProfileState> {
  final KidProfileRepo kidProfileRepo;

  KidProfileCubit(this.kidProfileRepo) : super(KidProfileInitial());

  Future<void> emitGetKidProfile() async {
    emit(KidProfileLoading());
    try {
      final kid = await kidProfileRepo.getKidProfile();
      emit(KidProfileSuccess(kid));
    } catch (e) {
      print('Cubit error: $e');
      emit(KidProfileFailure('فشل في تحميل بيانات الملف الشخصي'));
    }
  }


 Future<void> emitUpdateKidProfile(KidData kidData) async {
  emit(UpdateKidLoading());
  try {
    final updatedKid = await kidProfileRepo.updateKidProfile(kidData);
    emit(UpdateKidProfile(updatedKid));
  } catch (e) {
    emit(UpdateKidFailure(e.toString()));
  }
}

}
