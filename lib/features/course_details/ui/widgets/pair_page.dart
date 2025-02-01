import 'package:flutter/material.dart';
import 'icon_with_text.dart';

class BuildPairPage extends StatelessWidget {
  final IconData icon1;
  final String text1;
  final IconData icon2;
  final String text2;

  const BuildPairPage({
    super.key,
    required this.icon1,
    required this.text1,
    required this.icon2,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: BuildIconWithText(icon1, text1)),
        Expanded(child: BuildIconWithText(icon2, text2)),
      ],
    );
  }
}
