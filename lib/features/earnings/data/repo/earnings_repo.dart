import '../../../../core/networking/web_services.dart';
import '../model/earnings_model.dart';

class EarningsRepo {
  final WebServices webServices;

  EarningsRepo(this.webServices);

  Future<EarningsResponseModel> getInstructorEarnings() async {
    return await webServices.getInstructorEarnings();
  }
}