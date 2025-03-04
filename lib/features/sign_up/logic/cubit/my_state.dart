part of 'my_cubit.dart';

@immutable
sealed class MyState {}

final class MyInitial extends MyState {}

final class MyLoading extends MyState {}

//in case of success
class CreateNewKidSuccess extends MyState {
  final KidData newkid;

  CreateNewKidSuccess(this.newkid);
}

class CreateNewInstructorSuccess extends MyState {
  final InstructorData newinstructor;

  CreateNewInstructorSuccess(this.newinstructor);
}

class MyFailure extends MyState {
  final String error;

  MyFailure(this.error);
}
// class GetAllKids extends MyState {
//   final List<Kid> allKidsList;

//   GetAllKids(this.allKidsList);
// }
