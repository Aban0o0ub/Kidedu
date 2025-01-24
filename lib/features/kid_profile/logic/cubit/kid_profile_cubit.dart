import 'package:bloc/bloc.dart';
import 'package:bson/bson.dart';
//import 'package:bson/bson.dart';
import 'package:loginpage/features/kid_profile/data/Repo/kid_profile_repo.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import 'package:meta/meta.dart';

part 'kid_profile_state.dart';

class KidProfileCubit extends Cubit<KidProfileState> {
  final KidProfileRepo kidProfileRepo;

  KidProfileCubit(this.kidProfileRepo) : super(KidProfileInitial());

  Future<void> emitGetSingleKid(ObjectId kidId) async {
    emit(MyLoading());
    try {
      final kid = await kidProfileRepo.getKidById(kidId);
      emit(GetSingleKid(kid));
    } catch (e) {
      emit(MyFailure(e.toString()));
    }
  }

  Future<void> emitUpdateKidProfile(Kid kid) async {
    emit(MyLoading());
    try {
      final updatedKid =
          await kidProfileRepo.updateKidProfile(kid.id!, kid.toJson());
      emit(UpdateKidProfile(updatedKid));
    } catch (e) {
      emit(MyFailure(e.toString()));
    }
  }
}
