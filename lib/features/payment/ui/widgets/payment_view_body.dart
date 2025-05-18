import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';
import '../../../sign_up/ui/widgets/custom_button.dart';
import '../../logic/cubit/payment_cubit.dart';
import 'custom_credit_card.dart';

class PaymentDetailsViewBody extends StatefulWidget {
  const PaymentDetailsViewBody({super.key, required PaymentCubit paymentCubit});

  @override
  State<PaymentDetailsViewBody> createState() => _PaymentDetailsViewBodyState();
}

class _PaymentDetailsViewBodyState extends State<PaymentDetailsViewBody> {
  String cardNumber = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const PaymentScreen()),
          //   );
          // } else if (state is PaymentFailure) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text(state.error)),
          //   );
          QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'Success',
              text: 'Transaction Completed Successfully!',
              confirmBtnText: 'My Courses',
              confirmBtnColor: Colors.green,
              onConfirmBtnTap: () {
  Navigator.of(context, rootNavigator: true).pop();

  // ارجع للهوم ومعاك رقم التاب
  GoRouter.of(context).go('/home?tab=3');
}

// onConfirmBtnTap: () {
//   Navigator.of(context, rootNavigator: true).pop();

//   // ارجع للهوم بيج
//   Future.microtask(() {
//     GoRouter.of(context).go('/home?tab=3');


//     // استنى لحظة بسيطة لحد ما يحصل التنقل
//     Future.delayed(const Duration(milliseconds: 200), () {
//       TabControllerHelper.selectedIndexNotifier.value = 3; 
//     });
//   });
// }




              );
        } else if (state is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomCreditCard(
              onCardNumberChanged: (value) {
                cardNumber = value;
              },
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                child: CustomButton(
                  text: 'Confirm',
                  onPressed: () {
                    final cleanedCardNumber = cardNumber.replaceAll(' ', '');
                    context
                        .read<PaymentCubit>()
                        .emitCreatePaymentMethod(cleanedCardNumber);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
