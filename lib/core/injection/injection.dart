import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/add_course/data/repo/add_course_repo.dart';
import 'package:loginpage/features/add_course/logic/cubit/add_course_cubit.dart';
import 'package:loginpage/features/cart/data/repo/cart_repo.dart';
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

import '../../features/cart/logic/cubit/cart_cubit.dart';
import '../../features/home/data/Repo/course_category_repo.dart';
import '../../features/home/logic/cubit/course_category_cubit.dart';
import '../../features/instructor_profile/logic/cubit/my_courses_cubit.dart';
import '../../features/payment/data/repo/payment_repo.dart';
import '../../features/payment/logic/cubit/payment_cubit.dart';

final getIt = GetIt.instance;

void initGetIt() {
  //WebServices
  getIt.registerLazySingleton<WebServices>(
      () => WebServices(createAndSetupDio()));

  // Repositories
  getIt.registerLazySingleton<MyRepo>(() => MyRepo(getIt<WebServices>()));
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt<WebServices>()));
  getIt.registerLazySingleton<KidProfileRepo>(
      () => KidProfileRepo(getIt<WebServices>()));
  getIt.registerLazySingleton<InstructorProfileRepo>(
      () => InstructorProfileRepo(getIt<WebServices>()));
  getIt.registerLazySingleton<AddCourseRepo>(
      () => AddCourseRepo(getIt<WebServices>()));
  getIt.registerLazySingleton<CourseDetailsRepo>(
      () => CourseDetailsRepo(getIt<WebServices>()));
  getIt.registerLazySingleton<CourseCategoryRepo>(
      () => CourseCategoryRepo(getIt<WebServices>()));
  getIt.registerLazySingleton<CartRepo>(() => CartRepo(getIt<WebServices>()));
    getIt.registerLazySingleton<PaymentRepo>(() => PaymentRepo(getIt<WebServices>()));


  //Cubits
  getIt.registerFactory<MyCubit>(() => MyCubit(getIt<MyRepo>()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LoginRepo>()));
  getIt.registerFactory<KidProfileCubit>(
      () => KidProfileCubit(getIt<KidProfileRepo>()));
  getIt.registerFactory<InstructorProfileCubit>(
      () => InstructorProfileCubit(getIt<InstructorProfileRepo>()));
  getIt.registerFactory<AddCourseCubit>(
      () => AddCourseCubit(getIt<AddCourseRepo>()));
  getIt.registerFactory<CourseDetailsCubit>(
      () => CourseDetailsCubit(getIt<CourseDetailsRepo>()));
  getIt.registerFactory<CourseCategoryCubit>(
      () => CourseCategoryCubit(getIt<CourseCategoryRepo>()));
  getIt.registerFactory<MyCoursesCubit>(
      () => MyCoursesCubit(getIt<InstructorProfileRepo>()));
  getIt.registerLazySingleton<CartCubit>(() => CartCubit(getIt<CartRepo>()));
    getIt.registerFactory<PaymentCubit>(() => PaymentCubit(getIt<PaymentRepo>()));

}

Dio createAndSetupDio() {
  Dio dio = Dio();

  dio.options = BaseOptions(
    baseUrl: 'http://192.168.13.23:3000/api/',
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
