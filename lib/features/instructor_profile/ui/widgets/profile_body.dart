import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/instructor_profile/logic/cubit/instructor_profile_cubit.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/course_box.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/info_container.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../course_details/logic/cubit/course_details_cubit.dart';
import '../../../reviews/logic/cubit/reviews_cubit.dart';
import '../../logic/cubit/my_courses_cubit.dart';

class ProfileBody extends StatefulWidget {
  final List<dynamic>? courses;
  final List<dynamic>? reviews;
  const ProfileBody({super.key, this.courses, this.reviews});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  CourseDetailsCubit courseDetailsCubit = getIt<CourseDetailsCubit>();

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
            if (state is InstructorProfileSuccess) {
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
                      context: context,
                      header: "Bio",
                      text: instructor.bio ?? "No bio available",
                    ),
                    const SizedBox(height: 20),
                    buildInfoContainer(
                      context: context,
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
                      context: context,
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
                    if (widget.courses != null)
                      _buildCoursesList(widget.courses!)
                    else
                      BlocBuilder<MyCoursesCubit, MyCoursesState>(
                        builder: (context, state) {
                          if (state is MyCoursesLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is GetMyCoursesFailure) {
                            return Center(child: Text("Error: ${state.error}"));
                          } else if (state is GetMyCoursesSuccess) {
                            final courses = state.courses;

                            if (courses.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No courses yet",
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              );
                            }

                            return _buildCoursesList(courses);
                          } else {
                            return const Center(
                                child: Text("No courses available."));
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
                    if (widget.reviews != null)
                      _buildReviewsList(widget.reviews!)
                    else
                      BlocBuilder<ReviewsCubit, ReviewsState>(
                        builder: (context, state) {
                          if (state is GetReviewsLoading) {
                            return const SizedBox(
                              height: 142,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (state is GetReviewsFailure) {
                            // التحقق من نوع الخطأ - 404 يعني مفيش reviews
                            bool isNoReviews = state.error.contains('404') ||
                                state.error.toLowerCase().contains('not found');

                            if (isNoReviews) {
                              // عرض رسالة "لا توجد مراجعات" بدل error
                              return const SizedBox(
                                height: 142,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.rate_review_outlined,
                                        color: Color(0xFF02457A),
                                        size: 32,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "No reviews yet",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF02457A),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Be the first to review this course!",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            bool isNetworkError =
                                state.error.toLowerCase().contains('network') ||
                                    state.error
                                        .toLowerCase()
                                        .contains('connection') ||
                                    state.error.toLowerCase().contains('timeout');

                            return SizedBox(
                              height: 142,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isNetworkError
                                          ? Icons.wifi_off
                                          : Icons.error_outline,
                                      color: Colors.red,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      isNetworkError
                                          ? "Check your internet connection"
                                          : "Failed to load reviews",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<ReviewsCubit>()
                                            .emitGetReviewsByInstructor();
                                      },
                                      child: const Text(
                                        "Tap to retry",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF02457A),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (state is GetReviewsSuccess) {
                            final reviews = state.reviews;
                            if (reviews.isEmpty) {
                              return const SizedBox(
                                height: 142,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.rate_review_outlined,
                                        color: Color(0xFF02457A),
                                        size: 32,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "No reviews yet",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF02457A),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Be the first to review this course!",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return _buildReviewsList(reviews);
                          } else {
                            return const SizedBox(
                              height: 142,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.rate_review_outlined,
                                      color: Color(0xFF02457A),
                                      size: 32,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "No reviews available",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF02457A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
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
            } else if (state is InstructorProfileFailure) {
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

  Widget _buildCoursesList(List<dynamic> courses) {
    return SizedBox(
      height: 165,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return GestureDetector(
            onTap: () {
              if (course.id != null && course.id!.isNotEmpty) {
                context.push(
                  Routes.courseDetails,
                  extra: {
                    '_id': course.id,
                    'courseDetailsCubit': courseDetailsCubit,
                  },
                );
              }
            },
            child: buildCourseBox(
              imagePath: (courses[index].courseImage != null &&
                          courses[index]
                              .courseImage!
                              .isNotEmpty)
                      ? "assets/images/${courses[index].courseImage}"
                      : "assets/images/CourseDefaultPhoto.jpeg",
              courseName: courses[index].courseName ?? 'No Course Name',
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewsList(List<dynamic> reviews) {
    return SizedBox(
      height: 142,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Padding(
            padding: EdgeInsets.only(
                right: index < reviews.length - 1 ? 10 : 0),
            child: buildHorizontalReviewCard(
              name: review.displayKidName,
              review: review.reviewText,
              rating: review.rating,
              courseName: review.displayCourseName,
            ),
          );
        },
      ),
    );
  }
}
