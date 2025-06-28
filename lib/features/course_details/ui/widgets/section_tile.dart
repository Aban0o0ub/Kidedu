import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../lesson/data/models/section.dart';
import '../../../lesson/logic/cubit/lesson_cubit.dart';

// class ExpandableSectionTile extends StatefulWidget {
//   final SectionModel section;

//   const ExpandableSectionTile({
//     super.key,
//     required this.section,
//   });

//   @override
//   State<ExpandableSectionTile> createState() => _ExpandableSectionTileState();
// }

// class _ExpandableSectionTileState extends State<ExpandableSectionTile> {
//   bool isExpanded = false;
//   late LessonCubit lessonCubit;

//   @override
//   void initState() {
//     super.initState();
//     lessonCubit = getIt<LessonCubit>();
//   }

//   void toggleExpansion() {
//     setState(() {
//       isExpanded = !isExpanded;
//     });

//     // Load lessons when expanding
//     if (isExpanded) {
//       print('Loading lessons for section: ${widget.section.id}');
//       print('Section title: ${widget.section.title}');
//       lessonCubit.emitGetLesson(widget.section.id);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: toggleExpansion,
//             child: Container(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 12.0, horizontal: 9.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(
//                   color: const Color(0xFF02457A),
//                   width: 1.5,
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       widget.section.title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF02457A),
//                       ),
//                     ),
//                   ),
//                   AnimatedRotation(
//                     turns: isExpanded ? 0.25 : 0,
//                     duration: const Duration(milliseconds: 200),
//                     child: const Icon(
//                       Icons.arrow_forward_ios_outlined,
//                       color: Color(0xFF9D9D9D),
//                       size: 15,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Expandable lessons section
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             height: isExpanded ? null : 0,
//             child: isExpanded
//                 ? Container(
//                     margin: const EdgeInsets.only(left: 16, top: 8),
//                     child: BlocProvider.value(
//                       value: lessonCubit,
//                       child: BlocBuilder<LessonCubit, LessonState>(
//                         builder: (context, lessonState) {
//                           if (lessonState is GetLessonLoading) {
//                             return const Padding(
//                               padding: EdgeInsets.all(16.0),
//                               child: Center(
//                                 child: CircularProgressIndicator(
//                                   color: Color(0xFF02457A),
//                                   strokeWidth: 2,
//                                 ),
//                               ),
//                             );
//                           } else if (lessonState is GetLessonSuccess) {
//                             final lessons = lessonState.response.lessons;

//                             if (lessons.isEmpty) {
//                               return const Padding(
//                                 padding: EdgeInsets.all(16.0),
//                                 child: Text(
//                                   "No lessons available",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Color(0xFF9D9D9D),
//                                   ),
//                                 ),
//                               );
//                             }

//                             return Column(
//                               children: lessons.map((lesson) {
//                                 return GestureDetector(
//                                   onTap: () {
//                                     if (widget.section.courseId != null) {
//                                       context.push(Routes.viewLesson, extra: {
//                                         'sectionId': widget.section.id,
//                                         'courseId': widget.section
//                                             .courseId!, 
//                                         'lessonId': lesson.id,
//                                       });
//                                     } else {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         SnackBar(
//                                             content:
//                                                 Text('Course ID not found')),
//                                       );
//                                     }
//                                   },
//                                   child: Container(
//                                     margin: const EdgeInsets.only(bottom: 8),
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 10.0, horizontal: 12.0),
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[50],
//                                       border: Border.all(
//                                         color: const Color(0xFF02457A)
//                                             .withOpacity(0.3),
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(6),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         const Icon(
//                                           Icons.play_circle_outline,
//                                           color: Color(0xFF02457A),
//                                           size: 18,
//                                         ),
//                                         const SizedBox(width: 8),
//                                         Expanded(
//                                           child: Text(
//                                             lesson.name,
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               color: Color(0xFF02457A),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             );
//                           } else if (lessonState is GetLessonFailure) {
//                             // Check if it's an enrollment error
//                             if (lessonState.error.contains('Access denied') ||
//                                 lessonState.error.contains('not enrolled')) {
//                               return Container(
//                                 margin: const EdgeInsets.all(16.0),
//                                 padding: const EdgeInsets.all(20.0),
//                                 decoration: BoxDecoration(
//                                   color: Color.fromARGB(255, 233, 245, 255),
//                                   border: Border.all(
//                                     color: Color(0xFF02457A),
//                                     width: 1,
//                                   ),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Icon(
//                                       Icons.lock_outline,
//                                       color: Color(0xFF02457A),
//                                       size: 48,
//                                     ),
//                                     const SizedBox(height: 12),
//                                     const Text(
//                                       "Course Access Required",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600,
//                                         color: Color(0xFF02457A),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     const Text(
//                                       "You need to enroll in this course to access the lessons.",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Color(0xFF02457A),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 16),
//                                   ],
//                                 ),
//                               );
//                             }

//                             return Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Text(
//                                 "Error loading lessons: ${lessonState.error}",
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             );
//                           }
//                           return const SizedBox();
//                         },
//                       ),
//                     ),
//                   )
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }
// }
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
                            final isRestricted = lessonState.response.status == "Restricted";

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
                              children: [
                                // Show restriction message if applicable
                                if (isRestricted)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3CD),
                                      border: Border.all(
                                        color: const Color(0xFFFFE082),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.info_outline,
                                          color: Color(0xFF856404),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "Preview mode - Enroll to access full lessons",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF856404),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                // Lessons list
                                ...lessons.map((lesson) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (isRestricted) {
                                        // Show enrollment required message
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Enroll in the course to access lessons'),
                                            backgroundColor: Color(0xFF02457A),
                                          ),
                                        );
                                      } else {
                                        if (widget.section.courseId != null) {
                                          context.push(Routes.viewLesson, extra: {
                                            'sectionId': widget.section.id,
                                            'courseId': widget.section.courseId!,
                                            'lessonId': lesson.id,
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text('Course ID not found')),
                                          );
                                        }
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 12.0),
                                      decoration: BoxDecoration(
                                        color: isRestricted 
                                            ? Colors.grey[100] 
                                            : Colors.grey[50],
                                        border: Border.all(
                                          color: isRestricted
                                              ? const Color(0xFF9D9D9D).withOpacity(0.5)
                                              : const Color(0xFF02457A).withOpacity(0.3),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isRestricted 
                                                ? Icons.lock_outline 
                                                : Icons.play_circle_outline,
                                            color: isRestricted 
                                                ? const Color(0xFF9D9D9D) 
                                                : const Color(0xFF02457A),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              lesson.name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isRestricted 
                                                    ? const Color(0xFF9D9D9D) 
                                                    : const Color(0xFF02457A),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
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