import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';

import '../../../reviews/logic/cubit/reviews_cubit.dart';

class CourseReviewsSection extends StatelessWidget {
  final String courseId;
  const CourseReviewsSection({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // البوكس الخلفي الذي يغطي كل شيء
        Container(
                width: double.infinity, // العرض الكامل
                margin: const EdgeInsets.only(top: 15), // تحكم في بداية البوكس من الأعلى
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF02457A),
                      const Color(0xFF0A5999),
                      const Color(0xFF02457A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16), // الزوايا المدورة
                 
                ),
                child: Stack(
                  children: [
                    // دوائر ديكور صغيرة في الخلفية
                    Positioned(
                      top: 20,
                      right: 30,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 20,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 80,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    // خطوط ديكور رفيعة
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.2),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100), // حد أدنى للارتفاع
                  ],
                ),
              ),
        
        // المحتوى فوق البوكس
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // كلمة Reviews فوق البوكس
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 18), // تحكم في موضع النص
              child: const Text(
                "Reviews",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white, // أبيض لأنها فوق البوكس الأزرق
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8), 
              child: BlocBuilder<ReviewsCubit, ReviewsState>(
                builder: (context, state) {
                  if (state is GetReviewsLoading) {
                    return const SizedBox(
                      height: 142,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
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
                              color:  Color(0xFF02457A),
                            ),
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 142,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8), // تحكم في المسافة من الحواف
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
                        height: 135,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.rate_review_outlined,
                                color: Colors.white,
                                size: 35,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "No reviews yet",
                                style: TextStyle(
                                  fontSize: 20,
                                  color:  Color(0xFF02457A),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Be the first to review this course!",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
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
                              color: Colors.red[300],
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isNetworkError
                                  ? "Check your internet connection"
                                  : "Failed to load reviews",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red[300],
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
                                  color: Colors.white,
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}