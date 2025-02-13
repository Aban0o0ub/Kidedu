import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/add_course/data/repo/add_course_repo.dart';
import 'package:loginpage/features/add_course/logic/cubit/add_course_cubit.dart';
import 'package:loginpage/features/course_details/data/repo/course_details_repo.dart';
import 'package:loginpage/features/course_details/logic/cubit/course_details_cubit.dart';
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
  getIt.registerFactory<MyCubit>(() => MyCubit(getIt()));
  getIt.registerFactory<MyRepo>(() => MyRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerFactory<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<KidProfileCubit>(
      () => KidProfileCubit(getIt<KidProfileRepo>()));
  getIt.registerFactory<KidProfileRepo>(() => KidProfileRepo(getIt()));
  getIt.registerFactory<InstructorProfileCubit>(
      () => InstructorProfileCubit(getIt<InstructorProfileRepo>()));
  getIt.registerFactory<InstructorProfileRepo>(
      () => InstructorProfileRepo(getIt()));
  getIt.registerFactory<AddCourseCubit>(() => AddCourseCubit(getIt()));
  getIt.registerFactory<AddCourseRepo>(() => AddCourseRepo(getIt()));
  getIt.registerFactory<CourseDetailsCubit>(() => CourseDetailsCubit(getIt()));
  getIt.registerFactory<CourseDetailsRepo>(() => CourseDetailsRepo(getIt()));
  getIt.registerFactory<WebServices>(() => WebServices(createAndSetupDio()));
}

Dio createAndSetupDio() {
  Dio dio = Dio();

  dio.options = BaseOptions(
    baseUrl: 'http://192.168.1.5:3000/api/',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );

  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    error: true,
    requestHeader: true,
    responseHeader: true,
    request: true,
    responseBody: true,
  ));

  return dio;
}
