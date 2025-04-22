import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/cart/ui/widget/empty_cart.dart';

import '../../../home/ui/widgets/course_card.dart';
import '../../logic/cubit/cart_cubit.dart';

class CartDetails extends StatelessWidget {
  const CartDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetCartSuccess) {
          final cartCourses = state.cart.courses;

          if (cartCourses.isEmpty) {
            return const EmptyCart();
          }

          return Column(
            children: [
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/cart.jpg',
                width: 352,
                height: 244,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: cartCourses.length,
                  itemBuilder: (context, index) {
                    final course = cartCourses[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: CourseCard(
                        courseImage: course.course.courseImage,
                        courseName: course.course.courseName ?? "",
                        instructor: course.course.courseName??"",
                        description: course.course.description ?? '',
                        price: course.course.price ?? 0,
                        availability: course.course.availability ?? 'Available',
                        id: course.id,
                        fromCartPage: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is GetCartFailure) {
          return Center(child: Text(state.error));
        } else {
          return const Center(child: Text('Something went wrong.'));
        }
      },
    );
  }
}
