import 'package:flutter/material.dart';
import '../../logic/cubit/course_details_cubit.dart';
import '../../../add_course/data/models/Course_Model.dart';

void showEndCourseDialog({
  required BuildContext context,
  required String courseId,
  required CourseDetailsCubit courseDetailsCubit,
  required VoidCallback onCourseEnded,
}) {
  bool isLoading = false;
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 16,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color(0xFFF8F9FA),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // أيقونة التحذير
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE4E1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      size: 40,
                      color: Color(0xFF02457A),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // العنوان
                  const Text(
                    'End Course',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF02457A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // النص
                  const Text(
                    'Are you sure that you want to end this course?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // الأزرار
                  Row(
                    children: [
                      // زر الإلغاء
                      Expanded(
                        child: TextButton(
                          onPressed: isLoading ? null : () => Navigator.of(dialogContext).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Color(0xFF02457A),
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF02457A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // زر التأكيد
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () async {
                            setDialogState(() {
                              isLoading = true;
                            });
                            
                            try {
                              courseDetailsCubit.emitInstructorEndCourse(
                                EndCourseRequest(courseId: courseId),
                              );
                              
                              await Future.delayed(const Duration(seconds: 2));
                              
                              Navigator.of(dialogContext).pop();
                              
                              onCourseEnded();
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text('The course has been completed successfully.'),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                              
                            } catch (e) {
                              print('Error: $e');
                              Navigator.of(dialogContext).pop();
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("An error occurred while ending the course."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF02457A),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Confirm',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}