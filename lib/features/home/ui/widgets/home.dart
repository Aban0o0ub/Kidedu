import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/home/ui/widgets/ads_part.dart';
import 'package:loginpage/features/home/ui/widgets/categories_item.dart';
import 'package:loginpage/features/home/ui/widgets/home_appbar.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/course_box.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';
import '../../../../core/injection/injection.dart';
import '../../../kid_profile/logic/cubit/kid_profile_cubit.dart';
import 'arts_category.dart';
import 'education_category.dart';
import 'games_category.dart';
import 'skills_category.dart';
import 'sports_category.dart';

class Home extends StatefulWidget {
  Home({
    super.key,
    required this.courseTitles,
    required this.backgroundImages,
    required this.iconImages,
  });

  final List<String> courseTitles;
  final List<String> backgroundImages;
  final List<String> iconImages;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final List<Widget> categoryPages = [
  final Map<String, Widget Function(String)> categoryPages = {
    "Education": (category) => EducationCategory(category: category),
    "Skills": (category) => SkillsCategory(category: category),
    "Sports": (category) => SportsCategory(category: category),
    "Games": (category) => GamesCategory(category: category),
    "Arts": (category) => ArtsCategory(category: category),
  };
  late KidProfileCubit kidProfileCubit;
  @override
  void initState() {
    super.initState();
    kidProfileCubit = getIt<KidProfileCubit>();
    kidProfileCubit.emitGetKidProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: kidProfileCubit,
      child: Scaffold(
        body: Column(
          children: [
            BlocBuilder<KidProfileCubit, KidProfileState>(
              builder: (context, state) {
                String kidName = "Kid";

                if (state is GetSingleKid &&
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
                    AdsPart(),
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
                    SizedBox(
                      height: 180,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildCourseBox(
                            courseName: "Swimming for toddlers",
                            imagePath: "assets/images/swimming.jpg",
                          ),
                          buildCourseBox(
                            courseName: "Sciences",
                            imagePath: "assets/images/science.jpg",
                          ),
                          buildCourseBox(
                            courseName: "Mathematics",
                            imagePath: "assets/images/maths.jpg",
                          ),
                        ],
                      ),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      categoryPages[widget.courseTitles[index]]!(
                                          widget.courseTitles[index]),
                                ),
                              );
                            },
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
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            buildHorizontalReviewCard(
                              name: "Ahmed Mostafa",
                              review: "Amazing instructor! Highly recommended.",
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
