import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import 'package:loginpage/features/cart/logic/cubit/cart_cubit.dart';
import '../widgets/payment_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late CartCubit cartCubit;
  @override
  void initState() {
    super.initState();
    cartCubit = context.read<CartCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GetCartFailure) {
            return Center(child: Text('Failed to load cart: ${state.error}'));
          } else if (state is GetCartSuccess) {
            final cart = state.cart;

            double totalPrice = 0;

            final courseCards = cart.courses.map((cartCourse) {
              final course = cartCourse.course;
              final price = course.priceAfterDiscount ?? course.price ?? 0;
              final originalPrice = course.price ?? 0;
              final discount = originalPrice - price;

              totalPrice += price;

              return CoursePaymentCard(
                imagePath: "assets/images/science.jpg",
                courseName: course.courseName,
                price: originalPrice,
                sale: discount,
                totalPrice: price,
              );
            }).toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 10),
                        child: Image.asset("assets/images/Receipt.jpg"),
                      ),
                      const ArrowBack(),
                    ],
                  ),
                  const SizedBox(height: 22),
                  ...courseCards,
                  const SizedBox(height: 10),
                  const Text(
                    "Total Payments",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF02457A),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "$totalPrice \$",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFF0000),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 23, vertical: 35),
                    child: CustomButton(
                        text: "Checkout",
                        width: 380,
                        onPressed: () {
                          // QuickAlert.show(
                          //   context: context,
                          //   type: QuickAlertType.success,
                          //   title: 'Success',
                          //   text: 'Transaction Completed Successfully!',
                          //   confirmBtnText: 'My Courses',
                          //   confirmBtnColor: Colors.green,
                          //   onConfirmBtnTap: () {
                          //     Navigator.pop(context);
                          //      context.go(Routes.myCourses);
                          //   },
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const PaymentScreen()),
                          );
                        }),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          } else {
            return Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }
}
