import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/review_model.dart';
import '../../data/repo/reviews_repo.dart';
import 'package:flutter/material.dart';
part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepo reviewsRepo;
  ReviewsCubit(this.reviewsRepo) : super(ReviewsInitial());

  Future<void> emitCreateReview(ReviewRequestModel newReview) async {
    emit(CreateReviewLoading());

    try {
      final response = await reviewsRepo.createReviews(newReview);
      emit(CreateReviewSuccess(response.newReview));
    } catch (e) {
      emit(CreateReviewFailure(e.toString()));
    }
  }

  Future<void> emitGetReviewsByCourse(String courseId) async {
    if (courseId.isEmpty) {
      emit(GetReviewsFailure('Course ID is not available'));
      return;
    }
    emit(GetReviewsLoading());
    try {
      final response = await reviewsRepo.getReviewsByCourse(courseId);
      emit(GetReviewsSuccess(response.reviews));
    } catch (e) {
      emit(GetReviewsFailure(e.toString()));
    }
  }

  Future<void> emitGetRecentReviews() async {
    emit(GetReviewsLoading());
    try {
      final response = await reviewsRepo.getRecentReviews();
      emit(GetReviewsSuccess(response.reviews));
    } catch (e) {
      emit(GetReviewsFailure(e.toString()));
    }
  }

  Future<void> emitGetReviewsByInstructor() async {
    emit(GetReviewsLoading());
    try {
      final response = await reviewsRepo.getReviewsByInstructor();
      emit(GetReviewsSuccess(response.reviews));
    } catch (e) {
      emit(GetReviewsFailure(e.toString()));
    }
  }

  Future<void> emitGetReviewsByInstructorId(String instructorId) async {
    emit(GetReviewsLoading());
    try {
      final response = await reviewsRepo.getReviewsByInstructorId(instructorId);
      emit(GetReviewsSuccess(response.reviews));
    } catch (e) {
      emit(GetReviewsFailure(e.toString()));
    }
  }
}
