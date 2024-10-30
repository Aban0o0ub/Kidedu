import 'package:flutter/material.dart';

class Iconbutton extends StatelessWidget {
  const Iconbutton({
    super.key,
    required this.assetPath,
    required this.onPressed,
  });

  final String assetPath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        color: Color(0xFF9D9D9D),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Image.asset(assetPath),
        iconSize: 50,
        splashRadius: 30,
        onPressed: onPressed,
      ),
    );
  }
}
