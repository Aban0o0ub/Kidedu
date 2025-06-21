class EarningsResponseModel {
  final String status;
  final EarningsData data;

  EarningsResponseModel({
    required this.status,
    required this.data,
  });

  factory EarningsResponseModel.fromJson(Map<String, dynamic> json) {
    return EarningsResponseModel(
      status: json['status'],
      data: EarningsData.fromJson(json['data']),
    );
  }
}

class EarningsData {
  final num totalEarnings;
  final List<EarningCourse> courses;

  EarningsData({
    required this.totalEarnings,
    required this.courses,
  });

  factory EarningsData.fromJson(Map<String, dynamic> json) {
    return EarningsData(
      totalEarnings: json['totalEarnings'],
      courses: (json['courses'] as List)
          .map((course) => EarningCourse.fromJson(course))
          .toList(),
    );
  }
}

class EarningCourse {
  final String courseName;
  final num originalPrice;
  final num discountedPrice;
  final num earnings;

  EarningCourse({
    required this.courseName,
    required this.originalPrice,
    required this.discountedPrice,
    required this.earnings,
  });

  factory EarningCourse.fromJson(Map<String, dynamic> json) {
    return EarningCourse(
      courseName: json['courseName'],
      originalPrice: json['originalPrice'],
      discountedPrice: json['discountedPrice'],
      earnings: json['earnings'],
    );
  }
}
