import 'package:flutter/material.dart';
import 'package:loginpage/views/welcome_page.dart';

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
      home: const WelcomePage(),
    );
  }
}
