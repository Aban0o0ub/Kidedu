import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../lesson/data/models/section.dart';
import '../../../lesson/logic/cubit/lesson_cubit.dart';

class ExpandableSectionTile extends StatefulWidget {
  final SectionModel section;

  const ExpandableSectionTile({
    super.key,
    required this.section,
  });

  @override
  State<ExpandableSectionTile> createState() => _ExpandableSectionTileState();
}

class _ExpandableSectionTileState extends State<ExpandableSectionTile> {
  bool isExpanded = false;
  late LessonCubit lessonCubit;

  @override
  void initState() {
    super.initState();
    lessonCubit = getIt<LessonCubit>();
  }

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });

    // Load lessons when expanding
    if (isExpanded) {
      print('Loading lessons for section: ${widget.section.id}');
      print('Section title: ${widget.section.title}');
      lessonCubit.emitGetLesson(widget.section.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          GestureDetector(
            onTap: toggleExpansion,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 9.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFF02457A),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.section.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF02457A),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Color(0xFF9D9D9D),
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable lessons section
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Container(
                    margin: const EdgeInsets.only(left: 16, top: 8),
                    child: BlocProvider.value(
                      value: lessonCubit,
                      child: BlocBuilder<LessonCubit, LessonState>(
                        builder: (context, lessonState) {
                          if (lessonState is GetLessonLoading) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF02457A),
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          } else if (lessonState is GetLessonSuccess) {
                            final lessons = lessonState.response.lessons;

                            if (lessons.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "No lessons available",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF9D9D9D),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children: lessons.map((lesson) {
                                return GestureDetector(
                                  onTap: () {
                                    context.push(Routes.viewLesson, extra: {
                                      'sectionId': widget
                                          .section.id, 
                                      'lessonId': lesson
                                          .id, 
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      border: Border.all(
                                        color: const Color(0xFF02457A)
                                            .withOpacity(0.3),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.play_circle_outline,
                                          color: Color(0xFF02457A),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            lesson.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF02457A),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else if (lessonState is GetLessonFailure) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Error loading lessons: ${lessonState.error}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
