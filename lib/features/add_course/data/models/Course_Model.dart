import '../../../lesson/data/models/section.dart';

class CourseRequest {
  String? courseName;
  String? instructor;
  String? level;
  String? availability;
  num? offer;
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
      lessons:
          json['lessons'] != null ? List<String>.from(json['lessons']) : [],
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
  List<CourseData>? allCourses;
  List<CourseData>? purchasedCourses;

  CourseResponse({
    this.status,
    this.data,
    this.courses,
    this.trendingCourses,
    this.success,
    this.allCourses,
    this.purchasedCourses,
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
      allCourses: json['data'] != null &&
              json['data']['allCourses'] != null &&
              json['data']['allCourses'] is List
          ? List<CourseData>.from(json['data']['allCourses']
              .map((course) => CourseData.fromJson(course)))
          : [],
      purchasedCourses:
          json['purchasedCourses'] != null && json['purchasedCourses'] is List
              ? List<CourseData>.from(json['purchasedCourses']
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
      'allCourses': allCourses != null
          ? allCourses!.map((course) => course.toJson()).toList()
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
  num? offer;
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
  List<int>? suitableAges;
  num? earnings;
  bool? purchased;
  List<SectionModel>? sections;
  String? governorate;
  num? discountValue;
  num? discountPercent;

  CourseData({
    this.id,
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
    this.suitableAges,
    this.numKids,
    this.earnings,
    this.purchased,
    this.sections,
    this.governorate,
    this.discountValue,
    this.discountPercent,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) {
    try {
      final String parsedId =
          json['_id']?.toString() ?? json['id']?.toString() ?? '';

      final instructor = _parseInstructor(json['instructor']);
      final governorate = instructor is Map<String, dynamic>
          ? instructor['Governorate']?.toString()
          : null;

      return CourseData(
        id: parsedId,
        courseName: json['course_name']?.toString(),
        courseId: json['course_id']?.toString(),
        instructor: instructor,
        kids: _parseKids(json['kid']),
        level: json['level']?.toString(),
        availability: json['availability']?.toString(),
        offer: _parseNum(json['offer']),
        category: json['category']?.toString(),
        description: json['description']?.toString(),
        startDate: _parseDateTime(json['start_date']),
        endDate: _parseDateTime(json['end_date']),
        courseImage: json['course_image']?.toString(),
        createdAt: json['createdAt']?.toString(),
        updatedAt: json['updatedAt']?.toString(),
        v: _parseInt(json['__v']),
        price: _parseNum(json['price']),
        priceAfterDiscount: _parseNum(json['price_after_offer']) ??
            _parseNum(json['price_after_discount']),
        ratingQuantity: _parseInt(json['rating_quantity']),
        lessons: _parseLessons(json['lessons']),
        progress: _parseDouble(json['progress']),
        firstSection: json['first_section']?.toString(),
        numKids: _parseInt(json['numKids']),
        suitableAges: _parseSuitableAges(json['suitableAges']),
        earnings: _parseNum(json['earnings']),
        purchased: json['purchased'] is bool ? json['purchased'] : null,
        sections: _parseSections(json['sections']),
        governorate: governorate,
        discountValue: _parseNum(json['discountValue']),
        discountPercent: _parseNum(json['discountPercent']),
      );
    } catch (e) {
      print('Error parsing CourseData: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  static Map<String, dynamic>? _parseInstructor(dynamic instructor) {
    if (instructor == null) return null;

    if (instructor is Map<String, dynamic>) {
      return instructor;
    } else if (instructor is String) {
      return {'_id': instructor};
    } else {
      return {'_id': instructor.toString()};
    }
  }

  static List<dynamic> _parseKids(dynamic kids) {
    if (kids == null) return [];
    if (kids is List) return kids;
    return [kids];
  }

  static num? _parseNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) {
      String cleanValue = value.replaceAll('%', '').trim();
      return num.tryParse(cleanValue);
    }
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static List<String> _parseLessons(dynamic lessons) {
    if (lessons == null || lessons is! List) return [];
    return lessons.map((e) => e.toString()).toList();
  }

  static List<int> _parseSuitableAges(dynamic ages) {
    if (ages == null || ages is! List) return [];
    return ages
        .map((e) => e is String ? int.tryParse(e) ?? 0 : (e as int? ?? 0))
        .toList();
  }

  static List<SectionModel> _parseSections(dynamic sections) {
    if (sections == null) return [];

    if (sections is String) {
      print('Warning: sections is a String, returning empty list');
      return [];
    }

    if (sections is! List) {
      print('Warning: sections is not a List, returning empty list');
      return [];
    }

    try {
      List<SectionModel> result = [];
      for (var section in sections) {
        if (section is Map<String, dynamic>) {
          result.add(SectionModel.fromJson(section));
        } else if (section is String) {
          print('Warning: section is just an ID, skipping: $section');
        } else {
          print(
              'Warning: section is neither Map nor String, skipping: $section');
        }
      }
      return result;
    } catch (e) {
      print('Error parsing sections: $e');
      return [];
    }
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
      'suitableAges': suitableAges,
      'earnings': earnings,
      'purchased': purchased,
      'governorate': governorate,
      'discountValue': discountValue,
      'discountPercent': discountPercent,
    };
  }
}

class EndCourseRequest {
  final String courseId;
  final String? lessonId;

  EndCourseRequest({required this.courseId, this.lessonId});

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        if (lessonId != null) 'lessonId': lessonId,
      };
}

class EndCourseResponse {
  final String message;
  final int? progress;

  EndCourseResponse({required this.message, this.progress});

  factory EndCourseResponse.fromJson(Map<String, dynamic> json) {
    return EndCourseResponse(
      message: json['message'],
      progress: json['progress'],
    );
  }
}
