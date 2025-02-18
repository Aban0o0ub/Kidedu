import 'package:flutter/material.dart';
import 'step_circle.dart';
import 'step_line.dart';

class AchievementProgress extends StatelessWidget {
  final double userPoints;
  final List<Map<String, dynamic>> trophies;

  const AchievementProgress({super.key, required this.userPoints, required this.trophies});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            StepCircle(isCompleted: userPoints >= trophies[0]['points']), // Bronze
            Expanded(child: StepLine(isActive: userPoints >= trophies[1]['points'])),
            StepCircle(isCompleted: userPoints >= trophies[1]['points']), // Silver
            Expanded(child: StepLine(isActive: userPoints >= trophies[2]['points'])),
            StepCircle(isCompleted: userPoints >= trophies[2]['points']), // Gold
          ],
        ),
        SizedBox(height: 8),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: trophies.map((trophy) => Text(trophy['title'], style: TextStyle(fontSize: 14))).toList(),
        ),

        if (userPoints < trophies.last['points'])
          Text(
            "(${trophies.firstWhere((trophy) => userPoints < trophy['points'])['points'] - userPoints} points remain)",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
      ],
    );
  }
}