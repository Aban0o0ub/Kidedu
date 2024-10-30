import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.text = 'LogIn',
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Button Pressed: $text");
        onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1877F2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        width: 200,
        height: 55,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
