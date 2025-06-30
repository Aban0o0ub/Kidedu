import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/core/widgets/appbar.dart';
import 'package:loginpage/features/home/logic/cubit/course_category_cubit.dart';
import 'package:loginpage/features/home/ui/widgets/course_card.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/fluttertoast.dart';
import '../../../cart/logic/cubit/cart_cubit.dart';
import '../../../course_details/logic/cubit/course_details_cubit.dart';
import '../../../kid_profile/ui/widgets/book_mark_manager.dart';
import 'nav_bar_visibility_controller.dart';

class EducationCategory extends StatefulWidget {
  final String category;

  const EducationCategory({super.key, required this.category});

  @override
  State<EducationCategory> createState() => _EducationCategoryState();
}

class _EducationCategoryState extends State<EducationCategory> {
  late CourseCategoryCubit courseCategoryCubit;
  late CartCubit cartCubit;
  late CourseDetailsCubit courseDetailsCubit;

  @override
  void initState() {
    super.initState();
    NavBarVisibilityController.showNavBar();
    courseCategoryCubit = getIt<CourseCategoryCubit>();
    cartCubit = getIt<CartCubit>();
    courseDetailsCubit = getIt<CourseDetailsCubit>();

    Future.microtask(() {
      courseCategoryCubit.emitGetCourseByCategory(widget.category);
    });

  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: courseCategoryCubit,
        ),
        BlocProvider.value(
          value: courseDetailsCubit,
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Education",
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocProvider.value(
          value: cartCubit,
          child: BlocListener<CartCubit, CartState>(
            listener: (context, state) {
              if (state is AddCartSuccess) {
                showCustomToast(context, "Course added to cart!",
                    isSuccess: true);
              } else if (state is AddCartFailure) {
                showCustomToast(context, "Course already in cart or purchased!",
                    isSuccess: false);
              }
            },
            child: BlocBuilder<CourseCategoryCubit, CourseCategoryState>(
              builder: (context, state) {
                if (state is CourseCategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetCourseByCategorySuccess) {
                  return ListView.builder(
                    itemCount: state.courses.length,
                    itemBuilder: (context, index) {
                      final course = state.courses[index];
                      return GestureDetector(
                        onTap: () {
                          if (course.id != null && course.id!.isNotEmpty) {
                            context.push(
                              Routes.courseDetails,
                              extra: {
                                '_id': course.id,
                                'courseDetailsCubit': courseDetailsCubit,
                              },
                            );
                          }
                        },
                        child: CourseCard(
                          courseImage: course.courseImage,
                          courseName: course.courseName ?? "Unknown Course",
                          instructor: course.instructor?['Name'],
                          description: course.description ?? "",
                          price: course.price ?? 0,
                          availability: course.availability ?? "unavailable",
                          id: course.id,
                          fromCartPage: false,
                          onBookmark: (courseData) async {
                            await BookmarkManager.toggleBookmark(courseData);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      BookmarkManager.isCourseBookmarked(
                                              courseData['id'])
                                          ? 'Added to bookmarks ✓'
                                          : 'Removed from bookmarks ✗'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                } else if (state is GetCourseByCategoryFailure) {
                  if (state.error.contains("No courses available")) {
                    return const Center(
                      child: Text(
                        "No courses available",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Error: //${state.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                }
                return const Center(child: Text("No courses available"));
              },
            ),
          ),
        ),
      ),
    );
  }
}
