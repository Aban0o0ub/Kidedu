import 'package:flutter/material.dart';

class profileitem extends StatelessWidget {
  const profileitem({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  final String image;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        image,
        width: 40,
        height: 40,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          color: Color(0xFF02457A),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: Color(0xFF02457A),
      ),
      onTap: onTap,
    );
  }
}
