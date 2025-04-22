import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/arrow_back.dart';
import '../../../sign_up/ui/widgets/custom_button.dart';
import '../../logic/cubit/cart_cubit.dart';
import '../widget/cart_datails.dart';
//import '../widget/cart_datails.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late CartCubit cartCubit;
  @override
  void initState() {
    super.initState();
    cartCubit = context.read<CartCubit>();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ArrowBack(),
            Expanded(child: CartDetails()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: CustomButton(
                text: "Proceed to Payment",
                onPressed: () {
                  context.push(Routes.paymentDetailsView);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}






