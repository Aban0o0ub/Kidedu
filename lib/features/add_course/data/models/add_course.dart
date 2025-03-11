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
      "start_date": startDate?.toIso8601String(), // تحويل إلى String
      "end_date": endDate?.toIso8601String(),
      "course_image": courseImage,
      "first_section": firstSection,
    };
  }
}

class CourseResponse {
  String? status;
  CourseData? data;
  List<CourseData>? courses;

  CourseResponse({this.status, this.data, this.courses});

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    return CourseResponse(
      status: json['status'],
      data: json['data'] != null &&
              json['data']['new_course'] is Map<String, dynamic>
          ? CourseData.fromJson(json['data']['new_course'])
          : null,
      courses: json['data'] != null && json['data']['new_course'] is List
          ? List<CourseData>.from(json['data']['new_course']
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
    };
  }
}

class CourseData {
  String? id;
  String? courseName;
  Map<String, dynamic>? instructor;
  List<dynamic>? kids;
  String? level;
  String? availability;
  String? offer;
  num? price;
  String? category;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  String? courseImage;
  String? createdAt;
  String? updatedAt;
  int? v;

  CourseData(
      {this.id,
      this.courseName,
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
      this.v,
      this.price});

  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      id: json['_id'],
      courseName: json['course_name'],
      instructor: json['instructor'] is Map<String, dynamic>
          ? json['instructor'] as Map<String, dynamic>
          : null,
      kids: json['kids'] != null ? List<dynamic>.from(json['kids']) : [],
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'course_name': courseName,
      'instructor': instructor,
      'kids': kids,
      'level': level,
      'availability': availability,
      'offer': offer,
      'category': category,
      'description': description,
      "start_date": startDate?.toIso8601String(), // تحويل إلى String
      "end_date": endDate?.toIso8601String(),
      'course_image': courseImage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      "price": price,
    };
  }
}
