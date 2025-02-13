import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoriesItem extends StatelessWidget {
  CategoriesItem({
    super.key,
    required this.backgroundImage,
    required this.iconImage,
    required this.title,
  });
  String backgroundImage;
  String iconImage;
  String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: 120,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover, // Ensures it fills the SizedBox
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Prevents stretching
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  alignment: Alignment.bottomLeft,
                  iconImage,
                  height: 40, // Adjust size as needed
                  width: 40,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0, right: 3),
                  child: Text(
                    textAlign: TextAlign.end,
                    title,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Color(0xFF02457A),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
