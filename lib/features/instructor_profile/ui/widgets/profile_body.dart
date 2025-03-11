import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/instructor_profile/logic/cubit/instructor_profile_cubit.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/course_box.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/info_container.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';

import '../../logic/cubit/my_courses_cubit.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
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
        child: BlocBuilder<InstructorProfileCubit, InstructorProfileState>(
          builder: (context, state) {
            if (state is GetSingleInstructor) {
              var instructor = state.instructor;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      instructor.name ?? "Instructor Name",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF02457A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      instructor.title ?? "Title",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color(0xFF02457A),
                      ),
                    ),
                    const SizedBox(height: 30),
                    buildInfoContainer(
                      header: "Bio",
                      text: instructor.bio ?? "No bio available",
                    ),
                    const SizedBox(height: 20),
                    buildInfoContainer(
                      header: "Personal Information",
                      name: instructor.name ?? "Instructor Name",
                      phone: instructor.phoneNumber ?? "No phone available",
                      email: instructor.email ?? "No email available",
                      governorate:
                          instructor.governorate ?? "No governorate available",
                      title: instructor.title ?? "Title",
                    ),
                    const SizedBox(height: 20),
                    buildInfoContainer(
                      header: "Experience",
                      text: instructor.experience ?? "No experience available",
                    ),
                    const SizedBox(height: 20),
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
                   BlocBuilder<MyCoursesCubit, MyCoursesState>(
  builder: (context, state) {
    if (state is MyCoursesLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GetMyCoursesFailure) {
      return Center(child: Text("Error: ${state.error}"));
    } else if (state is GetMyCoursesSuccess) {
      final courses = state.courses;

      if (courses.isEmpty) {
        return const Center(
          child: Text(
            "No courses yet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      }

      return SizedBox(
        height: 165,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return buildCourseBox(
              imagePath: courses[index].courseImage != null
                  ? "assets/images/${courses[index].courseImage}"
                  : "assets/images/CourseDefaultPhoto.jpeg",
              courseName: courses[index].courseName ?? 'No Course Name',
            );
          },
        ),
      );
    } else {
      return const Center(child: Text("No courses available."));
    }
  },
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
                            review:
                                "Practical examples and clear explanations!",
                            rating: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  icon: const Icon(Icons.edit,
                                      color: Color(0xFF02457A)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
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
                          ]),
                    )
                  ]);
            } else if (state is MyFailure) {
              return Center(
                child: Text(
                  "There is an error: ${state.error}",
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF02457A)),
            );
          },
        ),
      ),
    );
  }
}
