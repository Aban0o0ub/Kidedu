import 'package:flutter/material.dart';
import 'core/injection/injection.dart';
import 'features/onBoarding/ui/welcome_page.dart';

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
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Alegreya',
      ),
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}
