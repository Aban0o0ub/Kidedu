class CourseRequest {
  String? courseName;
  String? instructor;
  String? level;
  String? availability;
  String? offer;
  String? category;
  String? description;
  num? price;
  num? priceAfterDiscount;
  DateTime? startDate;
  DateTime? endDate;
  String? courseImage;
  String? firstSection;
  int? ratingQuantity; 
  List<String>? lessons; 

  CourseRequest({
    this.courseName,
    this.instructor,
    this.level,
    this.availability,
    this.offer,
    this.category,
    this.description,
    this.price,
    this.priceAfterDiscount,
    this.startDate,
    this.endDate,
    this.courseImage,
    this.firstSection,
    this.ratingQuantity, 
    this.lessons,
  });

  factory CourseRequest.fromJson(Map<String, dynamic> json) {
    return CourseRequest(
      courseName: json['course_name'],
      instructor: json['instructor'],
      level: json['level'],
      availability: json['availability'],
      offer: json['offer'],
      category: json['category'],
      description: json['description'],
      price: json['price'],
      priceAfterDiscount: json['price_after_discount'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      courseImage: json['course_image'],
      firstSection: json['first_section'],
      ratingQuantity: json['rating_quantity'], 
      lessons: json['lessons'] != null
          ? List<String>.from(json['lessons'])
          : [], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "course_name": courseName,
      "instructor": instructor,
      "level": level,
      "availability": availability,
      "offer": offer,
      "category": category,
      "description": description,
      "price": price,
      "price_after_discount": priceAfterDiscount,
      "start_date": startDate?.toIso8601String(),
      "end_date": endDate?.toIso8601String(),
      "course_image": courseImage,
      "first_section": firstSection,
      "rating_quantity": ratingQuantity,
      "lessons": lessons,
    };
  }
}

class CourseResponse {
  bool? success;
  String? status;
  CourseData? data;
  List<CourseData>? courses;
  List<CourseData>? trendingCourses;

  CourseResponse({
    this.status,
    this.data,
    this.courses,
    this.trendingCourses,
    this.success,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    bool hasDataWrapper = json['data'] != null;
    Map<String, dynamic> courseData;
    if (hasDataWrapper) {
      courseData =
          json['data']['new_course'] ?? json['data']['onlyCourse'] ?? {};
    } else {
      courseData = json;
    }
    return CourseResponse(
      status:
          json['status'] ?? (json['success'] == true ? 'success' : 'failed'),
      // data: json['data'] != null
      //     ? CourseData.fromJson(
      //         json['data']['new_course'] ?? json['data']['onlyCourse'] ?? {})
      //     : null,
      data: hasDataWrapper
          ? CourseData.fromJson(
              json['data']['new_course'] ?? json['data']['onlyCourse'] ?? {})
          : CourseData.fromJson(courseData),
      courses: json['data'] != null && json['data']['new_course'] is List
          ? List<CourseData>.from(json['data']['new_course']
              .map((course) => CourseData.fromJson(course)))
          : json['data']?['onlyCourse'] != null
              ? [CourseData.fromJson(json['data']['onlyCourse'])]
              : [],
      trendingCourses:
          json['trendingCourses'] != null && json['trendingCourses'] is List
              ? List<CourseData>.from(json['trendingCourses']
                  .map((course) => CourseData.fromJson(course)))
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data != null ? data!.toJson() : null,
      'courses': courses != null
          ? courses!.map((course) => course.toJson()).toList()
          : null,
      'trendingCourses': trendingCourses != null
          ? trendingCourses!.map((course) => course.toJson()).toList()
          : null,
    };
  }
}

class CourseData {
  String? id;
  String? courseName;
  String? courseId;
  Map<String, dynamic>? instructor;
  List<dynamic>? kids;
  String? level;
  String? availability;
  String? offer;
  num? price;
  num? priceAfterDiscount;
  String? category;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  String? courseImage;
  String? createdAt;
  String? updatedAt;
  int? v;
  int? ratingQuantity;
  List<String>? lessons;
  double? progress;
  String? firstSection;
  int? numKids;

  CourseData(
      {this.id,
      this.courseName,
      this.courseId,
      this.instructor,
      this.kids,
      this.level,
      this.availability,
      this.offer,
      this.category,
      this.description,
      this.startDate,
      this.endDate,
      this.courseImage,
      this.createdAt,
      this.updatedAt,
      this.priceAfterDiscount,
      this.v,
      this.price,
      this.ratingQuantity,
      this.lessons,
      this.progress,
      this.firstSection,
      this.numKids});

  factory CourseData.fromJson(Map<String, dynamic> json) {
    final String parsedId =
        json['_id']?.toString() ?? json['id']?.toString() ?? '';
    print('Parsed ID to use: $parsedId');
    return CourseData(
      id: json['_id']?.toString() ?? json['id'],
      courseName: json['course_name'],
      courseId: json['course_id'],
      instructor: json['instructor'] is Map<String, dynamic>
          ? json['instructor']
          : {'_id': json['instructor']},
      kids: json['kid'] != null ? List<dynamic>.from(json['kid']) : [],
      level: json['level'],
      availability: json['availability'],
      offer: json['offer'],
      category: json['category'],
      description: json['description'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      courseImage: json['course_image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      price: json['price'],
      priceAfterDiscount:
          json['price_after_offer'] ?? json['price_after_discount'],
      ratingQuantity: json['rating_quantity'],
      lessons:
          json['lessons'] != null ? List<String>.from(json['lessons']) : [],
      progress: json['progress'] != null ? json['progress'].toDouble() : 0.0,
      firstSection: json['first_section'],
      numKids: json['numKids'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'course_name': courseName,
      'course_id': courseId,
      'instructor': instructor,
      'kids': kids,
      'level': level,
      'availability': availability,
      'offer': offer,
      'category': category,
      'description': description,
      "start_date": startDate?.toIso8601String(),
      "end_date": endDate?.toIso8601String(),
      'course_image': courseImage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      "price": price,
      "price_after_offer": priceAfterDiscount,
      'rating_quantity': ratingQuantity,
      'lessons': lessons,
      'progress': progress,
      'first_section': firstSection,
      'numKids': numKids,
    };
  }
}
