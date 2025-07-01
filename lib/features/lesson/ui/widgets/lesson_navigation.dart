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
      Color buttonColor;
      if (canNavigate && !isLoading) {
        buttonColor = isNext 
            ? const Color(0xff02457A)  
            : Colors.grey.withOpacity(0.8);
            
      } else {
        buttonColor = Colors.grey[300]!; 
      }
      
      return GestureDetector(
        onTap: canNavigate && !isLoading ? onTap : null,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: buttonColor,
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.withOpacity(0.8), Color(0xff02457A).withOpacity(0.8),],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('📚', style: TextStyle(fontSize: 16)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              currentLesson.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
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