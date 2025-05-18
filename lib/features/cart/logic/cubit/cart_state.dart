part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {
}
final class AddCartSuccess extends CartState {
  final CartModel cart;
  AddCartSuccess(this.cart);
}

final class AddCartFailure extends CartState {
  final String error;
  AddCartFailure(this.error);
}

final class GetCartSuccess extends CartState {
  final CartModel cart;
  GetCartSuccess(this.cart);
}

final class GetCartFailure extends CartState {
  final String error;
  GetCartFailure(this.error);
}
class CartStatusChanged extends CartState {}

final class RemoveCartSuccess extends CartState {
  final CartModel cart;
  RemoveCartSuccess(this.cart);
}

final class RemoveCartFailure extends CartState {
  final String error;
  RemoveCartFailure(this.error);
}