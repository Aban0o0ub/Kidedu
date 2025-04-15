part of 'payment_cubit.dart';



@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

final class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentResponse paymentResponse;

  PaymentSuccess(this.paymentResponse);
}

class PaymentFailure extends PaymentState {
  final String error;

  PaymentFailure(this.error);
}