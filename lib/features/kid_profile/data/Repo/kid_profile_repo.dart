import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

import '../../../../core/helper/cache_helper.dart';

class KidProfileRepo {
  final WebServices webServices;

  KidProfileRepo(this.webServices);

  Future<KidData> getKidProfile() async {
    return await webServices.getKidByToken();
  }

  Future<KidResponse> updateKidProfile(KidData kidData) async {
    return await webServices.updateKidProfile(kidData);
  }

  
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final token = CacheHelper.getData(key: 'token');
    final role = CacheHelper.getData(key: 'role');

    if (token == null || role == null) {
      throw Exception('Unauthorized');
    }

    final response = await webServices.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      token: token,
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['message'] ?? 'Password change failed');
    }
  }
}
