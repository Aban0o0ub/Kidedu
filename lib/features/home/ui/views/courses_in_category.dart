import 'package:flutter/material.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';

import 'cart.dart';


class CoursesInCategory extends StatelessWidget {
  const CoursesInCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Column(

        children: [
          ArrowBack(),
          SizedBox(height: 35),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/education.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Education",
            style: TextStyle(fontSize: 46, fontWeight: FontWeight.bold),
          ),
          //SizedBox(height: 16),
          Expanded(
            child: CourseListWidget(), 
          ),
        ],
      ),
    );
  }
}

