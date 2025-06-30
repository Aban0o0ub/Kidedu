import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import 'package:loginpage/features/lesson/logic/cubit/quiz_cubit.dart';
import '../../../../core/injection/injection.dart';
import '../../../add_course/data/models/Course_Model.dart';
import '../../../course_details/logic/cubit/course_details_cubit.dart';
import '../../../reviews/logic/cubit/reviews_cubit.dart';
import '../../data/models/lesson.dart';
import '../../logic/cubit/lesson_cubit.dart';
import '../widgets/lessons_tabs.dart';
import '../widgets/video_screen.dart';
import '../widgets/lesson_header.dart';
import '../widgets/lesson_navigation.dart';
import '../widgets/lesson_content.dart';
import '../widgets/error_view.dart';

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
    if (widget.courseId != null) {
      final request = EndCourseRequest(
        courseId: widget.courseId!,
        lessonId: currentLesson.id,
      );

      courseDetailsCubit.emitKidEndCourse(request);
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
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CourseDetailsCubit, CourseDetailsState>(
            listener: (context, state) {
              if (state is EndCourseSuccess) {
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
          body: Stack(
            children: [
              const ArrowBack(),
              Column(
                children: [
                  LessonHeader(selectedLessonIndex: selectedLessonIndex),
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
                            onRetry: () => lessonCubit.emitGetLesson(widget
                                .sectionId), // Also use local instance here
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

                          // التعديل في الجزء ده من build method - استخدام SingleChildScrollView
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
