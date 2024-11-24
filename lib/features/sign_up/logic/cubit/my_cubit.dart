import 'package:bloc/bloc.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import 'package:loginpage/features/sign_up/data/repo/my_repo.dart';
import 'package:meta/meta.dart';

part 'my_state.dart';

class MyCubit extends Cubit<MyState> {
  final MyRepo myRepo;
  MyCubit(this.myRepo) : super(MyInitial());

  void emitGetAllKids() {
    myRepo.getAllKids().then((kidslist) {
      emit(GetAllKids(kidslist));
    });
  }
}
