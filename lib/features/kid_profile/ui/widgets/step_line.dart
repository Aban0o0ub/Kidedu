import 'package:flutter/material.dart';

class StepLine extends StatelessWidget {
  final bool isActive;

  const StepLine({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      color: isActive ? Colors.green : Colors.grey.shade300,
    );
  }
}