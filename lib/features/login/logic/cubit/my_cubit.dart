import 'package:bloc/bloc.dart';
import 'package:loginpage/features/login/data/models/user.dart';
import 'package:loginpage/features/login/data/repo/my_repo.dart';
import 'package:meta/meta.dart';

part 'my_state.dart';

class MyCubit extends Cubit<MyState> {
  final MyRepo myRepo;
  MyCubit(this.myRepo) : super(MyInitial());

  // void emitLoginUserKid(User loginkid) {
  //   myRepo.loginUserKid(loginkid).then((loginkid) {
  //     emit(LoginKidSuccess(loginkid));
  //   });
  // }
  void emitLoginUserKid(User loginkid) async {
    try {
      emit(MyLoading());
      await myRepo.loginUserKid(loginkid);
      emit(LoginKidSuccess(loginkid));
    } catch (e) {
      emit(MyFailure(e.toString()));
    }
  }

  void emitLoginUserInstructor(User logininstructor) async {
    try {
      emit(MyLoading());
      await myRepo.loginUserInstructor(logininstructor);
      emit(LoginInstructorSuccess(logininstructor));
    } catch (e) {
      emit(MyFailure(e.toString()));
    }
  }
}
