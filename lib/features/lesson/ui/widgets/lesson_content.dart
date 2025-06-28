import 'package:flutter/material.dart';
import '../../data/models/lesson.dart';
import 'caption_content.dart';
import 'quiz_content.dart';

class LessonContent extends StatelessWidget {
  final int selectedIndex;
  final LessonModel currentLesson;

  const LessonContent({
    super.key,
    required this.selectedIndex,
    required this.currentLesson,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return CaptionContent(lesson: currentLesson);
      case 1:
        return QuizContent(lesson: currentLesson);
      default:
        return const SizedBox.shrink();
    }
  }
}
