class PointsBreakdown {
  final int completedCourses;
  final int attendedSessions;
  final int categoryAchievements;
  final int givenReviews;
  final int watchedVideos;
  final int otherActivities;

  PointsBreakdown({
    required this.completedCourses,
    required this.attendedSessions,
    required this.categoryAchievements,
    required this.givenReviews,
    required this.watchedVideos,
    required this.otherActivities,
  });

  factory PointsBreakdown.fromJson(Map<String, dynamic> json) {
    return PointsBreakdown(
      completedCourses: json['completedCourses'] ?? 0,
      attendedSessions: json['attendedSessions'] ?? 0,
      categoryAchievements: json['categoryAchievements'] ?? 0,
      givenReviews: json['givenReviews'] ?? 0,
      watchedVideos: json['watchedVideos'] ?? 0,
      otherActivities: json['otherActivities'] ?? 0,
    );
  }
}

class MyPointsData {
  final String id;
  final String kidId;
  final int totalPoints;
  final String level;
  final DateTime? lastUpdated;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;
  final PointsBreakdown pointsBreakdown;

  MyPointsData({
    required this.id,
    required this.kidId,
    required this.totalPoints,
    required this.level,
    required this.lastUpdated,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.pointsBreakdown,
  });

  factory MyPointsData.fromJson(Map<String, dynamic> json) {
    return MyPointsData(
      id: json['_id'] ?? '',
      kidId: json['kid'] ?? '',
      totalPoints: json['totalPoints'] ?? 0,
      level: json['level'] ?? '',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'] ?? 0,
      pointsBreakdown:
          PointsBreakdown.fromJson(json['pointsBreakdown'] ?? {}),
    );
  }
}

class MyPointsResponse {
  final bool success;
  final MyPointsData? data;

  MyPointsResponse({
    required this.success,
    required this.data,
  });

  factory MyPointsResponse.fromJson(Map<String, dynamic> json) {
    return MyPointsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? MyPointsData.fromJson(json['data']) : null,
    );
  }
}
