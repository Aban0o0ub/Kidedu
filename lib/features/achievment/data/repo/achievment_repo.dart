import '../../../../core/networking/web_services.dart';
import '../model/achievment_model.dart';

class AchievmentRepo {
  final WebServices webServices;

  AchievmentRepo(this.webServices);

  Future<MyPointsResponse> getMyPoints() async {
    return await webServices.getMyPoints();
  }
}