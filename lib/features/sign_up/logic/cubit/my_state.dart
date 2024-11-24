part of 'my_cubit.dart';

@immutable
sealed class MyState {}

final class MyInitial extends MyState {}

class GetAllKids extends MyState {
  final List<Kid> allKidsList;

  GetAllKids(this.allKidsList);
}
