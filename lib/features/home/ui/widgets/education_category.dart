import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import 'package:loginpage/features/home/logic/cubit/course_category_cubit.dart';
import 'package:loginpage/features/home/ui/widgets/course_card.dart';

import '../../../../core/injection/injection.dart';
import '../../../add_course/data/models/add_course.dart';

class EducationCategory extends StatefulWidget {
  const EducationCategory({super.key});
  

  @override
  State<EducationCategory> createState() => _EducationCategoryState();
}

class _EducationCategoryState extends State<EducationCategory> {
  late CourseCategoryCubit courseCategoryCubit;
  CourseModel? course;

  @override
  void initState() {
    super.initState();
    courseCategoryCubit = getIt<CourseCategoryCubit>();

    Future.microtask(() async {
      try {
        // استدعاء الميثود وجلب بيانات الكورس
        course = await courseCategoryCubit.courseDetailsRepo.getCourseByCategory(""); 

        if (course != null && course!.category.isNotEmpty) {
          courseCategoryCubit.emitGetCourseByCategory(course!.category);
          setState(() {});
        }
      } catch (e) {
        print("❌ خطأ أثناء جلب البيانات: $e");
      }
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
                'assets/images/education.jpg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Education",
              style: TextStyle(fontSize: 46, fontWeight: FontWeight.bold),
            ),
            //SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<CourseCategoryCubit, CourseCategoryState>(
                builder: (context, state) {
                  if (state is CourseCategoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetCourseByCategorySuccess) {
                    return CourseCard(
                      //courseImage: state.newCourse.courseImage,
                      courseName: state.newCourse.courseName,
                      //instructor: state.newCourse.instructor,
                      description: state.newCourse.description,
                      price: state.newCourse.price,
                      availability: state.newCourse.availability,
                    );
                  } else if (state is GetCourseByCategoryFailure) {
                    return Center(
                      child: Text("Error: ${state.error}", style: const TextStyle(color: Colors.red)),
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
