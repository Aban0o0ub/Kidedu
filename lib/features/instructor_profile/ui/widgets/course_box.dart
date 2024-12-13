import 'package:flutter/material.dart';

Widget buildCourseBox(
    {required String imagePath, required String description}) {
  return Container(
    width: 148.05, // width of the box
    height: 165, // height of the box
    margin: const EdgeInsets.only(left: 20), // gap between boxes
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      border: Border.all(color: Colors.black, width: 1),
    ),
    child: Column(
      children: [
        // Image at the top
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Description at the bottom
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF02457A),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
