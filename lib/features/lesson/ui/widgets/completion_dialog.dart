import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import your review cubit and models
import '../../../reviews/data/models/review_model.dart';
import '../../../reviews/logic/cubit/reviews_cubit.dart';
import 'cutom_message_overlay.dart';

class CourseCompletionDialog extends StatefulWidget {
  final String? courseId;

  const CourseCompletionDialog({super.key, required this.courseId});

  @override
  State<CourseCompletionDialog> createState() => _CourseCompletionDialogState();
}

class _CourseCompletionDialogState extends State<CourseCompletionDialog>
    with TickerProviderStateMixin {
  bool hasAlreadyReviewed = false;
  bool showReview = false;
  bool isLoading = false;
  int selectedRating = 0;
  final TextEditingController reviewController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _animationController.forward();
    
    // Check if user has already reviewed this course
    _checkExistingReview();
  }

  void _checkExistingReview() {
    // Add your logic here to check if user has already reviewed
    // context.read<ReviewsCubit>().checkExistingReview(widget.courseId);
  }

  @override
  void dispose() {
    _animationController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  // Custom message overlay
  void _showCustomMessage(String message, {bool isSuccess = true}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => CustomMessageOverlay(
        message: message,
        isSuccess: isSuccess,
        onDismiss: () => overlayEntry.remove(),
      ),
    );
    
    overlay.insert(overlayEntry);
    
    // Auto dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: showReview ? _buildReviewForm() : _buildCongratulations(),
        ),
      ),
    );
  }

  Widget _buildCongratulations() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Trophy Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xffFFD700).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 50,
              color: Color(0xffFFD700),
            ),
          ),
          const SizedBox(height: 20),

          // Congratulations Text
          const Text(
            'Congratulations!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xff02457A),
            ),
          ),
          const SizedBox(height: 10),

          const Text(
            'You\'ve completed the course',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xff02457A)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Later',
                    style: TextStyle(
                      color: Color(0xff02457A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: hasAlreadyReviewed 
                      ? () {
                          Navigator.of(context).pop();
                          _showCustomMessage('You have already reviewed this course!', isSuccess: false);
                        }
                      : () {
                          setState(() {
                            showReview = true;
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasAlreadyReviewed 
                        ? Colors.grey[400] 
                        : const Color(0xff02457A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                  ),
                  child: Text(
                    hasAlreadyReviewed ? 'Already Reviewed' : 'Review Now',
                    style: TextStyle(
                      color: hasAlreadyReviewed ? Colors.grey[600] : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewForm() {
    return BlocConsumer<ReviewsCubit, ReviewsState>(
      listener: (context, state) {
        if (state is CreateReviewSuccess) {
          Navigator.of(context).pop();
          _showCustomMessage('Thank you for your review! 🎉');
        } else if (state is CreateReviewFailure) {
          Navigator.of(context).pop();
          _showCustomMessage('You have already submitted a review for this course.', isSuccess: false);
        }
      },
      builder: (context, state) {
        bool isLoading = state is CreateReviewLoading;

        return Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Trophy Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xffFFD700).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  size: 35,
                  color: Color(0xffFFD700),
                ),
              ),
              const SizedBox(height: 15),

              // Title
              const Text(
                'Rate this course',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff02457A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Star Rating
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: isLoading
                        ? null
                        : () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                          },
                    child: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      size: 32,
                      color: isLoading ? Colors.grey : const Color(0xffFFD700),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: reviewController,
                enabled: !isLoading,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Write your review...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xff02457A)),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
              const SizedBox(height: 25),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              setState(() {
                                showReview = false;
                              });
                            },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xff02457A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Color(0xff02457A),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (selectedRating > 0 && !isLoading)
                              ? _submitReview
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff02457A),
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Submit Review',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitReview() {
    if (widget.courseId == null) {
      Navigator.of(context).pop();
      _showCustomMessage('Course ID is missing', isSuccess: false);
      return;
    }

    final reviewRequest = ReviewRequestModel(
      courseId: widget.courseId!,
      rating: selectedRating,
      reviewText: reviewController.text.trim().isEmpty
          ? 'No comment provided'
          : reviewController.text.trim(),
    );
    
    context.read<ReviewsCubit>().emitCreateReview(reviewRequest);
  }
}

