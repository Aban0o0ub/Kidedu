import 'package:flutter/material.dart';

import 'clickable_container.dart';

class AttachmentSelector extends StatelessWidget {
  final bool showOptions1;
  final bool showOptions2;
  final bool showOptions3;
  final bool showOptions4;
  final Function(int) onOptionSelected;

  const AttachmentSelector({
    super.key,
    required this.showOptions1,
    required this.showOptions2,
    required this.showOptions3,
    required this.showOptions4,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attachment :-',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF02457A),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          _buildOptionButton('Link', 1, Icons.youtube_searched_for, showOptions1),
          _buildOptionButton('Photos', 2, Icons.photo, showOptions2),
          _buildOptionButton('Quiz', 3, Icons.quiz, showOptions3),
          _buildOptionButton('Description', 4, Icons.description, showOptions4),
        ],
        ),
      ],
    );
  }

  Widget _buildOptionButton(String title, int index, IconData icon, bool isActive) {
    return ClickableContainer(
      title: title,
      index: index,
      isActive: isActive,
      onTap: () => onOptionSelected(index),
      icon: icon,
    );
  }
}