import 'package:flutter/material.dart';

class CaptionOptionWidget extends StatelessWidget {
  final TextEditingController controller;

  const CaptionOptionWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Caption:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF02457A),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter caption',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}