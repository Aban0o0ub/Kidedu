import 'package:flutter/material.dart';

class UpperStickersPhoto extends StatelessWidget {
  const UpperStickersPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 225,
        child: Image.asset(
          'assets/images/UpperStickers.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
