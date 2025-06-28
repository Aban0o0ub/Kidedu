import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';

import '../../../reviews/logic/cubit/reviews_cubit.dart';

class CourseReviewsSection extends StatelessWidget {
  final String courseId;
  const CourseReviewsSection({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Reviews",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF02457A),
            ),
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<ReviewsCubit, ReviewsState>(
          builder: (context, state) {
            if (state is GetReviewsLoading) {
              return const SizedBox(
                height: 142,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF02457A),
                  ),
                ),
              );
            } else if (state is GetReviewsSuccess) {
              if (state.reviews.isEmpty) {
                return const SizedBox(
                  height: 142,
                  child: Center(
                    child: Text(
                      "No reviews yet",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF02457A),
                      ),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 142,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.reviews.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final review = state.reviews[index];
                    return buildHorizontalReviewCard(
                      name: review.kidId?.name ?? "Unknown",
                      review: review.reviewText,
                      rating: review.rating,
                    );
                  },
                ),
              );
            } else if (state is GetReviewsFailure) {
              // التحقق من نوع الخطأ - 404 يعني مفيش reviews
              bool isNoReviews = state.error.contains('404') ||
                  state.error.toLowerCase().contains('not found');

              if (isNoReviews) {
                // عرض رسالة "لا توجد مراجعات" بدل error
                return const SizedBox(
                  height: 142,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          color: Color(0xFF02457A),
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "No reviews yet",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF02457A),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Be the first to review this course!",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              bool isNetworkError =
                  state.error.toLowerCase().contains('network') ||
                      state.error.toLowerCase().contains('connection') ||
                      state.error.toLowerCase().contains('timeout');

              return SizedBox(
                height: 142,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isNetworkError ? Icons.wifi_off : Icons.error_outline,
                        color: Colors.red,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isNetworkError
                            ? "Check your internet connection"
                            : "Failed to load reviews",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<ReviewsCubit>()
                              .emitGetReviewsByCourse(courseId);
                        },
                        child: const Text(
                          "Tap to retry",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF02457A),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Initial state
            return const SizedBox(
              height: 142,
              child: Center(
                child: Text(
                  "Loading reviews...",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF02457A),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
