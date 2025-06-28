import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../lesson/logic/cubit/section_cubit.dart';
import '../../../login/logic/cubit/my_cubit.dart';
import '../widgets/section_tile.dart';
import '../../../../core/routing/routes.dart';

class CourseContentSection extends StatelessWidget {
  final String courseId;
  final bool isCourseEnded;
  final VoidCallback onEndCourse;
  
  const CourseContentSection({
    super.key,
    required this.courseId,
    required this.isCourseEnded,
    required this.onEndCourse,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleCubit, String?>(
      builder: (context, userRole) {
        if (userRole == 'instructor' || userRole == 'kid') {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Content",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF02457A),
                    ),
                  ),
                  if (userRole == 'instructor')
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onEndCourse,
                          child: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (!isCourseEnded) 
                          GestureDetector(
                            onTap: () {
                              context.push(Routes.addLessonPage, extra: {
                                'courseId': courseId
                              });
                            },
                            child: const Icon(
                              Icons.add_outlined,
                              color: Color(0xFF02457A),
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              BlocBuilder<SectionCubit, SectionState>(
                builder: (context, sectionState) {
                  if (sectionState is GetSectionLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF02457A),
                      ),
                    );
                  } else if (sectionState is GetSectionSuccess) {
                    final sections = sectionState.response.sections;

                    if (sections.isEmpty) {
                      return const Center(
                        child: Text(
                          "No sections available",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF9D9D9D),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sections.length,
                      itemBuilder: (context, index) {
                        final section = sections[index];
                        return ExpandableSectionTile(
                          section: section,
                        );
                      },
                    );
                  } else if (sectionState is GetSectionFailure) {
                    return Center(
                      child: Text(
                        "Error loading sections: ${sectionState.error}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 20),
            ],
          );
        }
        return const SizedBox(); 
      },
    );
  }
}