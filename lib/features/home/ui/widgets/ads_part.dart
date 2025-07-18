import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import '../../../add_course/data/models/Course_Model.dart';
import '../../../course_details/logic/cubit/course_details_cubit.dart';
import '../../logic/cubit/discounted_courses_cubit.dart';

class DiscountedCoursesCarousel extends StatefulWidget {
  const DiscountedCoursesCarousel({super.key});

  @override
  State<DiscountedCoursesCarousel> createState() => _DiscountedCoursesCarouselState();
}

class _DiscountedCoursesCarouselState extends State<DiscountedCoursesCarousel> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  String? _getFirstValidImage(List<String>? images) {
    if (images == null || images.isEmpty) return null;
    
    for (String image in images) {
      if (image.isNotEmpty) {
        return image;
      }
    }
    return null;
  }
  
  String _getFullImageUrl(String imagePath) {
    if (imagePath.startsWith('/uploads/')) {
      return 'http://192.168.43.204:3000$imagePath';
    } else if (!imagePath.startsWith('http')) {
      // Add slash if imagePath doesn't start with one
      String pathWithSlash = imagePath.startsWith('/') ? imagePath : '/$imagePath';
      return 'http://192.168.43.204:3000$pathWithSlash';
    }
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscountedCoursesCubit, DiscountedCoursesState>(
      builder: (context, state) {
        if (state is DiscountedCoursesLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is GetDiscountedCourseFailure) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'Failed to load discounted courses',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is GetDiscountedCourseSuccess) {
          final courses = state.discountedCourses.take(6).toList();
          
          if (courses.isEmpty) {
                        return SizedBox(
              height: 200,
              child: Center(child: Text('No discounted courses available'.tr())),
            );
          }

          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 18 / 9,
                          enableInfiniteScroll: courses.length > 1,
                          viewportFraction: 0.9,
                          clipBehavior: Clip.hardEdge,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: courses.map((course) => _buildCourseCard(course)).toList(),
                      ),
                    ),
                    // Left Arrow
                    if (courses.length > 1)
                      Positioned(
                        left: 10,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () => _carouselController.previousPage(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Right Arrow
                    if (courses.length > 1)
                      Positioned(
                        right: 10,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () => _carouselController.nextPage(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Dots indicator
              if (courses.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: courses.asMap().entries.map((entry) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key 
                              ? Theme.of(context).primaryColor 
                              : Colors.grey,
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCourseCard(CourseData course) {
    return GestureDetector(
      onTap: () {
        if (course.id != null && course.id!.isNotEmpty) {
          final courseDetailsCubit = context.read<CourseDetailsCubit>();
          
          context.push(
            Routes.courseDetails,
            extra: {
              '_id': course.id,
              'courseDetailsCubit': courseDetailsCubit,
            },
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Course Image
              _getFirstValidImage(course.courseImages) != null
                  ? Image.network(
                      _getFullImageUrl(_getFirstValidImage(course.courseImages)!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/blackfriday.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/blackfriday.jpg',
                      fit: BoxFit.cover,
                    ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // Course info
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Discount badge
                    if (course.discountPercent != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${course.discountPercent?.toInt()}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Course name
                    Text(
                      course.courseName ?? 'Course Name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Category
                    if (course.category != null)
                      Text(
                        course.category!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Price info
                    Row(
                      children: [
                        if (course.price != null)
                          Text(
                            '${course.price} EGP',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        const SizedBox(width: 8),
                        if (course.priceAfterDiscount != null)
                          Text(
                            '${course.priceAfterDiscount} EGP',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}