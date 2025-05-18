import 'package:flutter/material.dart';

class ClickableContainer extends StatelessWidget {
  const ClickableContainer({
    super.key,
    required this.title,
    required this.index,
    required this.isActive,
    required this.onTap,
    required this.icon,
  });

  final String title;
  final int index;
  final bool isActive;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF02457A) : Colors.white,
          border: Border.all(
            color: const Color(0xFF02457A),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFF02457A),
              size: 18,
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF02457A),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 5),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}