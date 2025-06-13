import 'dart:io';
import 'package:flutter/material.dart';

class PhotoOptionWidget extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onPickImage;

  const PhotoOptionWidget({
    super.key,
    required this.selectedImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Photo:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF02457A),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: onPickImage,
          child: const Text('Upload Photo'),
        ),
        const SizedBox(height: 10),
        if (selectedImage != null)
          Image.file(
            selectedImage!,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
      ],
    );
  }
}