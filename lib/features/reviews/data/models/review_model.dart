class ReviewRequestModel {
  final String courseId;
  final int rating;
  final String reviewText;

  ReviewRequestModel({
    required this.courseId,
    required this.rating,
    required this.reviewText,
  });

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'rating': rating,
      'reviewText': reviewText,
    };
  }
}

class ReviewResponseModel {
  final String status;
  final ReviewData newReview;

  ReviewResponseModel({
    required this.status,
    required this.newReview,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewResponseModel(
      status: json['status'],
      newReview: ReviewData.fromJson(json['data']['newReview']),
    );
  }
}

class ReviewData {
  final String id;
  final String reviewText;
  final int rating;
  final dynamic courseId;
  final String instructorId;
  final dynamic kidId; 
  final DateTime createdAt;

  ReviewData({
    required this.id,
    required this.reviewText,
    required this.rating,
    required this.courseId,
    required this.instructorId,
    required this.kidId,
    required this.createdAt,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    final courseData = json['courseId'];
    final kidData = json['kidId'];

    return ReviewData(
      id: json['_id'],
      reviewText: json['reviewText'],
      rating: json['rating'],
      courseId: courseData is Map<String, dynamic>
          ? ReviewCourse.fromJson(courseData)
          : courseData,
      instructorId: json['instructorId'],
      kidId: kidData is Map<String, dynamic>
          ? ReviewKid.fromJson(kidData)
          : kidData,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Helper methods للـ type checking
  ReviewCourse? get courseObject => courseId is ReviewCourse ? courseId : null;
  String? get courseIdString => courseId is String ? courseId : null;
  
  ReviewKid? get kidObject => kidId is ReviewKid ? kidId : null;
  String? get kidIdString => kidId is String ? kidId : null;
}

class ReviewListResponseModel {
  final String status;
  final int results;
  final List<ReviewData> reviews;

  ReviewListResponseModel({
    required this.status,
    required this.results,
    required this.reviews,
  });

  factory ReviewListResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewListResponseModel(
      status: json['status'],
      results: json['results'],
      reviews: (json['data']['reviews'] as List)
          .map((e) => ReviewData.fromJson(e))
          .toList(),
    );
  }
}

class ReviewCourse {
  final String id;
  final String courseName;

  ReviewCourse({required this.id, required this.courseName});

  factory ReviewCourse.fromJson(Map<String, dynamic> json) {
    return ReviewCourse(
      id: json['_id'],
      courseName: json['course_name'],
    );
  }
}

class ReviewKid {
  final String id;
  final String name;

  ReviewKid({required this.id, required this.name});

  factory ReviewKid.fromJson(Map<String, dynamic> json) {
    return ReviewKid(
       id: json['id'] ?? json['_id'], 
      name: json['Name'],
    );
  }
}