import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/arrow_back.dart';
import '../../../add_course/data/models/Course_Model.dart';
import '../../logic/cubit/course_category_cubit.dart';
import 'home_page.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  late CourseCategoryCubit courseCategoryCubit;
  // List<CourseData> kidCourses = [];

  @override
  void initState() {
    super.initState();
    courseCategoryCubit = getIt<CourseCategoryCubit>();
    courseCategoryCubit.emitGetKidCourses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: courseCategoryCubit,
      child: Scaffold(
        body: Column(
          children: [
            ArrowBack(),
            Expanded(
              child: BlocBuilder<CourseCategoryCubit, CourseCategoryState>(
                builder: (context, state) {
                  if (state is GetKidCoursesSuccess) {
                    final courses = state.kidCourses;
                    print(courses);
                    return courses.isEmpty
                        ? EmptyCourses()
                        : KidCourses(courses: courses);
                  } else if (state is CourseCategoryLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is GetKidCoursesFailure) {
                    return EmptyCourses();
                  }
                  return SizedBox(); // Default empty view
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
          SizedBox(height: 25),
          Image.asset("assets/images/emptycourse.jpg", width: 400, height: 400),
          Text(
            "You haven't joined a course yet",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Color(0xFF02457A)),
          ),
          SizedBox(height: 120),
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              context.push(Routes.homePage, extra: {
                'courseTitles': HomePage.courseTitles,
                'backgroundImages': HomePage.backgroundImages,
                'iconImages': HomePage.iconImages,
              });
            },
            child: Text(
              "Explore now",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Course {
  final String title;
  final String author;
  final double progress;
  final String image;

  Course({
    required this.title,
    required this.author,
    required this.progress,
    required this.image,
  });
}

class KidCourses extends StatelessWidget {
  final List<CourseData> courses;
  const KidCourses({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        CourseData course = courses[index];
        return Card(
          margin: EdgeInsets.only(bottom: 20),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: (course.courseImage != null &&
                              course.courseImage!.isNotEmpty)
                          ? Image.network(
                              course.courseImage!,
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
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.courseName ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF02457A),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            course.instructor?['name'] ?? 'No Instructor',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF02457A),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    LinearProgressIndicator(
                      value: course.progress ?? 0.0,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        course.progress == 1.0
                            ? Color(0xFF198038)
                            : Color(0xFF0043CE),
                      ),
                    ),
                    if (course.progress == 1.0)
                      Positioned(
                        left: -5,
                        child: Icon(
                          Icons.check_circle,
                          color: Color(0xFF198038),
                          size: 24,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "${(course.progress! * 100).toInt()}% Completed",
                  style: TextStyle(
                    fontSize: 16,
                    color: course.progress == 1.0
                        ? Color(0xFF198038)
                        : Color(0xFF02457A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF02457A),
      selectedItemColor: Color(0xFF02457A),
      unselectedItemColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: 3,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
      ],
    );
  }
}
