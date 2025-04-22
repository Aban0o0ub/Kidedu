import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/cart/logic/cubit/cart_cubit.dart';

import '../../../../core/routing/routes.dart';

// ignore: must_be_immutable
class CourseCard extends StatefulWidget {
  String? courseImage;
  final String courseName;
  String? instructor;
  final String description;
  final num price;
  final String availability;
  String? id;
  final bool fromCartPage;

  CourseCard({
    super.key,
    this.courseImage,
    required this.courseName,
    this.instructor,
    required this.description,
    required this.price,
    required this.availability,
    this.id,
    this.fromCartPage = false,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  //bool isAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  widget.courseImage != null && widget.courseImage!.isNotEmpty
                      ? Image.network(widget.courseImage!,
                          width: 80, height: 80, fit: BoxFit.cover)
                      : Image.asset("assets/images/CourseDefaultPhoto.jpeg",
                          width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.courseName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: const Text("Learn more",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                  Text(
                      widget.instructor != null
                          ? "By ${widget.instructor}"
                          : "No instructor",
                      style: const TextStyle(color: Colors.grey)),
                  Text(widget.description,
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text("\$${widget.price.toString()}",
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text(widget.availability,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            widget.fromCartPage
                ? SizedBox(
                    width: 120,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Remove from Cart",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                : BlocBuilder<CartCubit, CartState>(
                    buildWhen: (previous, current) =>
                        current is CartStatusChanged ||
                        current is CartInitial ||
                        current is CartLoading,
                    builder: (context, state) {
                      final cartCubit = context.read<CartCubit>();
                      final courseId = widget.id ?? '';
                      final isAddedToCart =
                          cartCubit.isCourseAddedToCart(courseId);

                      return OutlinedButton(
                        onPressed: state is CartLoading
                            ? null
                            : () {
                                if (isAddedToCart) {
                                  context.push(Routes.cartPage);
                                } else {
                                  context
                                      .read<CartCubit>()
                                      .emitAddNewCart(courseId);
                                }
                              },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          backgroundColor:
                              isAddedToCart ? Colors.white : Colors.blue,
                        ),
                        child: state is CartLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isAddedToCart ? "Go to cart" : "Add to cart",
                                style: TextStyle(
                                  color: isAddedToCart
                                      ? Colors.blue
                                      : Colors.white,
                                ),
                              ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}