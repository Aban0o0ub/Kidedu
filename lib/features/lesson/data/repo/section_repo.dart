import '../../../../core/helper/cache_helper.dart';
import '../../../../core/networking/web_services.dart';
import '../models/section.dart';

class SectionRepo {
  final WebServices webServices;

  SectionRepo(this.webServices);

  Future<CreateSectionResponse> addSection(
      CreateSectionRequest newSection) async {
    String? token = await CacheHelper.getData(key: "token");

    if (token == null) {
      throw Exception('Token is missing');
    }

    return await webServices.addSection(newSection);
  }

   Future<GetSectionsResponse> getSection(
      String courseId) async {
    String? token = await CacheHelper.getData(key: "token");

    if (token == null) {
      throw Exception('Token is missing');
    }

    return await webServices.getSectionByCourseId(courseId);
  }
}
