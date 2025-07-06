import 'package:flutter/material.dart';


class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Image.asset('assets/images/emptycart.jpg', height: 300, width: 300),
          SizedBox(height: 30),
          Text(
            "Your cart is empty!",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 200),
        ],
      ),
    );
  }
}
