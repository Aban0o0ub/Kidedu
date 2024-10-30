import 'package:flutter/material.dart';
import 'package:loginpage/pages/login_page.dart';
//import 'package:loginpage/pages/splash_screen.dart';

void main() {
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
      home: const LoginPage(),
    );
  }
}
