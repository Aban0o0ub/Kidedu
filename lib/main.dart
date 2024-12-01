import 'package:flutter/material.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/features/onBoarding/ui/welcome_page.dart';

void main() {
  initGetIt();
  initGetItForLogin();
  runApp(const KidEdu());
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
