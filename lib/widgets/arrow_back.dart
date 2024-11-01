import 'package:flutter/material.dart';

class ArrowBack extends StatelessWidget {
  const ArrowBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 75,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 228, 228, 228),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(2, 2),
              blurRadius: 4.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 27,
          ),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
