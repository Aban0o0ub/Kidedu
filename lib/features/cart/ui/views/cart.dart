import 'package:flutter/material.dart';
import '../../../../core/widgets/arrow_back.dart';
import '../widget/cart_datails.dart';
import '../widget/empty_cart.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool hasCourses = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ArrowBack(),
          hasCourses ? CartDetails() : EmptyCart(),
        ],
      ),
    );
  }
}





