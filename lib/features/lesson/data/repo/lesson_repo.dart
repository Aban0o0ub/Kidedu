import '../../../../core/networking/web_services.dart';
import '../models/lesson.dart';

class LessonRepo {
  final WebServices webServices;

  LessonRepo(this.webServices);

  Future<LessonResponse> addLesson(LessonCreateRequest newLesson) async {
    return await webServices.addLesson(newLesson);
  }

  Future<LessonListResponse> getLesson(String sectionId) async {
    return await webServices.getLessonBySectionId(sectionId);
  }
}
