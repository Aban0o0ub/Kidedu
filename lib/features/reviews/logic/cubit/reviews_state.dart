part of 'reviews_cubit.dart';

@immutable
sealed class ReviewsState {}

final class ReviewsInitial extends ReviewsState {}

class CreateReviewInitial extends ReviewsState {}

class CreateReviewLoading extends ReviewsState {}

class CreateReviewSuccess extends ReviewsState {
  final ReviewData review;
  CreateReviewSuccess(this.review);
}

class CreateReviewFailure extends ReviewsState {
  final String error;
  CreateReviewFailure(this.error);
}
///////////////////////////////////////////////////////////////

class GetReviewsInitial extends ReviewsState {}

class GetReviewsLoading extends ReviewsState {}

class GetReviewsSuccess extends ReviewsState {
  final List<ReviewData> reviews;
  GetReviewsSuccess(this.reviews);
}

class GetReviewsFailure extends ReviewsState {
  final String error;
  GetReviewsFailure(this.error);
}