import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String text;

  const CustomTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: Color(0xFF02457A),
          shadows: [
            Shadow(
              offset: Offset(3.0, 3.0),
              blurRadius: 5.0,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
