import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.text = 'LogIn',
    this.width = 200,
     this.child, 
  });

  final VoidCallback onPressed;
  final String text;
  final double? width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
        width: width,
        height: 55,
        child: Center(
          child: Text(
            text.tr(),
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
