import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/ui/widgets/nav_bar_visibility_controller.dart';
import '../../logic/cubit/cart_cubit.dart';
import '../widget/cart_datails.dart';

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
    NavBarVisibilityController.showNavBar();
    cartCubit = context.read<CartCubit>();
    cartCubit.emitGetCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: CartDetails()),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            //   child: CustomButton(
            //     text: "Proceed to Payment",
            //     onPressed: () {
            //       context.push(Routes.paymentScreen);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

