import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/core/widgets/appbar.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../add_course/data/models/Course_Model.dart';
import '../../../course_details/logic/cubit/course_details_cubit.dart';
import '../../logic/cubit/course_category_cubit.dart';
import '../widgets/nav_bar_visibility_controller.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({super.key});

  @override
  MyCoursesState createState() => MyCoursesState();
}

class MyCoursesState extends State<MyCourses> {
  late CourseCategoryCubit courseCategoryCubit;
  late CourseDetailsCubit courseDetailsCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NavBarVisibilityController.showNavBar();
    });
    courseCategoryCubit = getIt<CourseCategoryCubit>();
    courseDetailsCubit = getIt<CourseDetailsCubit>();
    courseCategoryCubit.emitGetKidCourses();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: courseCategoryCubit),
        BlocProvider.value(value: courseDetailsCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: "My Courses".tr()),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<CourseCategoryCubit, CourseCategoryState>(
                builder: (context, state) {
                  if (state is GetKidCoursesSuccess) {
                    final courses = state.kidCourses;
                    return courses.isEmpty
                        ? const EmptyCourses()
                        : KidCourses(courses: courses);
                  } else if (state is CourseCategoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetKidCoursesFailure) {
                    return const EmptyCourses();
                  }
                  return const SizedBox(); // Default empty view
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyCourses extends StatelessWidget {
  const EmptyCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Image.asset("assets/images/emptycourse.jpg", width: 400, height: 400),
          const Text(
            "You haven't joined a course yet",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color: Color(0xFF02457A)),
          ),
          const SizedBox(height: 120),
         
        ],
      ),
    );
  }
}

class KidCourses extends StatelessWidget {
  final List<CourseData> courses;
  const KidCourses({super.key, required this.courses});

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
      // Add slash if imagePath doesn't start with one
      String pathWithSlash = imagePath.startsWith('/') ? imagePath : '/$imagePath';
      return 'http://192.168.1.3:3000$pathWithSlash';
    }
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          CourseData course = courses[index];
          double progressValue = (course.progress ?? 0.0);
          if (progressValue > 1.0) {
            progressValue = progressValue / 100.0;
          }

          return GestureDetector(
            onTap: () {
              
              if (course.id != null && course.id!.isNotEmpty) {
                final courseDetailsCubit = context.read<CourseDetailsCubit>();
                context.push(
                  Routes.courseDetails,
                  extra: {
                    '_id': course.id,
                    'courseDetailsCubit': courseDetailsCubit,
                  },
                );
              }
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 20),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _getFirstValidImage(course.courseImages) != null
                              ? Image.network(
                                  _getFullImageUrl(_getFirstValidImage(course.courseImages)!),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/CourseDefaultPhoto.jpeg',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/CourseDefaultPhoto.jpeg',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.courseName ?? 'Unknown Course',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF02457A),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                course.instructor?['Name'] ??
                                    course.instructor?['name'] ??
                                    'No Instructor',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF666666),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Level Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF02457A).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  course.level ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF02457A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Progress Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF02457A),
                          ),
                        ),
                        Text(
                          "${(progressValue * 100).toInt()}%",
                          style: TextStyle(
                            fontSize: 16,
                            color: progressValue >= 1.0
                                ? const Color(0xFF198038)
                                : const Color(0xFF02457A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Progress Bar
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey[300],
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: progressValue.clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: LinearGradient(
                                  colors: progressValue >= 1.0
                                      ? [
                                          const Color(0xFF198038),
                                          const Color(0xFF22C55E)
                                        ]
                                      : [
                                          const Color(0xFF0043CE),
                                          const Color(0xFF3B82F6)
                                        ],
                                ),
                              ),
                            ),
                          ),
                          // Completion checkmark
                          if (progressValue >= 1.0)
                            Positioned(
                              right: 4,
                              top: -2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF198038),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 6,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Status Text
                    Row(
                      children: [
                        Icon(
                          progressValue >= 1.0
                              ? Icons.check_circle
                              : Icons.play_circle_outline,
                          color: progressValue >= 1.0
                              ? const Color(0xFF198038)
                              : const Color(0xFF02457A),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          progressValue >= 1.0
                              ? "Course Completed!"
                              : "In Progress",
                          style: TextStyle(
                            fontSize: 14,
                            color: progressValue >= 1.0
                                ? const Color(0xFF198038)
                                : const Color(0xFF02457A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
