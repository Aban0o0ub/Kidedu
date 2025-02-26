import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/kid_profile/data/Repo/kid_profile_repo.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

part 'kid_profile_state.dart';

class KidProfileCubit extends Cubit<KidProfileState> {
  final KidProfileRepo kidProfileRepo;

  KidProfileCubit(this.kidProfileRepo) : super(KidProfileInitial());

//  Future<void> emitGetKidProfile() async {
//    print("Fetching kid profile...");
//   emit(MyLoading());
//   try {
//     final kid = await kidProfileRepo.getKidProfile();
//     print("Fetched Kid Data: ${kid.toJson()}");
//     emit(GetSingleKid(kid));
//   } catch (e) {
//     emit(MyFailure(e.toString()));
//   }
// }
  Future<void> emitGetKidProfile() async {
    print("Fetching kid profile...");
    emit(MyLoading());
    try {
      final kid = await kidProfileRepo.getKidProfile();
      print("Fetched Kid Data: ${kid.toJson()}");
      emit(GetSingleKid(kid));
    } catch (e) {
      emit(MyFailure(e.toString()));
    }
  }

  Future<void> emitUpdateKidProfile(String kidId, KidResponse kid) async {
    emit(MyLoading());
    try {
      final updatedKid =
          await kidProfileRepo.updateKidProfile(kidId, kid.toJson());
      emit(UpdateKidProfile(updatedKid));
    } catch (e) {
      emit(MyFailure(e.toString()));
    }
  }
}
