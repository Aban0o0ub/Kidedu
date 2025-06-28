import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../course_details/logic/cubit/course_details_cubit.dart';
import '../../../reviews/logic/cubit/reviews_cubit.dart';
import '../../data/models/lesson.dart';
import 'completion_dialog.dart';

class LessonNavigation extends StatelessWidget {
  final List<LessonModel> lessons;
  final int selectedLessonIndex;
  final LessonModel currentLesson;
  final String? courseId;
  final Function(int, LessonModel) onNavigate;

  const LessonNavigation({
    super.key,
    required this.lessons,
    required this.selectedLessonIndex,
    required this.currentLesson,
    required this.courseId,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavigationButton(
            context: context,
            isNext: false,
            canNavigate: selectedLessonIndex > 0,
            onTap: () => onNavigate(selectedLessonIndex - 1, currentLesson),
          ),
          _buildLessonNameContainer(),
          _buildNavigationButton(
            context: context,
            isNext: true,
            canNavigate: courseId != null, 
            onTap: () {
              if (selectedLessonIndex < lessons.length - 1) {
                onNavigate(selectedLessonIndex + 1, currentLesson);
              } else {
                onNavigate(selectedLessonIndex, currentLesson);
                
                Future.delayed(const Duration(milliseconds: 300), () {
                  _showCourseCompletionDialog(context);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required BuildContext context,
    required bool isNext,
    required bool canNavigate,
    required VoidCallback onTap,
  }) {
    return BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
      builder: (context, courseState) {
        bool isLoading = courseState is EndCourseLoading;
        return GestureDetector(
          onTap: canNavigate && !isLoading ? onTap : null,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: canNavigate && !isLoading
                  ? const Color(0xff02457A)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(
                    isNext ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
                    color: canNavigate ? Colors.white : Colors.grey[500],
                    size: 20,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLessonNameContainer() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xff02457A).withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xff02457A),
            width: 1,
          ),
        ),
        child: Text(
          currentLesson.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xff02457A),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  void _showCourseCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ReviewsCubit>(),
        child: CourseCompletionDialog(courseId: courseId),
      ),
    );
  }
}