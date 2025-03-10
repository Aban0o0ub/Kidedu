import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CourseCard extends StatelessWidget {
   String? courseImage;
  final String courseName;
   String? instructor;
  final String description;
  final num price;
  final String availability;

   CourseCard({
    super.key,
     this.courseImage,
    required this.courseName,
     this.instructor,
    required this.description,
    required this.price,
    required this.availability,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 🔹 صورة الكورس
           ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: courseImage != null && courseImage!.isNotEmpty
      ? Image.network(courseImage!, width: 80, height: 80, fit: BoxFit.cover)
      : Image.asset("assets/images/CourseDefaultPhoto.jpeg", width: 80, height: 80, fit: BoxFit.cover),
),

            const SizedBox(width: 12),
            // 🔹 تفاصيل الكورس
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(courseName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          //print("Learn more clicked");
                        },
                        child: const Text("Learn more", style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
Text(instructor != null ? "By $instructor" : "No instructor", style: const TextStyle(color: Colors.grey)),
                  Text(description, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text("\$${price.toString()}" , style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text(availability, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //print("Added to cart");
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Add to cart", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}