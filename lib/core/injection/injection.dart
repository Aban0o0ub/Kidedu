import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/instructor_profile/data/Repo/ins_profile_repo.dart';
import 'package:loginpage/features/instructor_profile/logic/cubit/instructor_profile_cubit.dart';
import 'package:loginpage/features/kid_profile/data/Repo/kid_profile_repo.dart';
import 'package:loginpage/features/kid_profile/logic/cubit/kid_profile_cubit.dart';
import 'package:loginpage/features/login/data/repo/my_repo.dart';
import 'package:loginpage/features/login/logic/cubit/my_cubit.dart';
import 'package:loginpage/features/sign_up/data/repo/my_repo.dart';
import 'package:loginpage/features/sign_up/logic/cubit/my_cubit.dart';

final getIt = GetIt.instance;

void initGetIt() {
  getIt.registerLazySingleton<MyCubit>(() => MyCubit(getIt()));
  getIt.registerLazySingleton<MyRepo>(() => MyRepo(getIt()));
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerLazySingleton<KidProfileCubit>(
      () => KidProfileCubit(getIt<KidProfileRepo>()));
  getIt.registerLazySingleton<KidProfileRepo>(() => KidProfileRepo(getIt()));
  getIt.registerLazySingleton<InstructorProfileCubit>(
      () => InstructorProfileCubit(getIt<InstructorProfileRepo>()));
  getIt.registerLazySingleton<InstructorProfileRepo>(
      () => InstructorProfileRepo(getIt()));
  getIt.registerLazySingleton<WebServices>(
      () => WebServices(createAndSetupDio()));
}

Dio createAndSetupDio() {
  Dio dio = Dio();

  dio
    ..options.connectTimeout = const Duration(seconds: 30)
    ..options.receiveTimeout = const Duration(seconds: 30);

  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    error: true,
    requestHeader: false,
    responseHeader: false,
    request: true,
    responseBody: true,
  ));
  return dio;
}
