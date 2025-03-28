// class CartCourse {
//   final String courseId;

//   CartCourse({required this.courseId});

//   factory CartCourse.fromJson(Map<String, dynamic> json) {
//     return CartCourse(courseId: json['courseId'] ?? '');
//   }

//   Map<String, dynamic> toJson() {
//     return {'courseId': courseId};
//   }
// }

// class CartModel {
//   final String id;
//   final String userId;
//   final List<CartCourse> courses;

//   CartModel({required this.id, required this.userId, required this.courses});

//   factory CartModel.fromJson(Map<String, dynamic> json) {
//     return CartModel(
//       id: json['_id'] ?? '',
//       userId: json['userId'] ?? '',
//       courses: (json['courses'] as List?)?.map((e) => CartCourse.fromJson(e)).toList() ?? [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'userId': userId,
//       'courses': courses.map((course) => course.toJson()).toList(),
//     };
//   }
// }

// class CourseModel {
//   final String id;
//   final String courseName;
//   final String instructor;
//   final String category;
//   final String description;
//   final num price;
//   final num? priceAfterDiscount;
//   final DateTime? startDate;
//   final DateTime? endDate;
//   final String courseImage;

//   CourseModel({
//     required this.id,
//     required this.courseName,
//     required this.instructor,
//     required this.category,
//     required this.description,
//     required this.price,
//     this.priceAfterDiscount,
//     this.startDate,
//     this.endDate,
//     required this.courseImage,
//   });

//   factory CourseModel.fromJson(Map<String, dynamic> json) {
//     return CourseModel(
//       id: json['_id'] ?? '',
//       courseName: json['course_name'] ?? '',
//       instructor: json['instructor'] ?? '',
//       category: json['category'] ?? '',
//       description: json['description'] ?? '',
//       price: json['price'] ?? 0,
//       priceAfterDiscount: json['price_after_discount'],
//       startDate: json['start_date'] != null ? DateTime.tryParse(json['start_date']) : null,
//       endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
//       courseImage: json['course_image'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'course_name': courseName,
//       'instructor': instructor,
//       'category': category,
//       'description': description,
//       'price': price,
//       'price_after_discount': priceAfterDiscount,
//       'start_date': startDate?.toIso8601String(),
//       'end_date': endDate?.toIso8601String(),
//       'course_image': courseImage,
//     };
//   }
// }
class CartCourse {
  final String courseId;
  final String id;
  final DateTime addedAt;

  CartCourse({
    required this.courseId,
    required this.id,
    required this.addedAt,
  });

  factory CartCourse.fromJson(Map<String, dynamic> json) {
    return CartCourse(
      courseId: json['course'] ?? '',
      id: json['_id'] ?? '',
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course': courseId,
      '_id': id,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}

class CartModel {
  final String id;
  final String kidId;
  final List<CartCourse> courses;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CartModel({
    required this.id,
    required this.kidId,
    required this.courses,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id'] ?? '',
      kidId: json['kid'] ?? '',
      courses: (json['courses'] as List?)
              ?.map((e) => CartCourse.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'kid': kidId,
      'courses': courses.map((course) => course.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

