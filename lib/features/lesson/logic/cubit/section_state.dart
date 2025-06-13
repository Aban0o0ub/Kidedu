part of 'section_cubit.dart';

@immutable
sealed class SectionState {}

final class SectionInitial extends SectionState {}

final class AddSectionLoading extends SectionState {}

class AddSectionSuccess extends SectionState {
  final CreateSectionResponse newSection;

  AddSectionSuccess(this.newSection);
}

class AddSectionFailure extends SectionState {
  final String error;

  AddSectionFailure(this.error);
}
////////////////////////////////////////////////////////////////////////
final class GetSectionLoading extends SectionState {}

class GetSectionSuccess extends SectionState {
  final GetSectionsResponse response;

  GetSectionSuccess(this.response);
}

class GetSectionFailure extends SectionState {
  final String error;

  GetSectionFailure(this.error);
}