import '../../../../core/helper/cache_helper.dart';
import '../../../../core/networking/web_services.dart';
import '../model/cart_model.dart';

class CartRepo {
  final WebServices webServices;

  CartRepo(this.webServices);

  Future<CartModel> addCart(Map<String, dynamic> cartCourse) async {
    try {
      String? token = await CacheHelper.getData(key: "token");

      if (token == null) {
        throw Exception('Token is missing');
      }

      final addCartRequest = AddCartRequest(courseIds: cartCourse['courseIds']);

      final cartResponse = await webServices.addCart(addCartRequest.toJson());

      return cartResponse;
    } catch (e) {
      throw Exception('Error adding course to cart: ${e.toString()}');
    }
  }

  Future<CartModel> getCart() async {
    String? token = await CacheHelper.getData(key: "token");

    if (token == null) {
      throw Exception('Token is missing');
    }

    return await webServices.getCart();
  }

  Future<RemoveCartResponse> removeFromCart(
      Map<String, dynamic> cartCourseData) async {
    return await webServices.removeFromCart(cartCourseData);
  }
}
