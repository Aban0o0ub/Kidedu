import 'package:flutter/material.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/course_box.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/info_container.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Instructor's name
            const Text(
              "Instructor Name",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF02457A),
              ),
            ),
            const SizedBox(height: 10),
            // Instructor's job title
            const Text(
              "Title",
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF02457A),
              ),
            ),
            const SizedBox(height: 30),
            // Bio container
            buildInfoContainer(
              header: "Bio",
              text:
                  "I’m a UI/UX designer with [X] years of experience, helping clients create intuitive digital experiences. As an instructor, I’m passionate about teaching practical skills in UI/UX design and user-centered solutions.",
            ),
            const SizedBox(height: 20),
            // Personal information container
            buildInfoContainer(
              header: "Personal Information",
              name: "Instructor Name",
              phone: "01000000000",
              email: "mohamed_ahmed22@gmail.com",
              governorate: "Assuit",
              title: "Title",
            ),
            const SizedBox(height: 20),
            // Experience container
            buildInfoContainer(
              header: "Experience",
              text:
                  ". Freelancer (2013- Present) \n Educational Application\n Grocery Application \n Food delivery Application \n E-commerce Application \n  . UI/UX Designer at International Company. \n . UI/UX Designer at Azzrk . \n . UI/UX Instructor at ITI . ",
            ),
            const SizedBox(height: 20),
            // "My Courses" title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "My Courses",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF02457A),
                ),
              ),
            ),
            const SizedBox(height: 7),
            // Horizontal scrollable list of course boxes
            SizedBox(
              height: 165, // Height of the boxes
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildCourseBox(
                    imagePath: "assets/images/ui.jpeg",
                    description: "UI basics for beginners",
                  ),
                  buildCourseBox(
                    imagePath: "assets/images/ux.jpeg",
                    description: "UX basics for beginners",
                  ),
                  buildCourseBox(
                    imagePath: "assets/images/uiux.jpeg",
                    description: "UI/UX full diploma",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Reviews",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF02457A),
                ),
              ),
            ),
            const SizedBox(height: 7),
            SizedBox(
              height: 142, // Height of the cards
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildHorizontalReviewCard(
                    name: "Ahmed Mostafa",
                    review: "Amazing instructor! Highly recommended.",
                    rating: 5,
                  ),
                  const SizedBox(width: 10),
                  buildHorizontalReviewCard(
                    name: "Sara Ali",
                    review: "Practical examples and clear explanations!",
                    rating: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // "Social Links" section
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with "Social Links" and Edit button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Social Links",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF02457A),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, color: Color(0xFF02457A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Space between row and images
                  // Social Icons (under the row)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/whatsapp.jpeg',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/facebook.jpeg',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/behance.jpeg',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/linkedin.jpeg',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/github.jpeg',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
