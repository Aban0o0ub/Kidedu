// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../data/model/cart_model.dart';
// import '../../data/repo/cart_repo.dart';
// import '../../logic/cubit/cart_cubit.dart';

// class CartCubit extends Cubit<CartState> {
//   final Map<String, bool> cartStatus = {}; 
// final CartRepo cartRepo;
//   CartCubit(this.cartRepo) : super(CartInitial());

//   Future<void> loadCartStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedCartStatus = prefs.getStringList('cartStatus') ?? [];
//     for (var id in savedCartStatus) {
//       cartStatus[id] = true;
//     }
//   }

//   Future<void> emitAddNewCart(String id) async {
// final CartModel cart = await cartRepo.addCart({"courseIds": [id]});
//     cartStatus[id] = true;
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setStringList('cartStatus', cartStatus.keys.toList());
//     emit(AddCartSuccess(cart));
//   }

//   bool isCourseAddedToCart(String id) {
//     return cartStatus[id] ?? false;
//   }
// }
