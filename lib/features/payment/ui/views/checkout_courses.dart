import 'package:flutter/material.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';

import '../widgets/payment_card.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 10),
                  child: Image.asset("assets/images/Receipt.jpg"),
                ),
                ArrowBack(),
              ],
            ),
            SizedBox(
              height: 22,
            ),
            CoursePaymentCard(
              imagePath: "assets/images/science.jpg",
              courseName: "Course Name",
              price: 800,
              sale: 25,
              totalPrice: 600,
            ),
            Text(
              "Total Payments",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF02457A),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "1300 \$",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFF0000),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 23, left: 23, top: 35),
              child: CustomButton(
                text: "Checkout",
                width: 380,
                onPressed: () {
                  
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
