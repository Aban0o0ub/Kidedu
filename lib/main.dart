import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loginpage/core/helper/cache_helper.dart';
import 'package:provider/provider.dart';
import 'core/injection/injection.dart';
import 'core/routing/app_router.dart';
import 'features/add_course/logic/cubit/add_course_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.cacheInitialization();
  initGetIt();

  runApp(
    MultiProvider(
      providers: [
        BlocProvider<AddCourseCubit>(
          create: (context) => getIt<AddCourseCubit>(),
        ),
      ],
      child: const KidEdu(),
    ),
  );
}

class KidEdu extends StatelessWidget {
  const KidEdu({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          theme: ThemeData(
            fontFamily: 'Alegreya',
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
       
      },
    );
  }
}
