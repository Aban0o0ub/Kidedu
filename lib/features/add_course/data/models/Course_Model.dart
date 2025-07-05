import '../../../lesson/data/models/section.dart';
import '../../../reviews/data/models/review_model.dart';

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
  DateTime? tillDate;
  List<String>? courseImages;
  String? firstSection;
  int? ratingQuantity;
  List<String>? lessons;
  List<int>? suitableAges;

  CourseRequest(
      {this.courseName,
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
      this.tillDate,
      this.courseImages,
      this.firstSection,
      this.ratingQuantity,
      this.lessons,
      this.suitableAges});

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
      tillDate: json['till_date'] != null ? DateTime.parse(json['till_date']) : null,
      courseImages: json['course_image'] != null 
          ? (json['course_image'] is List 
              ? List<String>.from(json['course_image']) 
              : [json['course_image'].toString()])
          : null,
      firstSection: json['first_section'],
      ratingQuantity: json['rating_quantity'],
      lessons:
          json['lessons'] != null ? List<String>.from(json['lessons']) : [],
      suitableAges: json['suitableAges'] != null
          ? List<int>.from(json['suitableAges'])
          : null,
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
      "till_date": tillDate?.toIso8601String(),
      "course_image": courseImages,
      "first_section": firstSection,
      "rating_quantity": ratingQuantity,
      "lessons": lessons,
      "suitableAges": suitableAges ?? [],
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
      
      // إضافة البيانات الإضافية من الـ response الجديد
      if (json['data']['instructor'] != null) {
        courseData['instructor'] = json['data']['instructor'];
      }
      if (json['data']['courses'] != null) {
        courseData['courses'] = json['data']['courses'];
      }
      if (json['data']['reviews'] != null) {
        courseData['reviews'] = json['data']['reviews'];
      }
    } else {
      courseData = json;
    }
    return CourseResponse(
      status:
          json['status'] ?? (json['success'] == true ? 'success' : 'failed'),
      data: hasDataWrapper
          ? CourseData.fromJson(courseData)
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
  dynamic instructor;
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
  List<String>? courseImages;
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
  List<CourseData>? instructorCourses;
  List<ReviewData>? instructorReviews;
  // إضافة الحقول المفقودة
  dynamic instructorData; // لحفظ بيانات المدرس كاملة
  List<CourseData>? courses; // للكورسات المرجعة من الـ API
  List<ReviewData>? reviews; // للمراجعات المرجعة من الـ API

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
    this.courseImages,
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
    this.instructorCourses,
    this.instructorReviews,
    this.instructorData,
    this.courses,
    this.reviews,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) {
    try {
      final String parsedId =
          json['_id']?.toString() ?? json['id']?.toString() ?? '';

      final instructor = json['instructor'];
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
        courseImages: json['course_image'] != null 
            ? (json['course_image'] is List 
                ? List<String>.from(json['course_image']) 
                : [json['course_image'].toString()])
            : null,
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
        // الحقول الموجودة مسبقاً
        instructorCourses: _parseInstructorCourses(json['courses']),
        instructorReviews: _parseInstructorReviews(json['reviews']),
        // الحقول الجديدة - البيانات الإضافية من الـ API الجديد
        instructorData: json['instructor'] is Map<String, dynamic> ? json['instructor'] : null,
        courses: _parseInstructorCourses(json['courses']),
        reviews: _parseInstructorReviews(json['reviews']),
      );
    } catch (e) {
      print('Error parsing CourseData: $e');
      print('JSON data: $json');
      rethrow;
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

  static List<CourseData> _parseInstructorCourses(dynamic courses) {
    if (courses == null || courses is! List) return [];
    try {
      return courses.map((course) => CourseData.fromJson(course)).toList();
    } catch (e) {
      print('Error parsing instructor courses: $e');
      return [];
    }
  }

  static List<ReviewData> _parseInstructorReviews(dynamic reviews) {
    if (reviews == null || reviews is! List) return [];
    try {
      return reviews.map((review) => ReviewData.fromJson(review)).toList();
    } catch (e) {
      print('Error parsing instructor reviews: $e');
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
      'course_image': courseImages,
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
      'courses': courses?.map((course) => course.toJson()).toList(),
      'reviews': reviews?.map((review) => review.toJson()).toList(),
    };
  }

  // Helper methods للوصول للبيانات
  String? get instructorName {
  // جرب من instructorData أولاً (البيانات الجديدة)
  if (instructorData is Map<String, dynamic>) {
    final name = instructorData['Name']?.toString();
    if (name != null && name.isNotEmpty) return name;
  }
  
  // ثم جرب من الـ instructor الأساسي
  if (instructor is Map<String, dynamic>) {
    final name = instructor['Name']?.toString();
    if (name != null && name.isNotEmpty) return name;
  }
  
  return null;
}

  String? get instructorEmail {
    if (instructorData is Map<String, dynamic>) {
      return instructorData['Email']?.toString();
    }
    if (instructor is Map<String, dynamic>) {
      return instructor['Email']?.toString();
    }
    return null;
  }

  String? get instructorGovernorate {
    if (instructorData is Map<String, dynamic>) {
      return instructorData['Governorate']?.toString();
    }
    if (instructor is Map<String, dynamic>) {
      return instructor['Governorate']?.toString();
    }
    return null;
  }

  String? get instructorBio {
    if (instructorData is Map<String, dynamic>) {
      return instructorData['Bio']?.toString();
    }
    if (instructor is Map<String, dynamic>) {
      return instructor['Bio']?.toString();
    }
    return null;
  }

  num? get instructorEarnings {
    if (instructorData is Map<String, dynamic>) {
      return _parseNum(instructorData['earnings']);
    }
    if (instructor is Map<String, dynamic>) {
      return _parseNum(instructor['earnings']);
    }
    return null;
  }


String? get instructorId {
  // جرب من instructorData أولاً (البيانات الجديدة)
  if (instructorData is Map<String, dynamic>) {
    final id = instructorData['_id']?.toString();
    if (id != null && id.isNotEmpty) return id;
  }
  
  // ثم جرب من الـ instructor الأساسي
  if (instructor is Map<String, dynamic>) {
    final id = instructor['_id']?.toString();
    if (id != null && id.isNotEmpty) return id;
  }
  
  // لو كان string، يبقى ده هو الـ ID
  if (instructor is String) {
    return instructor;
  }
  
  return null;
}

String? get instructorPhone {
  // جرب من instructorData أولاً (البيانات الجديدة)
  if (instructorData is Map<String, dynamic>) {
    final phone = instructorData['PhoneNumber']?.toString();
    if (phone != null && phone.isNotEmpty) return phone;
  }
  
  // ثم جرب من الـ instructor الأساسي
  if (instructor is Map<String, dynamic>) {
    final phone = instructor['PhoneNumber']?.toString();
    if (phone != null && phone.isNotEmpty) return phone;
  }
  
  return null;
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
