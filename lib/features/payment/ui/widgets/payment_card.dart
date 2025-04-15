import 'package:flutter/material.dart';

class CoursePaymentCard extends StatelessWidget {
  const CoursePaymentCard({
    required this.courseName,
    required this.imagePath,
    required this.price,
    required this.sale,
    required this.totalPrice,
    super.key,
  });

  final String imagePath;
  final String courseName;
  final int price;
  final int sale;
  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff02457A), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 98,
              padding: EdgeInsets.only(top: 16.0, left: 10, bottom: 16),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      courseName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF02457A),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 18),
                        children: [
                          TextSpan(
                            text: 'Price:- ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF02457A),
                            ),
                          ),
                          TextSpan(
                            text: "${price.toString()} \$",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF02457A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 18),
                        children: [
                          TextSpan(
                            text: 'Sale:- ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF02457A),
                            ),
                          ),
                          TextSpan(
                            text: sale == 0 ? "__" : " ${sale.toString()} %",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF02457A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 18),
                        children: [
                          TextSpan(
                            text: 'Total Price:- ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFFF0000),
                            ),
                          ),
                          TextSpan(
                            text: "${totalPrice.toString()} \$",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFFF0000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
