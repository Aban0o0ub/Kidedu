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

class AdminStatsResponseModel {
  final String status;
  final AdminStatsData data;

  AdminStatsResponseModel({
    required this.status,
    required this.data,
  });

  factory AdminStatsResponseModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsResponseModel(
      status: json['status'],
      data: AdminStatsData.fromJson(json['data']),
    );
  }
}

class AdminStatsData {
  final num totalProfit;
  final int totalPayments;
  final DateTime lastUpdated;
  final UsersData users;

  AdminStatsData({
    required this.totalProfit,
    required this.totalPayments,
    required this.lastUpdated,
    required this.users,
  });

  factory AdminStatsData.fromJson(Map<String, dynamic> json) {
    return AdminStatsData(
      totalProfit: json['totalProfit'],
      totalPayments: json['totalPayments'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      users: json['users'] != null 
          ? UsersData.fromJson(json['users'])
          : UsersData(kids: 0, instructors: 0),
    );
  }
}

class UsersData {
  final int kids;
  final int instructors;

  UsersData({
    required this.kids,
    required this.instructors,
  });

  factory UsersData.fromJson(Map<String, dynamic> json) {
    return UsersData(
      kids: json['kids'] ?? 0,
      instructors: json['instructors'] ?? 0,
    );
  }
}
