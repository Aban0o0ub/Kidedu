import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/section.dart';
import '../../data/repo/section_repo.dart';
import 'package:flutter/material.dart';
part 'section_state.dart';

class SectionCubit extends Cubit<SectionState> {
  final SectionRepo sectionRepo;
  SectionCubit(this.sectionRepo) : super(SectionInitial());

  Future<void> emitAddSection(CreateSectionRequest request) async {
    emit(AddSectionLoading());

    try {
      final response = await sectionRepo.addSection(request);
      emit(AddSectionSuccess(response));
    } catch (e) {
      emit(AddSectionFailure(e.toString()));
    }
  }

  Future<void> emitGetSection(String courseId) async {
    if (courseId.isEmpty) {
      emit(GetSectionFailure('Course ID is not available'));
      return;
    }

    emit(GetSectionLoading());
    try {
      final response = await sectionRepo.getSection(courseId);
      emit(GetSectionSuccess(response));
    } catch (e) {
      emit(GetSectionFailure(e.toString()));
    }
  }
}
