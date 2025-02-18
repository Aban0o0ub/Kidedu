import 'package:flutter/material.dart';

class StepCircle extends StatelessWidget {
  final bool isCompleted;

  const StepCircle({super.key, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: isCompleted ? Colors.green : Colors.grey.shade300,
      child: isCompleted
          ? Icon(Icons.check, color: Colors.white, size: 14)
          : Container(),
    );
  }
}