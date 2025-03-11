import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import 'package:loginpage/features/home/logic/cubit/course_category_cubit.dart';
import 'package:loginpage/features/home/ui/widgets/course_card.dart';

import '../../../../core/injection/injection.dart';

class SkillsCategory extends StatefulWidget {
  final String category; 

  const SkillsCategory({super.key, required this.category});

  @override
  State<SkillsCategory> createState() => _SkillsCategoryState();
}

class _SkillsCategoryState extends State<SkillsCategory> {
  late CourseCategoryCubit courseCategoryCubit;

  @override
  void initState() {
    super.initState();
    courseCategoryCubit = getIt<CourseCategoryCubit>();

    Future.microtask(() {
      courseCategoryCubit.emitGetCourseByCategory(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: courseCategoryCubit,
      child: Scaffold(
        body: Column(
          children: [
            ArrowBack(),
            SizedBox(height: 35),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/skills.jpg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Skills",
              style: TextStyle(fontSize: 46, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: BlocBuilder<CourseCategoryCubit, CourseCategoryState>(
                builder: (context, state) {
                  if (state is CourseCategoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetCourseByCategorySuccess) {
                    return ListView.builder(
                      itemCount: state.courses.length,
                      itemBuilder: (context, index) {
                        final course = state.courses[index];
                        return CourseCard(
                          courseImage: course.courseImage,
                          courseName: course.courseName ?? "Unknown Course",
                          instructor: course.instructor?['Name'],
                          description: course.description ?? "",
                          price: course.price ?? 0,
                          availability: course.availability ?? "unavailable",
                        );
                      },
                    );
                  } else if (state is GetCourseByCategoryFailure) {
                    return Center(
                      child: Text("Error: ${state.error}",
                          style: const TextStyle(color: Colors.red)),
                    );
                  }
                  return const Center(child: Text("No courses available."));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
