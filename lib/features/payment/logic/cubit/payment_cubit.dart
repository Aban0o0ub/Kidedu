import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/payment_model.dart';
import '../../data/repo/payment_repo.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepo paymentRepo;

  PaymentCubit(this.paymentRepo) : super(PaymentInitial());

 Future<void> emitCreatePaymentMethod(String cardNumber) async {
  emit(PaymentLoading());
  try {

    if (cardNumber.isEmpty) {
      throw Exception('Card number is required');
    }

    final paymentResponse = await paymentRepo.paymentProcess(PaymentRequest(cardNumber: cardNumber));
    emit(PaymentSuccess(paymentResponse));
  } catch (e) {
    emit(PaymentFailure(e.toString()));
  }
}

}
