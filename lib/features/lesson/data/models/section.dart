class SectionModel {
  final String id;
  final String title;
  final String courseId;
  final String instructorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  SectionModel({
    required this.id,
    required this.title,
    required this.courseId,
    required this.instructorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['_id'],
      title: json['title'],
      courseId: json['courseId'],
      instructorId: json['instructorId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
