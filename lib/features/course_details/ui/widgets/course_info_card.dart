import 'package:flutter/material.dart';
import '../widgets/pair_page.dart';

class CourseInfoCard extends StatelessWidget {
  final dynamic course;
  
  const CourseInfoCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF02457A),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Wrap(
        runSpacing: 16,
        children: [
          BuildPairPage(
            icon1: Icons.stairs,
            text1: course.level ?? "course level",
            icon2: Icons.access_time,
            text2: "duration",
          ),
          BuildPairPage(
            icon1: Icons.category,
            text1: course.category ?? "Mathematics",
            icon2: Icons.location_on,
            text2: course.availability ?? "Online",
          ),
          BuildPairPage(
            icon1: Icons.people,
            text1: "Kids count",
            icon2: Icons.star,
            text2: "rating",
          ),
          BuildPairPage(
            icon1: Icons.monetization_on,
            text1: (course.price ?? "800").toString(),
            icon2: Icons.discount,
            text2: (course.offer ?? "20%").toString(),
          ),
        ],
      ),
    );
  }
}