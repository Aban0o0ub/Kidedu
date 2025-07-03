import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/core/routing/routes.dart';
import '../../logic/cubit/course_details_cubit.dart';

void showDeleteCourseDialog({
  required BuildContext context,
  required String courseId,
  required CourseDetailsCubit courseDetailsCubit,
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
                  colors: [Colors.white, Color(0xFFF8F9FA)],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEBEE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Delete Course',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Are you sure you want to delete this course? This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.of(dialogContext).pop(),
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
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setDialogState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    final response = await courseDetailsCubit
                                        .emitDeleteCourse(courseId);
                                    final statusCode = response.statusCode;
                                    final message = response.data['message'] ??
                                        'Something went wrong';

                                    Icon icon;
                                    String title;

                                    if (statusCode == 200 ||
                                        statusCode == 204) {
                                      icon = const Icon(Icons.check_circle,
                                          color: Colors.green);
                                      title = 'Success';
                                    } else if (statusCode == 400 ||
                                        statusCode == 403 ||
                                        statusCode == 404) {
                                      icon = const Icon(Icons.warning,
                                          color: Colors.amber);
                                      title = 'Delete Failed';
                                    } else {
                                      throw Exception(
                                          'Unexpected status code: $statusCode');
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Row(
                                          children: [
                                            icon,
                                            const SizedBox(width: 8),
                                            Text(title,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        content: Text(message,
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              Navigator.of(dialogContext).pop();
                                              if (statusCode == 200 ||
                                                  statusCode == 204) {
                                                context.go(
                                                  Routes.instructorProfilePage,
                                                  extra: {
                                                    'deletedCourseId': courseId
                                                  },
                                                );
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                                  const Color(0xFF02457A),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } catch (e) {
                                    Navigator.of(dialogContext).pop();
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Row(
                                          children: const [
                                            Icon(Icons.error,
                                                color: Colors.red),
                                            SizedBox(width: 8),
                                            Text(
                                              'Error',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        content: const Text(
                                          'Something went wrong while deleting the course.',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                                  const Color(0xFF02457A),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
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
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Delete',
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
