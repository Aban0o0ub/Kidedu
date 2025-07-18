import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/widgets/appbar.dart';
import 'package:loginpage/features/lesson/logic/cubit/quiz_cubit.dart';
import '../../../../core/injection/injection.dart';
import '../../../add_course/data/models/Course_Model.dart';
import '../../../course_details/logic/cubit/course_details_cubit.dart';
import '../../../kid_profile/ui/widgets/notification_helper.dart';
import '../../../reviews/logic/cubit/reviews_cubit.dart';
import '../../data/models/lesson.dart';
import '../../logic/cubit/lesson_cubit.dart';
import '../widgets/lessons_tabs.dart';
import '../widgets/video_screen.dart';
import '../widgets/lesson_navigation.dart';
import '../widgets/lesson_content.dart';
import '../widgets/error_view.dart';
import '../../../login/logic/cubit/my_cubit.dart';

class ViewLesson extends StatefulWidget {
  const ViewLesson(
      {super.key,
      required this.sectionId,
      this.initialLessonId,
      this.courseId});
  final String sectionId;
  final String? initialLessonId;
  final String? courseId;

  @override
  State<ViewLesson> createState() => _ViewLessonState();
}

class _ViewLessonState extends State<ViewLesson> {
  late LessonCubit lessonCubit;
  late CourseDetailsCubit courseDetailsCubit;
  late ReviewsCubit reviewsCubit;
  late QuizCubit quizCubit;
  int selectedIndex = 0;
  int selectedLessonIndex = 0;

  @override
  void initState() {
    super.initState();
    courseDetailsCubit = getIt<CourseDetailsCubit>();
    reviewsCubit = getIt<ReviewsCubit>();
    lessonCubit = getIt<LessonCubit>();
    quizCubit = getIt<QuizCubit>();
    lessonCubit.emitGetLesson(widget.sectionId);
  }

  void _handleLessonNavigation(int newIndex, LessonModel currentLesson) {
    // Only proceed if we have both courseId and lessonId
    if (widget.courseId != null && widget.courseId!.isNotEmpty) {
      final request = EndCourseRequest(
        courseId: widget.courseId!,
        lessonId: currentLesson.id,
      );

      // Only call kidEndCourse if the role is 'kid'
      final currentRole = context.read<RoleCubit>().state;
      if (currentRole == 'kid') {
        courseDetailsCubit.emitKidEndCourse(request);
      }
    }

    setState(() {
      selectedLessonIndex = newIndex;
    });
  }

  void _handleTabSelection(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: lessonCubit),
        BlocProvider.value(value: courseDetailsCubit),
        BlocProvider.value(value: reviewsCubit),
        BlocProvider.value(value: quizCubit),
        BlocProvider.value(value: getIt<RoleCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CourseDetailsCubit, CourseDetailsState>(
            listener: (context, state) {
              if (state is EndCourseSuccess) {
                NotificationHelper.showCourseCompletedNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.endcourse.message),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is EndCourseFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(title: "View Lessnon"),
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: BlocBuilder<LessonCubit, LessonState>(
                      builder: (context, state) {
                        if (state is GetLessonLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is GetLessonFailure) {
                          return ErrorView(
                            error: state.error,
                            onRetry: () =>
                                lessonCubit.emitGetLesson(widget.sectionId),
                          );
                        }
                        if (state is GetLessonSuccess) {
                          final lessons = state.response.lessons;

                          // Handle initial lesson selection
                          if (widget.initialLessonId != null) {
                            final lessonIndex = lessons.indexWhere((lesson) =>
                                lesson.id == widget.initialLessonId);
                            if (lessonIndex != -1 && selectedLessonIndex == 0) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  selectedLessonIndex = lessonIndex;
                                });
                              });
                            }
                          }
                          if (lessons.isEmpty) {
                            return const Center(
                              child: Text(
                                'No lessons available',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            );
                          }
                          final currentLesson = lessons[selectedLessonIndex];
                          
                          
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                if (lessons.length > 1)
                                  LessonNavigation(
                                    lessons: lessons,
                                    selectedLessonIndex: selectedLessonIndex,
                                    currentLesson: currentLesson,
                                    courseId: widget.courseId,
                                    onNavigate: _handleLessonNavigation,
                                  ),
                                VideoLesson(
                                  key: ValueKey(
                                      '${currentLesson.id}_${currentLesson.youtubeVideoUrl}'),
                                  videoLink:
                                      currentLesson.youtubeVideoUrl ?? "",
                                  lessonName: currentLesson.name,
                                  description: currentLesson.description,
                                  lesson: currentLesson, // Pass the lesson for images
                                ),
                                LessonTabs(
                                  selectedIndex: selectedIndex,
                                  onTabSelected: _handleTabSelection,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height *
                                            0.4,
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.8,
                                  ),
                                  child: LessonContent(
                                    selectedIndex: selectedIndex,
                                    currentLesson: currentLesson,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
