import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/cart/ui/widget/empty_cart.dart';

import '../../../../core/routing/routes.dart';
import '../../../home/ui/widgets/course_card.dart';
import '../../../sign_up/ui/widgets/custom_button.dart';
import '../../logic/cubit/cart_cubit.dart';

class CartDetails extends StatelessWidget {
  const CartDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetCartSuccess || state is RemoveCartSuccess) {
          final cartCourses = (state is GetCartSuccess)
              ? state.cart.courses
              : (state as RemoveCartSuccess).cart.courses;

          if (cartCourses.isEmpty) {
            return const EmptyCart();
          }

          return Column(
            children: [
              Image.asset(
                'assets/images/cart.jpg',
                width: double.infinity,
                height: 244,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 32),
                  itemCount: cartCourses.length + 1,
                  itemBuilder: (context, index) {
                    if (index < cartCourses.length) {
                      final course = cartCourses[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: CourseCard(
                          courseImages: course.course is String
                              ? null
                              : course.course.courseImages,
                          courseName: course.course is String
                              ? 'Course Name'
                              : (course.course.courseName ?? ""),
                          instructor: course.course is String
                              ? 'Instructor'
                              : (course.course.courseName ?? ""),
                          description: course.course is String
                              ? 'Description'
                              : (course.course.description ?? ''),
                          price: course.course is String
                              ? 0
                              : (course.course.price ?? 0),
                          availability: course.course is String
                              ? 'Available'
                              : (course.course.availability ?? 'Available'),
                          id: course.course is String
                              ? course.course
                              : course.course.id,
                          fromCartPage: true,
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 35.0,
                          vertical: 22,
                        ).copyWith(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 32),
                        child: CustomButton(
                          text: "Proceed to Payment",
                          onPressed: () {
                            context.push(Routes.paymentScreen);
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        } else if (state is GetCartFailure) {
          return const EmptyCart();
        } else {
          return const Center(child: Text('Something went wrong.'));
        }
      },
    );
  }
}
