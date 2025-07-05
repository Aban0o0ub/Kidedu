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
  final List<String>? images;  // Added support for multiple images
  final DateTime createdAt;
  final bool isFinalLesson;

  LessonModel({
    required this.id,
    required this.name,
    required this.sectionId,
    required this.instructorId,
    this.description,
    this.youtubeVideoUrl,
    this.images,  // Added images parameter
    required this.createdAt,
    this.quiz,
    required this.isFinalLesson,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    
    // Handle images array
    List<String>? imagesList;
    if (json['images'] != null) {
      if (json['images'] is List) {
        imagesList = (json['images'] as List)
            .where((img) => img != null && img.toString().isNotEmpty)
            .map((img) => img.toString())
            .toList();
      } else if (json['images'] is String && json['images'].toString().isNotEmpty) {
        imagesList = [json['images'].toString()];
      }
    }

    // Handle YouTube URL with multiple possible field names
    String? youtubeUrl;
    List<String> possibleYouTubeFields = [
      'youtubeVideoUrl',
      'videoUrl', 
      'youtube_url',
      'video_url',
      'youtubeUrl',
      'videoLink',
      'video_link'
    ];
    
    for (String field in possibleYouTubeFields) {
      if (json[field] != null && json[field].toString().isNotEmpty) {
        youtubeUrl = json[field].toString();
        print('🎥 DEBUG: Found YouTube URL in field "$field": $youtubeUrl');
        break;
      }
    }
    
    

    return LessonModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      sectionId: json['sectionId']?.toString() ?? '',
      instructorId: json['instructorId']?.toString() ?? '',
      description: json['description']?.toString(),
      youtubeVideoUrl: youtubeUrl,
      images: imagesList,  // Added images handling
      quiz: json['quiz']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isFinalLesson: json['isFinalLesson'] ?? false,
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
  final List<File> files;  // Already supports multiple files

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
class LessonListResponse {
  final String status;
  final String? message;
  final int results;
  final List<LessonModel> lessons;

  LessonListResponse({
    required this.status,
    this.message,
    required this.results,
    required this.lessons,
  });

  factory LessonListResponse.fromJson(Map<String, dynamic> json) {
    // Debug: Log the complete JSON structure
    print('🔍 DEBUG LessonListResponse: Full JSON: $json');
    
    final data = json['data'] ?? {};
    print('🔍 DEBUG LessonListResponse: data field: $data');
    
    List<LessonModel> lessons = [];
    
    // Check for the new structure: data.sections[].lessons[]
    if (data['sections'] != null && data['sections'] is List) {
      final sections = data['sections'] as List<dynamic>;
      print('🔍 DEBUG LessonListResponse: Found ${sections.length} sections');
      
      // Extract lessons from all sections
      for (final section in sections) {
        if (section is Map<String, dynamic> && section['lessons'] != null) {
          final sectionLessons = section['lessons'] as List<dynamic>? ?? [];
          print('🔍 DEBUG LessonListResponse: Section has ${sectionLessons.length} lessons');
          
          for (final lessonJson in sectionLessons) {
            if (lessonJson is Map<String, dynamic>) {
              lessons.add(LessonModel.fromJson(lessonJson));
            }
          }
        }
      }
    }
    // Fallback: Check for the old structure: data.lessons[]
    else if (data['lessons'] != null && data['lessons'] is List) {
      final lessonsJson = data['lessons'] as List<dynamic>;
      print('🔍 DEBUG LessonListResponse: Found lessons in old structure: ${lessonsJson.length}');
      lessons = lessonsJson
          .where((item) => item is Map<String, dynamic>)
          .map((lessonJson) => LessonModel.fromJson(lessonJson as Map<String, dynamic>))
          .toList();
    }
    
    print('🔍 DEBUG LessonListResponse: Total lessons parsed: ${lessons.length}');
    
    return LessonListResponse(
      status: json['status'] ?? 'Success',
      message: json['message'],
      results: json['results'] ?? lessons.length,
      lessons: lessons,
    );
  }
}
