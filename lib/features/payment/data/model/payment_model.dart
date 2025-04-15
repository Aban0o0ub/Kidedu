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
