import 'package:flutter/material.dart';

class RememberMeCheckbox extends StatelessWidget {
  const RememberMeCheckbox({
    super.key,
    required this.rememberMe,
    required this.onChanged,
  });

  final bool rememberMe;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: onChanged,
            ),
            const Text(
              'Remember me',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Forget Password?',
            style: TextStyle(
              color: Color(0xFF1877F2),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
