import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: Color(0xFF02457A),
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
        ),
        SizedBox(width: 8),
        Text(
          "Or",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF02457A),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: Color(0xFF02457A),
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
        ),
      ],
    );
  }
}
