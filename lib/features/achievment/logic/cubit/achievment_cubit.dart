import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/achievment_model.dart';
import '../../data/repo/achievment_repo.dart';
import 'package:flutter/material.dart';
part 'achievment_state.dart';

class AchievmentCubit extends Cubit<AchievmentState> {
  final AchievmentRepo achievmentRepo;
  AchievmentCubit(this.achievmentRepo) : super(AchievmentInitial());

  Future<void> emitGetMyPoints() async {
    emit(GetMyPointsLoading());
    try {
      final response = await achievmentRepo.getMyPoints();
      if (response.data != null) {
        emit(GetMyPointsSuccess(response.data!));
      } else {
        emit(GetMyPointsFailure("No data received from server"));
      }
    } catch (e) {
      emit(GetMyPointsFailure(e.toString()));
    }
  }
}
