import 'lesson.dart';

class SectionModel {
  final String id;
  final String title;
  final String? courseId;
  final String? instructorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<LessonModel> lessons;

  SectionModel({
    required this.id,
    required this.title,
    this.courseId,
    this.instructorId,
    this.createdAt,
    this.updatedAt,
    required this.lessons,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
  final lessonsList = json['lessons'] as List<dynamic>? ?? [];
  return SectionModel(
    id: json['id']?.toString() ?? json['_id']?.toString() ?? '', // إزالة as String
    title: json['title']?.toString() ?? '', // إضافة null safety
    courseId: json['courseId']?.toString(), // إزالة as String
    instructorId: json['instructorId']?.toString(), // إزالة as String
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString()) // إضافة toString()
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'].toString()) // إضافة toString()
        : null,
    lessons: lessonsList
        .where((e) => e != null) // تصفية الـ null values
        .map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
}


class CreateSectionResponse {
  final String message;
  final SectionModel section;

  CreateSectionResponse({
    required this.message,
    required this.section,
  });

  factory CreateSectionResponse.fromJson(Map<String, dynamic> json) {
    return CreateSectionResponse(
      message: json['message'],
      section: SectionModel.fromJson(json['section']),
    );
  }
}

class CreateSectionRequest {
  final String title;
  final String courseId;

  CreateSectionRequest(this.courseId, {required this.title});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
    };
  }
}

class GetSectionsResponse {
  final String status;
  final int results;
  final List<SectionModel> sections;

  GetSectionsResponse({
    required this.status,
    required this.results,
    required this.sections,
  });

  factory GetSectionsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final sectionsList = data['sections'] as List<dynamic>? ?? [];

    return GetSectionsResponse(
      status: json['status'] ?? '',
      results: json['results'] ?? 0,
      sections: sectionsList.map((e) => SectionModel.fromJson(e)).toList(),
    );
  }
   factory GetSectionsResponse.empty() {
    return GetSectionsResponse(
      status: 'Success',
      results: 0,
      sections: [],
    );}
}
