import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstCard extends StatelessWidget {
  const FirstCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195,
      width: 352,
      decoration: BoxDecoration(
        color: Colors.white, // Add background color if needed
        borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded corners
        border: Border.all(
          color: Color(0XFF02457A), // Border color
          width: 2, // Optional: Adjust border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Light shadow color
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 5), // Shadow position
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
              "assets/images/hand-drawn-black-friday-concept-removebg-preview 1.png"),
          Text(
            textAlign: TextAlign.center,
            "Save up to \n50% !",
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF02457A),
              letterSpacing: 1,
            ),
          )
        ],
      ),
    );
  }
}
