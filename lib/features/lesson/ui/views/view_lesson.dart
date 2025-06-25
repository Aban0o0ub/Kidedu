import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import '../../../../core/injection/injection.dart';
import '../../data/models/lesson.dart';
import '../../logic/cubit/lesson_cubit.dart';
import '../widgets/my_button.dart';
import '../widgets/video_screen.dart';

class ViewLesson extends StatefulWidget {
  const ViewLesson({
    super.key,
    required this.sectionId,
    this.initialLessonId,
  });
  final String sectionId;
  final String? initialLessonId;
  @override
  State<ViewLesson> createState() => _ViewLessonState();
}

class _ViewLessonState extends State<ViewLesson> {
  late LessonCubit lessonCubit;
  int selectedIndex = 0;
  int selectedLessonIndex = 0;
  // int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    lessonCubit = getIt<LessonCubit>();
    lessonCubit.emitGetLesson(widget.sectionId);
  }

  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: lessonCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const ArrowBack(),
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(top: 63.0, left: 104),
                  child: Row(
                    children: [
                      ImageIcon(
                        AssetImage("assets/images/Group 583.png"),
                        color: Color(0xff02457A),
                      ),
                      const SizedBox(width: 10),
                      BlocBuilder<LessonCubit, LessonState>(
                        builder: (context, state) {
                          if (state is GetLessonSuccess &&
                              state.response.lessons.isNotEmpty) {
                            return Text(
                              "Lesson: ${state.response.lessons[selectedLessonIndex].name}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff02457A),
                              ),
                            );
                          }
                          return Text(
                            "Loading Lesson...",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff02457A),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: BlocBuilder<LessonCubit, LessonState>(
                    builder: (context, state) {
                      if (state is GetLessonLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is GetLessonFailure) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error loading lessons',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.error,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<LessonCubit>()
                                      .emitGetLesson(widget.sectionId);
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      } else if (state is GetLessonSuccess) {
                        final lessons = state.response.lessons;

                        if (widget.initialLessonId != null) {
                          final lessonIndex = lessons.indexWhere(
                              (lesson) => lesson.id == widget.initialLessonId);
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
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        final currentLesson = lessons[selectedLessonIndex];
                        return Column(
                          // باقي الكود...
                          children: [
                            // Lesson Selection (if more than one lesson)
                            // استبدل الجزء الحالي بده:

// Lesson Navigation (if more than one lesson)
                            if (lessons.length > 1)
                              Container(
                                height: 60,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Left Arrow (Previous Lesson)
                                    GestureDetector(
                                      onTap: selectedLessonIndex > 0
                                          ? () {
                                              setState(() {
                                                selectedLessonIndex--;
                                              });
                                            }
                                          : null,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: selectedLessonIndex > 0
                                              ? Color(0xff02457A)
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Icon(
                                          Icons.arrow_back_ios_new,
                                          color: selectedLessonIndex > 0
                                              ? Colors.white
                                              : Colors.grey[500],
                                          size: 20,
                                        ),
                                      ),
                                    ),

                                    // Current Lesson Name
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Color(0xff02457A)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          border: Border.all(
                                            color: Color(0xff02457A),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          currentLesson.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xff02457A),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),

                                    // Right Arrow (Next Lesson)
                                    GestureDetector(
                                      onTap: selectedLessonIndex <
                                              lessons.length - 1
                                          ? () {
                                              setState(() {
                                                selectedLessonIndex++;
                                              });
                                            }
                                          : null,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: selectedLessonIndex <
                                                  lessons.length - 1
                                              ? Color(0xff02457A)
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: selectedLessonIndex <
                                                  lessons.length - 1
                                              ? Colors.white
                                              : Colors.grey[500],
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Video/Image Section
                            VideoLesson(
                              key: ValueKey(
                                  '${currentLesson.id}_${currentLesson.youtubeVideoUrl}'),
                              videoLink: currentLesson.youtubeVideoUrl ?? "",
                              lessonName: currentLesson.name,
                              description: currentLesson.description,
                            ),

                            // Two Tabs: Caption & Quiz
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MyButton(
                                  imagePath: "assets/images/Group 582.png",
                                  text: "Caption",
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = 0;
                                    });
                                  },
                                ),
                                MyButton(
                                  imagePath: "assets/images/quiz.jpg",
                                  text: "Quiz",
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = 1;
                                    });
                                  },
                                ),
                              ],
                            ),

                            // Content based on selected tab
                            Expanded(
                              child: _buildSelectedContent(currentLesson),
                            ),
                          ],
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
    );
  }

  Widget _buildSelectedContent(LessonModel currentLesson) {
    switch (selectedIndex) {
      case 0: // Caption Tab
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان القسم
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xff02457A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Lesson Description",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 12),

              // محتوى الوصف
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // اسم الدرس
                        if (currentLesson.name.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              currentLesson.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff02457A),
                              ),
                            ),
                          ),

                        // خط فاصل
                        if (currentLesson.name.isNotEmpty &&
                            currentLesson.description != null &&
                            currentLesson.description!.isNotEmpty)
                          Container(
                            height: 1,
                            color: Colors.grey[300],
                            margin: const EdgeInsets.only(bottom: 12),
                          ),

                        // الوصف أو رسالة عدم وجود وصف
                        if (currentLesson.description != null &&
                            currentLesson.description!.isNotEmpty)
                          Text(
                            currentLesson.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          )
                        else
                          // رسالة لو مفيش وصف
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "No description available for this course",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case 1: // Quiz Tab
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان القسم
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xff02457A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Quiz",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 12),

              // محتوى الاختبار
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: currentLesson.quiz != null
                      ? Center(
                          child: Text(
                            "Quiz content will be displayed here",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.quiz_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No quiz available for this lesson",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
