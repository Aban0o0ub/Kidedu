import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/home/ui/widgets/ads_part.dart';
import 'package:loginpage/features/home/ui/widgets/categories_item.dart';
import 'package:loginpage/features/home/ui/widgets/home_appbar.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/course_box.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';
import '../../../../core/injection/injection.dart';
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

  late KidProfileCubit kidProfileCubit;
  late CourseCategoryCubit courseCategoryCubit;
  late ReviewsCubit reviewsCubit;
  late DiscountedCoursesCubit discountedCoursesCubit;

  @override
  void initState() {
    super.initState();
    NavBarVisibilityController.showNavBar();
    kidProfileCubit = getIt<KidProfileCubit>();
    courseCategoryCubit = getIt<CourseCategoryCubit>();
    reviewsCubit = getIt<ReviewsCubit>();
    discountedCoursesCubit = getIt<DiscountedCoursesCubit>();

    kidProfileCubit.emitGetKidProfile();
    
    discountedCoursesCubit.emitGetDiscountedCourses();
    courseCategoryCubit.emitGetTrendingCourses();
    reviewsCubit.emitGetRecentReviews();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: kidProfileCubit),
        BlocProvider.value(value: courseCategoryCubit),
        BlocProvider.value(value: reviewsCubit),
        BlocProvider.value(value: discountedCoursesCubit),
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Trending",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF02457A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    BlocBuilder<CourseCategoryCubit, CourseCategoryState>(
                      builder: (context, state) {
                        print('🔥 Current State: $state');
                        if (state is TrendingCoursesLoading) {
                          return const SizedBox(
                            height: 180,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF02457A),
                              ),
                            ),
                          );
                        } else if (state is GetTrendingCourseSuccess) {
                          if (state.courses.isEmpty) {
                            return const SizedBox(
                              height: 180,
                              child: Center(
                                child: Text(
                                  "No trending courses available",
                                  style: TextStyle(
                                    color: Color(0xFF02457A),
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
                                return buildCourseBox(
                                  courseName:
                                      course.courseName ?? "Unknown Course",
                                  imagePath: (course.courseImage == null ||
                                          course.courseImage!.isEmpty ||
                                          !course.courseImage!
                                              .startsWith("assets/"))
                                      ? "assets/images/CourseDefaultPhoto.jpeg"
                                      : course.courseImage!,
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
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Failed to load trending courses",
                                    style: TextStyle(
                                      color: Colors.red[700],
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF02457A),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Retry"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Default empty state
                        return const SizedBox(
                          height: 180,
                          child: Center(
                            child: Text(
                              "No trending courses available",
                              style: TextStyle(
                                color: Color(0xFF02457A),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Categories Section
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF02457A),
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Recent Reviews",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF02457A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: SizedBox(
                        height: 150,
                        child: BlocBuilder<ReviewsCubit, ReviewsState>(
                          builder: (context, state) {
                            if (state is GetReviewsLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF02457A),
                                ),
                              );
                            } else if (state is GetReviewsSuccess) {
                              if (state.reviews.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "No reviews available",
                                    style: TextStyle(
                                      color: Color(0xFF02457A),
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
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Failed to load reviews",
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<ReviewsCubit>()
                                            .emitGetRecentReviews();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF02457A),
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text("Retry"),
                                    ),
                                  ],
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
