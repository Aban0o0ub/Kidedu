import 'package:flutter/material.dart';

class LinkOptionWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const LinkOptionWidget({
    super.key,
    required this.controller,
    this.hintText = 'add link',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'YouTube Link:',
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
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.url, 
        ),
      ],
    );
  }
}