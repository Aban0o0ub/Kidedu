import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/features/course_details/logic/cubit/course_details_cubit.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/info_container.dart';
import '../../../../core/routing/routes.dart';
import '../../../lesson/logic/cubit/lesson_cubit.dart';
import '../../../lesson/logic/cubit/section_cubit.dart';
import '../../../reviews/logic/cubit/reviews_cubit.dart';
import '../widgets/course_header_section.dart';
import '../widgets/course_info_card.dart';
import '../widgets/course_content_section.dart';
import '../widgets/course_reviews_section.dart';
import '../widgets/course_action_buttons.dart';
import '../widgets/delete_course_dialog.dart';
import '../widgets/end_course_dialog.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails({super.key});

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  bool isCourseEnded = false;
  late CourseDetailsCubit courseDetailsCubit;
  late SectionCubit sectionCubit;
  late LessonCubit lessonCubit;
  late ReviewsCubit reviewsCubit;
  String courseId = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = GoRouterState.of(context).extra as Map<String, dynamic>?;

    if (arguments != null) {
      final id = arguments['_id'];

      if (id is String && id.isNotEmpty) {
        courseId = id;
        courseDetailsCubit = getIt<CourseDetailsCubit>();
        sectionCubit = getIt<SectionCubit>();
        lessonCubit = getIt<LessonCubit>();
        reviewsCubit = getIt<ReviewsCubit>();

        courseDetailsCubit.emitGetSingleCourse(id);
        sectionCubit.emitGetSection(id);
        reviewsCubit.emitGetReviewsByCourse(courseId);
      } else {
        throw Exception('ID NOT FOUND');
      }
    } else {
      throw Exception('No arguments passed to the course details page');
    }
  }

  void _showEndCourseDialog() {
    showEndCourseDialog(
      context: context,
      courseId: courseId,
      courseDetailsCubit: courseDetailsCubit,
      onCourseEnded: () {
        setState(() {
          isCourseEnded = true;
        });
      },
    );
  }

  void _showDeleteCourseDialog() {
    showDeleteCourseDialog(
      context: context,
      courseId: courseId,
      courseDetailsCubit: courseDetailsCubit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: courseDetailsCubit),
        BlocProvider.value(value: sectionCubit),
        BlocProvider.value(value: lessonCubit),
        BlocProvider.value(value: reviewsCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CourseHeaderSection(),
                BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
                  builder: (context, state) {
                    if (state is GetCourseSuccess) {
                      var course = state.course;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),

                            // Course Title and Instructor
                            _buildCourseTitleSection(course),

                            const SizedBox(height: 15),

                            // Course Info Card
                            CourseInfoCard(course: course),

                            const SizedBox(height: 15),

                            // Description
                            buildInfoContainer(
                              context: context,
                              header: "Description",
                              text: course.description ??
                                  "No description available",
                            ),

                            const SizedBox(height: 15),

                            // Content Section (only for instructors)
                            CourseContentSection(
                              courseId: courseId,
                              isCourseEnded: isCourseEnded,
                              onEndCourse: _showEndCourseDialog,
                            ),

                            // Reviews Section
                            CourseReviewsSection(courseId: courseId),

                            const SizedBox(height: 35),

                            // Action Buttons
                            CourseActionButtons(
                              onUpdateCourse: () {
                                // Add your update course logic here
                              },
                              onDeleteCourse: _showDeleteCourseDialog,
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

  Widget _buildCourseTitleSection(course) {
    return Column(
      children: [
        Center(
          child: Text(
            course.courseName ?? "Course Name",
            style: const TextStyle(
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
              course.courseName ?? "Instructor Name",
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Color(0xff1877F2),
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xff1877F2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
