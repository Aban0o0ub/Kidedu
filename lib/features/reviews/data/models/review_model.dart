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
  final dynamic instructorId;
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
    final instructorData = json['instructorId'];
    return ReviewData(
      id: json['_id'],
      reviewText: json['reviewText'],
      rating: json['rating'],
      courseId: courseData is Map<String, dynamic>
          ? ReviewCourse.fromJson(courseData)
          : courseData?.toString(),
      instructorId: instructorData is Map<String, dynamic>
          ? ReviewInstructor.fromJson(instructorData)
          : instructorData?.toString(),
      kidId: kidData is Map<String, dynamic>
          ? ReviewKid.fromJson(kidData)
          : kidData?.toString(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // إضافة toJson method
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reviewText': reviewText,
      'rating': rating,
      'courseId': courseId is ReviewCourse
          ? (courseId as ReviewCourse).toJson()
          : courseId?.toString(),
      'instructorId': instructorId is ReviewInstructor
          ? (instructorId as ReviewInstructor).toJson()
          : instructorId?.toString(),
      'kidId': kidId is ReviewKid
          ? (kidId as ReviewKid).toJson()
          : kidId?.toString(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  ReviewCourse? get courseObject => courseId is ReviewCourse ? courseId : null;
  String? get courseIdString => courseId is String ? courseId : null;
  String get displayCourseName =>
      courseObject?.courseName ?? courseIdString ?? 'Unknown Course';
      
  ReviewKid? get kidObject => kidId is ReviewKid ? kidId : null;
  String? get kidIdString => kidId is String ? kidId : null;
  String get displayKidName =>
      kidObject?.name ?? kidIdString ?? 'Unknown Student';
  String? get kidImage => kidObject?.image;
      
  ReviewInstructor? get instructorObject => instructorId is ReviewInstructor ? instructorId : null;
  String? get instructorIdString => instructorId is String ? instructorId : null;
  String get displayInstructorName =>
      instructorObject?.name ?? instructorIdString ?? 'Unknown Instructor';
      
  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
  
  List<bool> get ratingStars {
    return List.generate(5, (index) => index < rating);
  }
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

  bool get hasReviews => reviews.isNotEmpty;
  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;
  }
}

class ReviewCourse {
  final String id;
  final String courseName;

  ReviewCourse({required this.id, required this.courseName});

  factory ReviewCourse.fromJson(Map<String, dynamic> json) {
    return ReviewCourse(
      id: json['_id'] ?? '',
      courseName: json['course_name'] ?? 'Unknown Course',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'course_name': courseName,
    };
  }
}

class ReviewInstructor {
  final String id;
  final String name;

  ReviewInstructor({required this.id, required this.name});

  factory ReviewInstructor.fromJson(Map<String, dynamic> json) {
    return ReviewInstructor(
      id: json['_id'] ?? '',
      name: json['Name'] ?? 'Unknown Instructor',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Name': name,
    };
  }
}

class ReviewKid {
  final String id;
  final String name;
  final String? image;

  ReviewKid({required this.id, required this.name, this.image});

  factory ReviewKid.fromJson(Map<String, dynamic> json) {
    return ReviewKid(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['Name'] ?? 'Unknown Student',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Name': name,
      'image': image,
    };
  }
}

class ReviewErrorModel {
  final String status;
  final String message;
  final String? error;

  ReviewErrorModel({
    required this.status,
    required this.message,
    this.error,
  });

  factory ReviewErrorModel.fromJson(Map<String, dynamic> json) {
    return ReviewErrorModel(
      status: json['status'] ?? 'error',
      message: json['message'] ?? 'Unknown error occurred',
      error: json['error'],
    );
  }
}