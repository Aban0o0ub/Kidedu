import 'package:flutter/material.dart';
import 'package:loginpage/widgets/arrow_back.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ArrowBack(),
          Center(
            child: Text(
              "homepage",
              style: TextStyle(fontSize: 40, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
