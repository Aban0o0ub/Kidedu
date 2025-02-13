import 'package:flutter/material.dart';
import 'package:loginpage/features/home/ui/widgets/ads_part.dart';
import 'package:loginpage/features/home/ui/widgets/categories_item.dart';
import 'package:loginpage/features/home/ui/widgets/home_appbar.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/course_box.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';

class home extends StatelessWidget {
  const home({
    super.key,
    required this.courseTitles,
    required this.backgroundImages,
    required this.iconImages,
  });

  final List<String> courseTitles;
  final List<String> backgroundImages;
  final List<String> iconImages;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const HomeAppbar(),
          const SizedBox(height: 38),
          AdsPart(),
          const SizedBox(height: 20),
          // "My Courses" title
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                "Trending",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF02457A),
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildCourseBox(
                    description: "Swimming for toddlers",
                    imagePath:
                        "assets/images/representations-user-experience-interface-design(1).png"),
                buildCourseBox(
                    description: "Sciences",
                    imagePath: "assets/images/download.png"),
                buildCourseBox(
                    description: "Mathematics",
                    imagePath:
                        "assets/images/representations-user-experience-interface-design (1).png"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // "My Courses" title
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF02457A),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              shrinkWrap:
                  true, // Allows GridView to be scrollable within the SingleChildScrollView
              physics:
                  NeverScrollableScrollPhysics(), // Disable GridView's scrolling
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: courseTitles.length,
              itemBuilder: (context, index) {
                return CategoriesItem(
                  backgroundImage: backgroundImages[index],
                  iconImage: iconImages[index],
                  title: courseTitles[index],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // "My Courses" title
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                "Recent Reviews",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF02457A),
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: SizedBox(
              height: 150, // Height of the cards
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildHorizontalReviewCard(
                      name: "Ahmed Mostafa",
                      review: "Amazing instructor! Highly recommended.",
                      rating: 5,
                      courseName: "For Mathematics for kids",
                      instructorName: "Abanoub Atef"),
                  const SizedBox(width: 10),
                  buildHorizontalReviewCard(
                      name: "Sara Ali",
                      review: "Practical examples and clear explanations!",
                      rating: 4,
                      courseName: "For Mathematics for kids",
                      instructorName: "Abanoub Atef"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // "My Courses" title
        ],
      ),
    );
  }
}
