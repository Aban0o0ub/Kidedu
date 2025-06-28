import 'package:flutter/material.dart';

Widget buildHorizontalReviewCard({
  required String name,
  required String review,
  required int rating,
  String? courseName,
  String? instructorName,
}) {
  return Container(
    width: 312,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFF02457A), width: 1),
    ),
    child: Row(
      children: [
        // Profile picture (optional)
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage("assets/images/kidprofile.jpeg"),
        ),
        const SizedBox(width: 10),
        // Review text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF02457A),
                ),
              ),
              const SizedBox(height: 8),
              if (courseName != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    courseName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF02457A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              // Rating stars
              Row(
                children: List.generate(
                  rating,
                  (index) => const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 15,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                review,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF02457A),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
