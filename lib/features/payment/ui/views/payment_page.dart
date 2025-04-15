import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection/injection.dart';
import '../../../../core/widgets/appbar.dart';
import '../../logic/cubit/payment_cubit.dart';
import '../widgets/payment_view_body.dart';

class PaymentDetailsView extends StatefulWidget {
  const PaymentDetailsView({super.key});

  @override
  State<PaymentDetailsView> createState() => _PaymentDetailsViewState();
}

class _PaymentDetailsViewState extends State<PaymentDetailsView> {
  late PaymentCubit paymentCubit;

  @override
  void initState() {
    super.initState();
    paymentCubit = getIt<PaymentCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocProvider.value(
        value: paymentCubit,
        child: Scaffold(
          appBar: CustomAppBar(title: 'Payment'),
          body: PaymentDetailsViewBody(paymentCubit: paymentCubit),
        ),
      ),
    );
  }
}
