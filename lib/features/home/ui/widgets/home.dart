import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/home/ui/widgets/ads_part.dart';
import 'package:loginpage/features/home/ui/widgets/categories_item.dart';
import 'package:loginpage/features/home/ui/widgets/home_appbar.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/course_box.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../course_details/logic/cubit/course_details_cubit.dart';
import '../../../kid_profile/logic/cubit/kid_profile_cubit.dart';
import '../../../reviews/logic/cubit/reviews_cubit.dart';
import '../../../sign_up/data/models/kid.dart';
import '../../logic/cubit/course_category_cubit.dart';
import '../../logic/cubit/discounted_courses_cubit.dart';
import 'arts_category.dart';
import 'education_category.dart';
import 'games_category.dart';
import 'nav_bar_visibility_controller.dart';
import 'skills_category.dart';
import 'sports_category.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.courseTitles,
    required this.backgroundImages,
    required this.iconImages,
    required this.kid,
    this.onCategorySelected,
  });

  final List<String> courseTitles;
  final List<String> backgroundImages;
  final List<String> iconImages;
  final KidData kid;
  final Function(String)? onCategorySelected;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, Widget Function(String)> categoryPages = {
    "Education": (category) => EducationCategory(category: category),
    "Skills": (category) => SkillsCategory(category: category),
    "Sports": (category) => SportsCategory(category: category),
    "Games": (category) => GamesCategory(category: category),
    "Arts": (category) => ArtsCategory(category: category),
  };

  late CourseCategoryCubit courseCategoryCubit;
  late ReviewsCubit reviewsCubit;
  late DiscountedCoursesCubit discountedCoursesCubit;
  late CourseDetailsCubit courseDetailsCubit;

  @override
  void initState() {
    super.initState();
    NavBarVisibilityController.showNavBar();
    courseCategoryCubit = getIt<CourseCategoryCubit>();
    reviewsCubit = getIt<ReviewsCubit>();
    discountedCoursesCubit = getIt<DiscountedCoursesCubit>();
    courseDetailsCubit = getIt<CourseDetailsCubit>();

    discountedCoursesCubit.emitGetDiscountedCourses();
    courseCategoryCubit.emitGetTrendingCourses();
    reviewsCubit.emitGetRecentReviews();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // تأكد من أن KidProfileCubit يحمل البيانات
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<KidProfileCubit>().state is KidProfileInitial) {
        context.read<KidProfileCubit>().emitGetKidProfile();
      }
    });
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: courseCategoryCubit),
        BlocProvider.value(value: reviewsCubit),
        BlocProvider.value(value: discountedCoursesCubit),
        BlocProvider.value(value: courseDetailsCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            BlocBuilder<KidProfileCubit, KidProfileState>(
              builder: (context, state) {
                String kidName = "Kid";

                if (state is KidProfileSuccess &&
                    state.kid.name != null &&
                    state.kid.name!.isNotEmpty) {
                  kidName = state.kid.name!;
                }

                return HomeAppbar(kidName: kidName);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 38),

                    const DiscountedCoursesCarousel(),
                    const SizedBox(height: 20),

                    // Trending Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Trending".tr(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    BlocBuilder<CourseCategoryCubit, CourseCategoryState>(
                      builder: (context, state) {
                        print('🔥 Current State: $state');
                        if (state is TrendingCoursesLoading) {
                          return SizedBox(
                            height: 180,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          );
                        } else if (state is GetTrendingCourseSuccess) {
                          if (state.courses.isEmpty) {
                            return SizedBox(
                              height: 180,
                              child: Center(
                                child: Text(
                                  "No trending courses available".tr(),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }

                          return SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.courses.length,
                              itemBuilder: (context, index) {
                                final course = state.courses[index];
                                return GestureDetector(
                                  onTap: () {
                                    if (course.id != null &&
                                        course.id!.isNotEmpty) {
                                      context.push(
                                        Routes.courseDetails,
                                        extra: {
                                          '_id': course.id,
                                          'courseDetailsCubit':
                                              courseDetailsCubit,
                                        },
                                      );
                                    }
                                  },
                                  child: buildCourseBox(
                                    courseName:
                                        course.courseName ?? "Unknown Course".tr(),
                                    imagePath: _getFirstValidImage(course.courseImages) != null 
                                        ? _getFullImageUrl(_getFirstValidImage(course.courseImages)!)
                                        : "assets/images/CourseDefaultPhoto.jpeg",
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (state is GetTrendingCourseFailure) {
                          return SizedBox(
                            height: 180,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Theme.of(context).colorScheme.error,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Failed to load trending courses".tr(),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.error,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<CourseCategoryCubit>()
                                          .emitGetTrendingCourses();
                                    },
                                    child: Text("Retry".tr()),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Default empty state
                        return SizedBox(
                          height: 180,
                          child: Center(
                            child: Text(
                              "No trending courses available".tr(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Categories Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Categories".tr(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        padding:
                            const EdgeInsets.only(top: 20, left: 10, right: 10),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: widget.courseTitles.length,
                        itemBuilder: (context, index) {
                          return CategoriesItem(
                            backgroundImage: widget.backgroundImages[index],
                            iconImage: widget.iconImages[index],
                            title: widget.courseTitles[index],
                            onTap: () {
                              NavBarVisibilityController.showNavBar();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => categoryPages[
                                      widget.courseTitles[index]]!(
                                    widget.courseTitles[index],
                                  ),
                                ),
                              );
                            },
                            onPressed: () {},
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Recent Reviews Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Recent Reviews".tr(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: SizedBox(
                        height: 135,
                        child: BlocBuilder<ReviewsCubit, ReviewsState>(
                          builder: (context, state) {
                            if (state is GetReviewsLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              );
                            } else if (state is GetReviewsSuccess) {
                              if (state.reviews.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No reviews available",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }

                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.reviews.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final review = state.reviews[index];
                                  return buildHorizontalReviewCard(
                                    name: review.displayKidName,
                                    review: review.reviewText,
                                    rating: review.rating,
                                    courseName:
                                        "For ${review.displayCourseName}",
                                    instructorName:
                                        review.displayInstructorName,
                                  );
                                },
                              );
                            } else if (state is GetReviewsFailure) {
                              // التحقق من نوع الخطأ - 404 يعني مفيش reviews
                              bool isNoReviews = state.error.contains('404') ||
                                  state.error
                                      .toLowerCase()
                                      .contains('not found');

                              if (isNoReviews) {
                                // عرض رسالة "لا توجد مراجعات" بدل error
                                return SizedBox(
                                  height: 142,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.rate_review_outlined,
                                          color: Theme.of(context).primaryColor,
                                          size: 32,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "No reviews yet",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Be the first to review this course!",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              bool isNetworkError = state.error
                                      .toLowerCase()
                                      .contains('network') ||
                                  state.error
                                      .toLowerCase()
                                      .contains('connection') ||
                                  state.error.toLowerCase().contains('timeout');

                              return SizedBox(
                                height: 142,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isNetworkError
                                            ? Icons.wifi_off
                                            : Icons.error_outline,
                                        color: Colors.red,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        isNetworkError
                                            ? "Check your internet connection"
                                            : "Failed to load reviews",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.red,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<ReviewsCubit>()
                                              .emitGetRecentReviews();
                                        },
                                        child: Text(
                                          "Tap to retry",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).primaryColor,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            // Default state - fallback to hardcoded reviews
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                buildHorizontalReviewCard(
                                  name: "Ahmed Mostafa",
                                  review:
                                      "Amazing instructor! Highly recommended.",
                                  rating: 5,
                                  courseName: "For Mathematics for kids",
                                  instructorName: "Abanoub Atef",
                                ),
                                const SizedBox(width: 10),
                                buildHorizontalReviewCard(
                                  name: "Sara Ali",
                                  review:
                                      "Practical examples and clear explanations!",
                                  rating: 4,
                                  courseName: "For Mathematics for kids",
                                  instructorName: "Abanoub Atef",
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 120),
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
