import '../../../../core/helper/cache_helper.dart';
import '../../../../core/networking/web_services.dart';
import '../model/cart_model.dart';

class CartRepo {
  final WebServices webServices;

  CartRepo(this.webServices);
Future<CartModel> addCart(CartCourse newCart) async {
  String? token = await CacheHelper.getData(key: "token");

  if (token == null) {
    throw Exception('Token is missing');
  }
  
 return await webServices.addCart({'courseId': newCart.courseId});
}


}
