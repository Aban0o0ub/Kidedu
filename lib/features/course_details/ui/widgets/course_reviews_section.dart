import 'package:flutter/material.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';

class CourseReviewsSection extends StatelessWidget {
  const CourseReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Reviews",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF02457A),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 142,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              buildHorizontalReviewCard(
                name: "Mirna Hanna",
                review: "Good course for my kid !",
                rating: 4,
              ),
              const SizedBox(width: 10),
              buildHorizontalReviewCard(
                name: "Mirna Hanna",
                review: "excellent content.",
                rating: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}