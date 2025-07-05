import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/cart/logic/cubit/cart_cubit.dart';
import '../views/home_page.dart';
import 'nav_bar_visibility_controller.dart';

// ignore: must_be_immutable
class CourseCard extends StatefulWidget {
  List<String>? courseImages;
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
    this.courseImages,
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
  // إضافة loading state منفصل لكل card
  bool _isLocalLoading = false;
  
  bool _isValidNetworkImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return false;
    }
    return imagePath.startsWith('http://') || 
           imagePath.startsWith('https://') || 
           imagePath.startsWith('/uploads/');
  }
  
  String _getFullImageUrl(String imagePath) {
    if (imagePath.startsWith('/uploads/')) {
      return 'http://192.168.1.3:3000$imagePath';
    } else if (!imagePath.startsWith('http')) {
      // Add slash if imagePath doesn't start with one
      String pathWithSlash = imagePath.startsWith('/') ? imagePath : '/$imagePath';
      return 'http://192.168.1.3:3000$pathWithSlash';
    }
    return imagePath;
  }

  Widget _buildCourseImage() {
    // Get the first valid image from the list, or use default if no images
    String? imageUrl;
    if (widget.courseImages != null && widget.courseImages!.isNotEmpty) {
      // Find the first non-empty image URL
      for (String url in widget.courseImages!) {
        if (url.isNotEmpty) {
          imageUrl = url;
          break;
        }
      }
    }
    
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset(
        "assets/images/CourseDefaultPhoto.jpeg",
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 80,
            height: 80,
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported, size: 30),
          );
        },
      );
    }

    if (_isValidNetworkImage(imageUrl)) {
      return Image.network(
        _getFullImageUrl(imageUrl),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Handle 404 and other network errors by showing default image
          print('Image loading failed for URL: ${_getFullImageUrl(imageUrl ?? '')}, Error: $error');
          return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Image.asset(
              "assets/images/CourseDefaultPhoto.jpeg",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to icon if default image also fails
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.school, size: 30, color: Colors.grey),
                );
              },
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 80,
            height: 80,
            color: Colors.grey[200],
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      );
    } else {
      // Handle local file paths
      return Image.file(
        File(imageUrl),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/images/CourseDefaultPhoto.jpeg",
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          );
        },
      );
    }
  }

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
              child: _buildCourseImage(),
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
                              'courseImages': widget.courseImages,
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
                : BlocConsumer<CartCubit, CartState>(
                    listener: (context, state) {
                      // إيقاف الـ local loading عند انتهاء العملية
                      if (state is AddCartSuccess || 
                          state is AddCartFailure || 
                          state is RemoveCartSuccess) {
                        if (mounted) {
                          setState(() {
                            _isLocalLoading = false;
                          });
                        }
                      }
                      
                      // عرض رسالة خطأ إذا كان الكورس متضاف مسبقاً
                      if (state is AddCartFailure && 
                          state.error.contains('already')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Course already in cart or purchased'.tr()),
                            backgroundColor: Colors.orange,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                      
                      // الحل: إضافة listener للـ RemoveCartSuccess لتحديث الحالة
                      if (state is RemoveCartSuccess) {
                        // هنا الـ widget هيتحديث تلقائياً عن طريق الـ builder
                        // لأن الـ buildWhen بيسمع للـ RemoveCartSuccess
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is CartStatusChanged ||
                        current is CartInitial ||
                        current is RemoveCartSuccess ||
                        current is AddCartSuccess,
                    builder: (context, state) {
                      final cartCubit = context.read<CartCubit>();
                      final courseId = widget.id ?? '';
                      final isAddedToCart = cartCubit.isCourseAddedToCart(courseId);

                      return SizedBox(
                        width: 100,
                        height: 36,
                        child: OutlinedButton(
                          onPressed: _isLocalLoading
                              ? null
                              : () async {
                                  if (isAddedToCart) {
                                    // الانتقال للسلة
                                    NavBarVisibilityController.showNavBar();
                                    // delay بسيط للتأكد من إن التغيير يتم بشكل صحيح
                                    await Future.delayed(const Duration(milliseconds: 100));
                                    TabControllerHelper.selectedIndexNotifier.value = 4;
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  } else {
                                    // بدء الـ loading للكارد ده فقط
                                    setState(() {
                                      _isLocalLoading = true;
                                    });
                                    
                                    // إضافة الكورس للسلة
                                    context.read<CartCubit>().emitAddNewCart(courseId);
                                  }
                                },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                            backgroundColor:
                                isAddedToCart ? Colors.white : Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: _isLocalLoading
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