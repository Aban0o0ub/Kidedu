import 'package:flutter/material.dart';

Widget buildHorizontalReviewCard({
  required String name,
  required String review,
  required int rating,
  String? courseName,
  String? instructorName,
  String? kidImageUrl, // Keep for compatibility but unused
}) {
  // Function to get first two letters of name
  String getInitials(String name) {
    if (name.isEmpty) return 'UK';
    String cleanName = name.trim();
    if (cleanName.length == 1) return cleanName.toUpperCase();
    return cleanName.substring(0, 2).toUpperCase();
  }

  return Container(
    width: 312,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFF02457A), width: 1),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile circle with initials instead of image
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFF02457A), // Blue background
          child: Text(
            getInitials(name),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Review text
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF02457A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (courseName != null)
                Text(
                  courseName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF02457A),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 4),
              // Rating stars
              Row(
                children: List.generate(
                  rating,
                  (index) => const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                review,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF02457A),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
