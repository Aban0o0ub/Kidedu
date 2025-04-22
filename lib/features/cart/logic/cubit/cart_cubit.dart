import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/cart_model.dart';
import '../../data/repo/cart_repo.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo;
  //final Map<String, bool> cartStatus = {};

  CartCubit(this.cartRepo) : super(CartInitial());

  Map<String, bool> cartStatus = {};

  Future<void> emitAddNewCart(String id) async {
  emit(CartLoading());
  try {
    final CartModel cart = await cartRepo.addCart({
      "courseIds": [id]
    });

    cartStatus[id] = true;

    emit(AddCartSuccess(cart));
  //emit(CartInitial());

    emit(CartStatusChanged());
  } catch (e) {
    emit(AddCartFailure(e.toString()));
  }
}


  bool isCourseAddedToCart(String id) {
    return cartStatus[id] ?? false;
  }

  Future<void> emitGetCart() async {
    emit(CartLoading());
    try {
      final CartModel cart = await cartRepo.getCart();
      emit(GetCartSuccess(cart));
    } catch (e) {
      emit(GetCartFailure(e.toString()));
    }
  }

}


// class CartCubit extends Cubit<CartState> {
//   final CartRepo cartRepo;
//   //final Map<String, bool> cartStatus = {};

//   CartCubit(this.cartRepo) : super(CartInitial());

//   Map<String, bool> cartStatus = {};

//   Future<void> emitAddNewCart(String id) async {
//     emit(CartLoading());
//     try {
//       final CartModel cart = await cartRepo.addCart({
//         "courseIds": [id]
//       });
//       cartStatus[id] = true;
//       emit(AddCartSuccess(cart));

//       await Future.delayed(Duration(seconds: 1));
//       emit(CartInitial());
//     } catch (e) {
//       emit(AddCartFailure(e.toString()));
//     }
//   }

//   bool isCourseAddedToCart(String id) {
//     return cartStatus[id] ?? false;
//   }
// }