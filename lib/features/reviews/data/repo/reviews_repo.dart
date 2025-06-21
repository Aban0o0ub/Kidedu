import '../../../../core/networking/web_services.dart';
import '../models/review_model.dart';

class ReviewsRepo {
  final WebServices webServices;

  ReviewsRepo(this.webServices);

  Future<ReviewResponseModel> createReview(ReviewRequestModel newReview) async {
    return await webServices.createReviews(newReview);
  }

  Future<ReviewListResponseModel> getRecentReviews() async {
    return await webServices.getRecentReviews();
  }

  Future<ReviewListResponseModel> getReviewsByCourse(String courseId) async {
    return await webServices.getReviewsByCourse(courseId);
  }

  Future<ReviewListResponseModel> getReviewsByInstructor() async {
    return await webServices.getReviewsByInstructor();
  }
}
