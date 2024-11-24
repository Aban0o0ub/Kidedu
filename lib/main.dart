import 'package:flutter/material.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/features/onBoarding/ui/welcome_page.dart';

void main() {
  initGetIt();
  runApp(const Auth());
}

class Auth extends StatelessWidget {
  const Auth({super.key});

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
