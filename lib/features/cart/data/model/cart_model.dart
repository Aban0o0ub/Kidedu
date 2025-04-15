// class CartCourse {
// final List<String> courseIds;
//   final String id;
//   final DateTime addedAt;

//   CartCourse({
//     required this.courseIds,
//     required this.id,
//     required this.addedAt,
//   });

//  factory CartCourse.fromJson(Map<String, dynamic> json) {
//   return CartCourse(
// //courseIds: List<String>.from(json['courseIds'] ?? []), 
// courseIds: [json['course'] ?? ''],// بدلاً من استخدام json['course']
//     id: json['_id'] ?? '',
//     addedAt: DateTime.parse(json['addedAt']),
//   );
// }


//  Map<String, dynamic> toJson() {
//   return {
//     'courseIds': courseIds, 
//     '_id': id,
//     'addedAt': addedAt.toIso8601String(),
//   };
// }

// }

// class CartModel {
//   final String id;
//   final String kidId;
//   final List<CartCourse> courses;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int v;

//   CartModel({
//     required this.id,
//     required this.kidId,
//     required this.courses,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });

//   factory CartModel.fromJson(Map<String, dynamic> json) {
//     return CartModel(
//       id: json['_id'] ?? '',
//       kidId: json['kid'] ?? '',
//       courses: (json['courses'] as List?)
//               ?.map((e) => CartCourse.fromJson(e))
//               .toList() ??
//           [],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       v: json['__v'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'kid': kidId,
//       'courses': courses.map((course) => course.toJson()).toList(),
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       '__v': v,
//     };
//   }
// }
// class AddCartResponse {
//   final String message;
//   final CartModel cart;

//   AddCartResponse({
//     required this.message,
//     required this.cart,
//   });

//   factory AddCartResponse.fromJson(Map<String, dynamic> json) {
//     return AddCartResponse(
//       message: json['message'] ?? '',
//       cart: CartModel.fromJson(json['cart']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'cart': cart.toJson(),
//     };
//   }
// }

class AddCartRequest {
  final List<String> courseIds;

  AddCartRequest({required this.courseIds});

  // تحويل الريكويست إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'courseIds': courseIds,
    };
  }
}
class CartCourse {
  final String courseId;
  final String id;
  final DateTime addedAt;

  CartCourse({
    required this.courseId,
    required this.id,
    required this.addedAt,
  });

  // تحويل JSON إلى موديل CartCourse
  factory CartCourse.fromJson(Map<String, dynamic> json) {
    return CartCourse(
      courseId: json['course'] ?? '',
      id: json['_id'] ?? '',
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  // تحويل موديل CartCourse إلى JSON
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

  // تحويل JSON إلى موديل CartModel
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

  // تحويل موديل CartModel إلى JSON
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
class AddCartResponse {
  final String message;
  final CartModel cart;

  AddCartResponse({
    required this.message,
    required this.cart,
  });

  // تحويل JSON إلى موديل AddCartResponse
  factory AddCartResponse.fromJson(Map<String, dynamic> json) {
    return AddCartResponse(
      message: json['message'] ?? '',
      cart: CartModel.fromJson(json['cart']),
    );
  }

  // تحويل موديل AddCartResponse إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'cart': cart.toJson(),
    };
  }
}
