import '../../../add_course/data/models/Course_Model.dart';

class AddCartRequest {
  final List<String> courseIds;

  AddCartRequest({required this.courseIds});

  Map<String, dynamic> toJson() {
    return {
      'courseIds': courseIds,
    };
  }
}

class CartCourse {
  final dynamic course; 
  final String id;
  final DateTime addedAt;

  CartCourse({
    required this.course,
    required this.id,
    required this.addedAt,
  });

  factory CartCourse.fromJson(Map<String, dynamic> json) {
    final rawCourse = json['course'];
    return CartCourse(
      course: rawCourse is String ? rawCourse : CourseData.fromJson(rawCourse),
      id: json['_id'] ?? '',
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course': course is String ? course : (course as CourseData).toJson(),
      '_id': id,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}

class CartModel {
  final String id;
  final String kid;
  final List<CartCourse> courses;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CartModel({
    required this.id,
    required this.kid,
    required this.courses,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id'] ?? '',
      kid: json['kid'] ?? '',
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
      'kid': kid,
      'courses': courses.map((course) => course.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class AddCartResponse {
  final String message;
  final CartModel cart;

  AddCartResponse({
    required this.message,
    required this.cart,
  });

  factory AddCartResponse.fromJson(Map<String, dynamic> json) {
    return AddCartResponse(
      message: json['message'] ?? '',
      cart: CartModel.fromJson(json['cart']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'cart': cart.toJson(),
    };
  }
}

class RemoveCartResponse {
  final String message;
  final CartModel cart;

  RemoveCartResponse({
    required this.message,
    required this.cart,
  });

  factory RemoveCartResponse.fromJson(Map<String, dynamic> json) {
    return RemoveCartResponse(
      message: json['message'] ?? '',
      cart: CartModel.fromJson(json['cart']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'cart': cart.toJson(),
    };
  }
}
