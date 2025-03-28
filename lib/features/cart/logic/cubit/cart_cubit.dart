
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/cart_model.dart';
import '../../data/repo/cart_repo.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo;

  CartCubit(this.cartRepo) : super(CartInitial());

 Future<void> emitAddNewCart(dynamic newCart) async {
  emit(CartLoading());
  try {
    final CartModel myCourses = await cartRepo.addCart(newCart.courseId);
    emit(AddCartSuccess(myCourses));
  } catch (e) {
    emit(AddCartFailure(e.toString()));
  }
}

}
