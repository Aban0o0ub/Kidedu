import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/instructor_profile/logic/cubit/instructor_profile_cubit.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/profile_body.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../widgets/profile_header.dart';

class InstructorProfilePage extends StatefulWidget {
  const InstructorProfilePage({super.key});

  @override
  State<InstructorProfilePage> createState() => _InstructorProfilePage();
}

class _InstructorProfilePage extends State<InstructorProfilePage> {
  late InstructorProfileCubit instructorProfileCubit;
  List<dynamic>? passedCourses;
  List<dynamic>? passedReviews;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    instructorProfileCubit = getIt<InstructorProfileCubit>();

    final args = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final instructorId = args != null ? args['_id'] as String? : null;
    passedCourses = args != null ? args['courses'] as List<dynamic>? : null;
    passedReviews = args != null ? args['reviews'] as List<dynamic>? : null;

    if (instructorId != null && instructorId.isNotEmpty) {
      instructorProfileCubit.emitGetOnlyInstructor(instructorId);
    } else {
      instructorProfileCubit.emitGetInstructorProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: instructorProfileCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  ProfileHeader(),
                  ProfileBody(
                    courses: passedCourses,
                    reviews: passedReviews,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: CustomButton(
                  onPressed: () {
                    context.push(Routes.addCoursePage).then((_) {
                      FocusScope.of(context).unfocus();
                    });
                  },
                  text: "Add a new course",
                  width: 320,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}