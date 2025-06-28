import 'package:flutter/material.dart';
import 'my_button.dart';

class LessonTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const LessonTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MyButton(
          imagePath: "assets/images/Group 582.png",
          text: "Caption",
          onTap: () => onTabSelected(0),
        ),
        MyButton(
          imagePath: "assets/images/quiz.jpg",
          text: "Quiz",
          onTap: () => onTabSelected(1),
        ),
      ],
    );
  }
}