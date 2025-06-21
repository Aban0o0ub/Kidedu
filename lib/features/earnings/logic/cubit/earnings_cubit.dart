import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

import '../../data/model/earnings_model.dart';
import '../../data/repo/earnings_repo.dart';

part 'earnings_state.dart';

class EarningsCubit extends Cubit<EarningsState> {
  final EarningsRepo earningsRepo;
  EarningsCubit(this.earningsRepo) : super(EarningsInitial());

  Future<void> emitGetInstructorEarnings() async {
    emit(InstructorEarningsLoading());
    try {
      final earningsData = await earningsRepo.getInstructorEarnings();
      emit(InstructorEarningsSuccess(earningsData));
    } catch (e) {
      print('Cubit error: $e');
      emit(InstructorEarningsFailure('error getting instructor earnings'));
    }
  }
}
