import 'package:flutter/material.dart';

class BuildIconWithText extends StatelessWidget {
  final IconData iconData;
  final String label;

  const BuildIconWithText(this.iconData, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
            onTap: () {},
            child: Icon(
              iconData,
              size: 20,
            )),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: label == "20%" ? Colors.red : const Color(0xff02457A),
          ),
        ),
      ],
    );
  }
}
