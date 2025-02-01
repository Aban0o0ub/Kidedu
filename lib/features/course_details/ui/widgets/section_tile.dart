import 'package:flutter/material.dart';

class BuildSectionTile extends StatelessWidget {
  final String title;

  const BuildSectionTile(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 9.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFF02457A),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF02457A),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Color(0xFF9D9D9D),
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
