// import '../../../add_course/data/models/Course_Model.dart';

// class PaymentRequest {
//   String cardNumber;
//   String? cardHolder;
//   String? expiryDate;
//   String? cvv;
  
//   PaymentRequest({
//     required this.cardNumber,
//     this.cardHolder,
//     this.expiryDate,
//     this.cvv,
//   });
  
//   Map<String, dynamic> toJson() {
//     return {
//       "cardNumber": cardNumber,
//       "cardHolder": cardHolder,
//       "expiryDate": expiryDate,
//       "cvv": cvv,
//     };
//   }
// }

// class PaymentResponse {
//   final bool success;
//   final String message;
//   final PaymentDetails payment;
//   final List<CourseData> purchasedCourses;
//   final int originalTotal;
//   final int discountedTotal;
//   final int discountAmount;
//   final List<InstructorEarnings> instructorsEarnings;

//   PaymentResponse({
//     required this.success,
//     required this.message,
//     required this.payment,
//     required this.purchasedCourses,
//     required this.originalTotal,
//     required this.discountedTotal,
//     required this.discountAmount,
//     required this.instructorsEarnings,
//   });

//   factory PaymentResponse.fromJson(Map<String, dynamic> json) {
//     return PaymentResponse(
//       success: json['success'],
//       message: json['message'],
//       payment: PaymentDetails.fromJson(json['payment']),
//       purchasedCourses: (json['purchasedCourses'] as List)
//           .map((course) => CourseData.fromJson(course))
//           .toList(),
//       originalTotal: json['originalTotal'],
//       discountedTotal: json['discountedTotal'],
//       discountAmount: json['discountAmount'],
//       instructorsEarnings: (json['instructorsEarnings'] as List)
//           .map((earning) => InstructorEarnings.fromJson(earning))
//           .toList(),
//     );
//   }
// }

// class PaymentDetails {
//   final String kid;
//   final List<String> courses;
//   final String? cardNumber;
//   final String? cardHolder;
//   final String? expiryDate;
//   final String? cvv;
//   final int amount;
//   final bool success;
//   final bool discountApplied;
//   final List<EarningBreakdown> earningBreakdown;
//   final String id;
//   final String createdAt;
//   final int version;

//   PaymentDetails({
//     required this.kid,
//     required this.courses,
//     this.cardNumber,
//     this.cardHolder,
//     this.expiryDate,
//     this.cvv,
//     required this.amount,
//     required this.success,
//     required this.discountApplied,
//     required this.earningBreakdown,
//     required this.id,
//     required this.createdAt,
//     required this.version,
//   });

//   factory PaymentDetails.fromJson(Map<String, dynamic> json) {
//     return PaymentDetails(
//       kid: json['kid'],
//       courses: List<String>.from(json['courses']),
//       cardNumber: json['cardNumber'],
//       cardHolder: json['cardHolder'],
//       expiryDate: json['expiryDate'],
//       cvv: json['cvv'],
//       amount: json['amount'],
//       success: json['success'],
//       discountApplied: json['discountApplied'],
//       earningBreakdown: (json['earningBreakdown'] as List)
//           .map((breakdown) => EarningBreakdown.fromJson(breakdown))
//           .toList(),
//       id: json['_id'],
//       createdAt: json['createdAt'],
//       version: json['__v'],
//     );
//   }
// }

// class EarningBreakdown {
//   final String courseId;
//   final String instructorId;
//   final int originalPrice;
//   final int discountedPrice;
//   final int appShare;
//   final int instructorShare;
//   final String id;

//   EarningBreakdown({
//     required this.courseId,
//     required this.instructorId,
//     required this.originalPrice,
//     required this.discountedPrice,
//     required this.appShare,
//     required this.instructorShare,
//     required this.id,
//   });
//   factory EarningBreakdown.fromJson(Map<String, dynamic> json) {
//     return EarningBreakdown(
//       courseId: json['courseId'],
//       instructorId: json['instructorId'],
//       originalPrice: json['originalPrice'],
//       discountedPrice: json['discountedPrice'],
//       appShare: json['appShare'],
//       instructorShare: json['instructorShare'],
//       id: json['_id'],
//     );
//   }
// }

// class InstructorEarnings {
//   final String instructorId;
//   final int earningsFromThisPayment;
//   final int totalEarnings;
//   InstructorEarnings({
//     required this.instructorId,
//     required this.earningsFromThisPayment,
//     required this.totalEarnings,
//   });
//   factory InstructorEarnings.fromJson(Map<String, dynamic> json) {
//     return InstructorEarnings(
//       instructorId: json['instructorId'],
//       earningsFromThisPayment: json['earningsFromThisPayment'],
//       totalEarnings: json['totalEarnings'],
//     );
//   }
// }
import '../../../add_course/data/models/Course_Model.dart';

class PaymentRequest {
   String cardNumber;
   String? cardHolder;
   String? expiryDate;
   String? cvv;

  PaymentRequest({
    required this.cardNumber,
     this.cardHolder,
     this.expiryDate,
     this.cvv,
  });

  Map<String, dynamic> toJson() {
    return {
      "cardNumber": cardNumber,
      "cardHolder": cardHolder,
      "expiryDate": expiryDate,
      "cvv": cvv,
    };
  }
}

class PaymentResponse {
  final bool success;
  final String message;
  final PaymentDetails payment;
  final List<CourseData>
      purchasedCourses;
  final int originalTotal;
  final int discountedTotal;
  final int discountAmount;

  PaymentResponse({
    required this.success,
    required this.message,
    required this.payment,
    required this.purchasedCourses,
    required this.originalTotal,
    required this.discountedTotal,
    required this.discountAmount,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      success: json['success'],
      message: json['message'],
      payment: PaymentDetails.fromJson(json['payment']),
      purchasedCourses: (json['purchasedCourses'] as List)
          .map((course) => CourseData.fromJson(course))
          .toList(),
      originalTotal: json['originalTotal'],
      discountedTotal: json['discountedTotal'],
      discountAmount: json['discountAmount'],
    );
  }
}

class PaymentDetails {
  final String kid;
  final List<String> courses;
  final String? cardNumber;
  final String? cardHolder;
  final String? expiryDate;
  final String? cvv;
  final int amount;
  final bool success;
  final String id;
  final String createdAt;

  PaymentDetails({
    required this.kid,
    required this.courses,
    this.cardNumber,
    this.cardHolder,
    this.expiryDate,
    this.cvv,
    required this.amount,
    required this.success,
    required this.id,
    required this.createdAt,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      kid: json['kid'],
      courses: List<String>.from(json['courses']),
      cardNumber: json['cardNumber'],
      cardHolder: json['cardHolder'],
      expiryDate: json['expiryDate'],
      cvv: json['cvv'],
      amount: json['amount'],
      success: json['success'],
      id: json['_id'],
      createdAt: json['createdAt'],
    );
  }
}