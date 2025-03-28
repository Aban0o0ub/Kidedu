part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class AddCartSuccess extends CartState {
  final CartModel newCart;
  AddCartSuccess(this.newCart);
}

final class AddCartFailure extends CartState {
  final String error;
  AddCartFailure(this.error);
}
