import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/instructor_profile/logic/cubit/instructor_profile_cubit.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/profile_body.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../logic/cubit/my_courses_cubit.dart';
import '../widgets/profile_header.dart';

class InstructorProfilePage extends StatefulWidget {
  const InstructorProfilePage({super.key});

  @override
  State<InstructorProfilePage> createState() => _InstructorProfilePage();
}

class _InstructorProfilePage extends State<InstructorProfilePage> {
  late InstructorProfileCubit instructorProfileCubit;
  late MyCoursesCubit myCoursesCubit;
  @override
  void initState() {
    super.initState();
    instructorProfileCubit = getIt<InstructorProfileCubit>();
    instructorProfileCubit.emitGetInstructorProfile();

    myCoursesCubit = getIt<MyCoursesCubit>();
    myCoursesCubit.emitGetMyCourses();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: instructorProfileCubit),
        BlocProvider.value(value: myCoursesCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  ProfileHeader(),
                  ProfileBody(),
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
