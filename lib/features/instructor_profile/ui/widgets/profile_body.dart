import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/instructor_profile/logic/cubit/instructor_profile_cubit.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/course_box.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/info_container.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/blue_section_container.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../course_details/logic/cubit/course_details_cubit.dart';
import '../../../reviews/logic/cubit/reviews_cubit.dart';
import '../../logic/cubit/my_courses_cubit.dart';

class ProfileBody extends StatefulWidget {
  final List<dynamic>? courses;
  final List<dynamic>? reviews;
  final bool showEditIcons;
  
  const ProfileBody({
    super.key, 
    this.courses, 
    this.reviews,
    this.showEditIcons = true, 
  });

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  CourseDetailsCubit courseDetailsCubit = getIt<CourseDetailsCubit>();

  String? _getFirstValidImage(List<String>? images) {
    if (images == null || images.isEmpty) return null;
    
    for (String image in images) {
      if (image.isNotEmpty) {
        return image;
      }
    }
    return null;
  }
  
  String _getFullImageUrl(String imagePath) {
    if (imagePath.startsWith('/uploads/')) {
      return 'http://192.168.1.3:3000$imagePath';
    } else if (!imagePath.startsWith('http')) {
      return 'http://192.168.1.3:3000$imagePath';
    }
    return imagePath;
  }

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
                      showEditButton: widget.showEditIcons,
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
                      showEditButton: widget.showEditIcons,
                    ),
                    const SizedBox(height: 20),
                    buildInfoContainer(
                      context: context,
                      header: "Experience",
                      text: instructor.experience ?? "No experience available",
                      showEditButton: widget.showEditIcons,
                    ),
                    const SizedBox(height: 20),
                    BlueSectionContainer(
                      title: "My Courses",
                      content: widget.courses != null
                          ? _buildCoursesListWithWhiteStyle(widget.courses!)
                          : BlocBuilder<MyCoursesCubit, MyCoursesState>(
                              builder: (context, state) {
                                if (state is MyCoursesLoading) {
                                  return const SizedBox(
                                    height: 165,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                } else if (state is GetMyCoursesFailure) {
                                  return SizedBox(
                                    height: 165,
                                    child: Center(
                                      child: Text(
                                        "Error: ${state.error}",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                } else if (state is GetMyCoursesSuccess) {
                                  final courses = state.courses;

                                  if (courses.isEmpty) {
                                    return const SizedBox(
                                      height: 165,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.school_outlined,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "No courses yet",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return _buildCoursesListWithWhiteStyle(courses);
                                } else {
                                  return const SizedBox(
                                    height: 165,
                                    child: Center(
                                      child: Text(
                                        "No courses available.",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                    ),
                    const SizedBox(height: 30),
                    BlueSectionContainer(
                      title: "Reviews",
                      content: widget.reviews != null
                          ? _buildReviewsList(widget.reviews!)
                          : BlocBuilder<ReviewsCubit, ReviewsState>(
                              builder: (context, state) {
                                if (state is GetReviewsLoading) {
                                  return const SizedBox(
                                    height: 142,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
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
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "No reviews yet",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "Be the first to review!",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return SizedBox(
                                    height: 142,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.error_outline,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Failed to load reviews",
                                            style: const TextStyle(
                                              fontSize: 14, 
                                              color: Colors.white,
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
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "No reviews yet",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
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
                                      child: Text(
                                        "No reviews available.",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                    ),
                    const SizedBox(height: 30),
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
              imagePath: _getFirstValidImage(courses[index].courseImages) != null 
                          ? _getFullImageUrl(_getFirstValidImage(courses[index].courseImages)!)
                          : "assets/images/CourseDefaultPhoto.jpeg",
              courseName: courses[index].courseName ?? 'No Course Name',
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoursesListWithWhiteStyle(List<dynamic> courses) {
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
              imagePath: _getFirstValidImage(courses[index].courseImages) != null 
                          ? _getFullImageUrl(_getFirstValidImage(courses[index].courseImages)!)
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