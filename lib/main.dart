import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/features/login/logic/cubit/my_cubit.dart';
import 'package:loginpage/features/onBoarding/ui/welcome_page.dart';

void main() {
  initGetIt();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (context) => getIt<LoginCubit>(),
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
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Alegreya',
      ),
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}
