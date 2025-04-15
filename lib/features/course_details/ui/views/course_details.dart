import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/features/add_course/ui/widgets/header_image.dart';
import 'package:loginpage/features/course_details/logic/cubit/course_details_cubit.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/info_container.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/arrow_back.dart';
import '../widgets/pair_page.dart';
import '../widgets/section_tile.dart';

// ignore: must_be_immutable
class CourseDetails extends StatefulWidget {
  const CourseDetails({super.key});

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  late CourseDetailsCubit courseDetailsCubit;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = GoRouterState.of(context).extra as Map<String, dynamic>?;

    if (arguments != null) {
      final id = arguments['_id'];

      if (id is String && id.isNotEmpty) {
        courseDetailsCubit = getIt<CourseDetailsCubit>();
        courseDetailsCubit.emitGetSingleCourse(id);
      } else {
        throw Exception('ID NOT FOUND');
      }
    } else {
      throw Exception('No arguments passed to the course details page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: courseDetailsCubit,
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    const HeaderImage(),
                    const Positioned(
                      top: 20,
                      left: 10,
                      child: ArrowBack(),
                    ),
                    Positioned(
                      top: 40,
                      right: 10,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.monetization_on,
                              size: 24,
                              color: Color(0xFF02457A),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.share,
                              size: 24,
                              color: Color(0xFF02457A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
                  builder: (context, state) {
                    if (state is GetCourseSuccess) {
                      var course = state.course;
                      //var instructor = state.instructor;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Center(
                              child: Text(
                                course.courseName ??
                                    "Course Name", // Course name from the data
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF02457A),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                context.push(Routes.instructorProfilePage);
                              },
                              child: Center(
                                child: Text(
                                  course.courseName ??
                                      "Instructor Name", // Instructor name from the data
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xff1877F2),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff1877F2),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xFF02457A), width: 1),
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
                                    text2: course.offer ?? "20%",
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            buildInfoContainer(
                              header: "Description",
                              text: course.description ??
                                  "No description available",
                            ),
                            const SizedBox(height: 15),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Content",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF02457A),
                                  ),
                                ),
                                Icon(Icons.add_outlined,
                                    color: Color(0xFF02457A), size: 24),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return BuildSectionTile(
                                    "Section title ${index + 1}");
                              },
                            ),
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
                            const SizedBox(height: 35),
                            CustomButton(
                              onPressed: () {},
                              text: "Edit course",
                              width: 384,
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      );
                    } else if (state is GetCourseFailure) {
                      return Center(
                        child: Text(
                          "There was an error: ${state.error}",
                          style:
                              const TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      );
                    }
                    return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF02457A)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
