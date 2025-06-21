// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:loginpage/features/cart/logic/cubit/cart_cubit.dart';
// import '../views/home_page.dart';

// // ignore: must_be_immutable
// class CourseCard extends StatefulWidget {
//   String? courseImage;
//   final String courseName;
//   String? instructor;
//   final String description;
//   final num price;
//   final String availability;
//   String? id;
//   final bool fromCartPage;

//   CourseCard({
//     super.key,
//     this.courseImage,
//     required this.courseName,
//     this.instructor,
//     required this.description,
//     required this.price,
//     required this.availability,
//     this.id,
//     this.fromCartPage = false,
//   });

//   @override
//   State<CourseCard> createState() => _CourseCardState();
// }

// class _CourseCardState extends State<CourseCard> {
//   //bool isAddedToCart = false;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child:
//                   widget.courseImage != null && widget.courseImage!.isNotEmpty
//                       ? Image.network(widget.courseImage!,
//                           width: 80, height: 80, fit: BoxFit.cover)
//                       : Image.asset("assets/images/CourseDefaultPhoto.jpeg",
//                           width: 80, height: 80, fit: BoxFit.cover),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(widget.courseName,
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold)),
//                       const Spacer(),
//                       GestureDetector(
//                         onTap: () {},
//                         child: const Text("Learn more",
//                             style: TextStyle(color: Colors.grey)),
//                       ),
//                     ],
//                   ),
//                   Text(
//                       widget.instructor != null
//                           ? "By ${widget.instructor}"
//                           : "No instructor",
//                       style: const TextStyle(color: Colors.grey)),
//                   Text(widget.description,
//                       style: const TextStyle(fontSize: 14)),
//                   const SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Text("\$${widget.price.toString()}",
//                           style: const TextStyle(
//                               color: Colors.red, fontWeight: FontWeight.bold)),
//                       const SizedBox(width: 8),
//                       Text(widget.availability,
//                           style: const TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             widget.fromCartPage
//                 ? SizedBox(
//                     width: 120,
//                     child: OutlinedButton(
//                       onPressed: () {
//                         final courseId = widget.id;
//                         if (courseId != null) {
//                           context.read<CartCubit>().emitRemoveFromCart({
//                             "courseId": widget.id.toString(),
//                           });
//                         }
//                       },
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                       child: const Text(
//                         "Remove",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   )
//                 : BlocBuilder<CartCubit, CartState>(
//                     buildWhen: (previous, current) =>
//                         current is CartStatusChanged ||
//                         current is CartInitial ||
//                         current is CartLoading,
//                     builder: (context, state) {
//                       final cartCubit = context.read<CartCubit>();
//                       final courseId = widget.id ?? '';
//                       final isAddedToCart =
//                           cartCubit.isCourseAddedToCart(courseId);

//                       return OutlinedButton(
//                         onPressed: state is CartLoading
//                             ? null
//                             : () {
//                                 if (isAddedToCart) {
//                                   TabControllerHelper
//                                       .selectedIndexNotifier.value = 4;

//                                   WidgetsBinding.instance
//                                       .addPostFrameCallback((_) {
//                                     if (Navigator.canPop(context)) {
//                                       Navigator.pop(context);
//                                     }
//                                   });
//                                 } else {
//                                   context
//                                       .read<CartCubit>()
//                                       .emitAddNewCart(courseId);
//                                 }
//                               },
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Colors.blue),
//                           backgroundColor:
//                               isAddedToCart ? Colors.white : Colors.blue,
//                         ),
//                         child: state is CartLoading
//                             ? const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : Text(
//                                 isAddedToCart ? "Go to cart" : "Add to cart",
//                                 style: TextStyle(
//                                   color: isAddedToCart
//                                       ? Colors.blue
//                                       : Colors.white,
//                                 ),
//                               ),
//                       );
//                     },
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/cart/logic/cubit/cart_cubit.dart';
import '../views/home_page.dart';

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
  final bool forceBlueBookmarkIcon;
  final Function(Map<String, dynamic>)? onBookmark;

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
    this.forceBlueBookmarkIcon = false,
    this.onBookmark,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
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
                      Expanded(
                        child: Text(
                          widget.courseName,
                          style: const TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (widget.onBookmark != null) {
                            widget.onBookmark!({
                              'id': widget.id,
                              'courseImage': widget.courseImage,
                              'courseName': widget.courseName,
                              'instructor': widget.instructor,
                              'description': widget.description,
                              'price': widget.price,
                              'availability': widget.availability,
                            });
                          }
                        },
                        child: Icon(
                          widget.forceBlueBookmarkIcon 
                              ? Icons.bookmark 
                              : Icons.bookmark_border,
                          color: widget.forceBlueBookmarkIcon 
                              ? Colors.blue 
                              : Colors.grey,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                      widget.instructor != null
                          ? "By ${widget.instructor}"
                          : "No instructor",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "\$${widget.price.toString()}",
                        style: const TextStyle(
                          color: Colors.red, 
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.availability,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            widget.fromCartPage
                ? SizedBox(
                    width: 100,
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () {
                        final courseId = widget.id;
                        if (courseId != null) {
                          context.read<CartCubit>().emitRemoveFromCart({
                            "courseId": widget.id.toString(),
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: const Text(
                        "Remove",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
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

                      return SizedBox(
                        width: 100,
                        height: 36,
                        child: OutlinedButton(
                          onPressed: state is CartLoading
                              ? null
                              : () {
                                  if (isAddedToCart) {
                                    TabControllerHelper
                                        .selectedIndexNotifier.value = 4;

                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                    });
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
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: state is CartLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
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
                                    fontSize: 12,
                                  ),
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
