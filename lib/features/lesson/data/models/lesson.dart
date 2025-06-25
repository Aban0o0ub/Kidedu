// import 'dart:io';
// import 'package:loginpage/features/lesson/data/models/section.dart';

// class LessonModel {
//   final String id;
//   final String name;
//   final String sectionId;
//   final String instructorId;
//   final String? quiz;
//   final String? description;
//   final String? youtubeVideoUrl;
//   final DateTime createdAt;

//   LessonModel({
//     required this.id,
//     required this.name,
//     required this.sectionId,
//     required this.instructorId,
//     this.description,
//     this.youtubeVideoUrl,
//     required this.createdAt,
//     this.quiz,
//   });

//   factory LessonModel.fromJson(Map<String, dynamic> json) {
//     return LessonModel(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       sectionId: json['sectionId'] ?? '',
//       instructorId: json['instructorId'] ?? '',
//       description: json['description'],
//       youtubeVideoUrl: json['youtubeVideoUrl'],
//       quiz: json['quiz'],
//       createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
//     );
//   }
// }


// class LessonResponse {
//   final LessonModel lesson;
//   final SectionModel section;

//   LessonResponse({
//     required this.lesson,
//     required this.section,
//   });

//   factory LessonResponse.fromJson(Map<String, dynamic> json) {
//     try {
//       final data = json['data'] as Map<String, dynamic>? ?? {};
//       if (data.isEmpty) {
//         throw Exception('No data found in response');
//       }

//       return LessonResponse(
//         lesson: LessonModel.fromJson(data['lesson'] as Map<String, dynamic>),
//         section: SectionModel.fromJson(data['section'] as Map<String, dynamic>),
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
// }

// class LessonCreateRequest {
//   final String sectionId;
//   final String name;
//   final String description;
//   final String youtubeVideoUrl;
//   final List<File> files;

//   LessonCreateRequest({
//     required this.sectionId,
//     required this.name,
//     required this.description,
//     required this.youtubeVideoUrl,
//     required this.files,
//   });

//   Map<String, String> toJson() {
//     return {
//       'name': name,
//       'description': description,
//       'youtubeVideoUrl': youtubeVideoUrl,
//     };
//   }
// }

// class LessonListResponse {
//   final List<LessonModel> lessons;

//   LessonListResponse({required this.lessons});

//   factory LessonListResponse.fromJson(Map<String, dynamic> json) {
//     final data = json['data'] ?? {};
//     final lessonsJson = data['lessons'] as List<dynamic>? ?? [];

//     final lessons = lessonsJson
//         .map((lessonJson) => LessonModel.fromJson(lessonJson))
//         .toList();

//     return LessonListResponse(lessons: lessons);
//   }
// }
import 'dart:io';
import 'package:loginpage/features/lesson/data/models/section.dart';

class LessonModel {
  final String id;
  final String name;
  final String sectionId;
  final String instructorId;
  final String? quiz;
  final String? description;
  final String? youtubeVideoUrl;
  final DateTime createdAt;

  LessonModel({
    required this.id,
    required this.name,
    required this.sectionId,
    required this.instructorId,
    this.description,
    this.youtubeVideoUrl,
    required this.createdAt,
    this.quiz,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
  return LessonModel(
    id: json['_id']?.toString() ?? json['id']?.toString() ?? '', // إزالة as String
    name: json['name']?.toString() ?? '', // إضافة default value
    sectionId: json['sectionId']?.toString() ?? '', // إضافة default value
    instructorId: json['instructorId']?.toString() ?? '', // إضافة default value
    description: json['description']?.toString(), // إزالة as String
    youtubeVideoUrl: json['youtubeVideoUrl']?.toString(), // إزالة as String
    quiz: json['quiz']?.toString(),
    createdAt: json['createdAt'] != null 
        ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
        : DateTime.now(), // إضافة fallback
  );
}
}

class LessonResponse {
  final LessonModel lesson;
  final SectionModel section;

  LessonResponse({
    required this.lesson,
    required this.section,
  });

  factory LessonResponse.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] as Map<String, dynamic>? ?? {};
      if (data.isEmpty) {
        throw Exception('No data found in response');
      }

      return LessonResponse(
        lesson: LessonModel.fromJson(data['lesson'] as Map<String, dynamic>),
        section: SectionModel.fromJson(data['section'] as Map<String, dynamic>),
      );
    } catch (e) {
      rethrow;
    }
  }
}

class LessonCreateRequest {
  final String sectionId;
  final String name;
  final String description;
  final String youtubeVideoUrl;
  final List<File> files;

  LessonCreateRequest({
    required this.sectionId,
    required this.name,
    required this.description,
    required this.youtubeVideoUrl,
    required this.files,
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      'description': description,
      'youtubeVideoUrl': youtubeVideoUrl,
    };
  }
}

class LessonListResponse {
  final List<LessonModel> lessons;

  LessonListResponse({required this.lessons});

  factory LessonListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final lessonsJson = data['lessons'] as List<dynamic>? ?? [];

    final lessons = lessonsJson
        .map((lessonJson) => LessonModel.fromJson(lessonJson))
        .toList();

    return LessonListResponse(lessons: lessons);
  }
}