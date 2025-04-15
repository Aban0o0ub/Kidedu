import 'package:flutter/material.dart';

import '../../../home/ui/widgets/course_card.dart';

class CartDetails extends StatelessWidget {
  const CartDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
                SizedBox(height: 30),

        Image.asset('assets/images/cart.jpg',
            width: 352, height: 244, fit: BoxFit.cover),
        SizedBox(height: 16),
       SizedBox(
          height: 300, // ✅ تعيين ارتفاع ثابت
          child: CourseList(),
        ),
      ],
    );
  }
}

// ignore: use_key_in_widget_constructors
class CourseList extends StatelessWidget {
  final List<Map<String, dynamic>> courses = [
    {
      //'image': 'assets/images/swimming.jpg',
      'name': 'Arabic',
      'instructor': 'Marena Safwat',
      'status': 'Online',
      'price': '49.99', // ✅ إزالة علامة $ ليصبح رقمًا صحيحًا
    },
    {
      //'image': 'assets/images/science.jpg',
      'name': 'English',
      'instructor': 'Mirna Hanna',
      'status': 'Offline',
      'price': '79.99',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return CourseCard(
          courseImage: course['image'],
          courseName: course['name'] ?? "Unknown Course",
          instructor: course['instructor'],
          description: "This is a course about ${course['name']}",
          price: num.tryParse(course['price'].toString()) ?? 0, // ✅ تصحيح النوع
          availability: course['status'] ?? "unavailable",
        );
      },
    );
  }
}