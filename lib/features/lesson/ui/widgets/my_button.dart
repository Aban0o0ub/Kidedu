import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton({
    super.key,
    required this.imagePath,
    required this.text,
    required this.onTap,
  });
  String imagePath;
  String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xff02457A),
          ),
        ),
        child: Row(
          children: [
            ImageIcon(
              AssetImage(imagePath),
              color: Color(0xff02457A),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xff02457A),
              ),
            )
          ],
        ),
      ),
    );
  }
}
