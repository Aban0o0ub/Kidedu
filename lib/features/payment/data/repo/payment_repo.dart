import '../../../../core/helper/cache_helper.dart';
import '../../../../core/networking/web_services.dart';
import '../model/payment_model.dart';

class PaymentRepo {
  final WebServices webServices;

  PaymentRepo(this.webServices);

  Future<PaymentResponse> paymentProcess(PaymentRequest paymentRequest) async {
    String? token = await CacheHelper.getData(key: "token");

    if (token == null) {
      throw Exception('Token is missing');
    }

    return await webServices.processPayment(paymentRequest);
  }
}
