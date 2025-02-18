import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loginpage/core/helper/cache_helper.dart';
import 'package:loginpage/features/home/ui/views/home_page.dart';
import 'package:loginpage/features/kid_profile/logic/cubit/kid_profile_cubit.dart';
import 'package:provider/provider.dart';
import 'core/injection/injection.dart';
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
        BlocProvider<KidProfileCubit>(
          create: (context) => getIt<KidProfileCubit>(),
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
        return MaterialApp(
          theme: ThemeData(
            fontFamily: 'Alegreya',
          ),
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        );
      },
    );
  }
}
