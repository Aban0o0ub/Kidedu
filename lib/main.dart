import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/features/kid_profile/data/Repo/kid_profile_repo.dart';
import 'package:loginpage/features/login/logic/cubit/my_cubit.dart';
import 'package:loginpage/features/kid_profile/logic/cubit/kid_profile_cubit.dart';
import 'package:loginpage/features/onBoarding/ui/welcome_page.dart';
import 'package:provider/provider.dart';

void main() {
  initGetIt();
  runApp(
    MultiProvider(
      providers: [
        // توفير الـ LoginCubit
        BlocProvider<LoginCubit>(
          create: (context) => getIt<LoginCubit>(),
        ),
        // توفير الـ KidProfileCubit
        BlocProvider<KidProfileCubit>(
          create: (context) => getIt<KidProfileCubit>(),
        ),
        // إضافة الـ KidProfileRepo
        Provider<KidProfileRepo>(
          create: (context) => getIt<KidProfileRepo>(),
        ),
      ],
      child: const KidEdu(),
    ),
  );
}
// void main() {
//   runApp(const KidEdu());
// }

class KidEdu extends StatelessWidget {
  const KidEdu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Alegreya',
      ),
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}
