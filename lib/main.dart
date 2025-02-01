import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:loginpage/features/course_details/ui/views/course_details.dart';
import 'package:loginpage/features/onBoarding/ui/welcome_page.dart';
import 'core/injection/injection.dart';

void main() {
  initGetIt();
  runApp(
    const KidEdu(),
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
          home: const WelcomePage(),
        );
      },
    );
  }
}
