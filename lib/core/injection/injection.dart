import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/sign_up/data/repo/my_repo.dart';
import 'package:loginpage/features/sign_up/logic/cubit/my_cubit.dart';

final getIt = GetIt.instance;

void initGetIt() {
  getIt.registerLazySingleton<MyCubit>(() => MyCubit(getIt()));
  getIt.registerLazySingleton<MyRepo>(() => MyRepo(getIt()));
  getIt.registerLazySingleton<WebServices>(
      () => WebServices(createAndSetupDio()));
}

Dio createAndSetupDio() {
  Dio dio = Dio();

  dio
    ..options.connectTimeout = const Duration(seconds: 10)
    ..options.receiveTimeout = const Duration(seconds: 10);

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
