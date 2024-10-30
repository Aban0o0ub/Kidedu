import 'package:flutter/material.dart';

class AuthPrompt extends StatelessWidget {
  final String questionText;
  final String actionText;
  final VoidCallback onActionPressed;

  const AuthPrompt({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          questionText,
          style: const TextStyle(
            color: Color(0xFF02457A),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onActionPressed,
          child: Text(
            actionText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1877F2),
            ),
          ),
        ),
      ],
    );
  }
}
