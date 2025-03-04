import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/add_course/ui/views/add_course_page.dart';
import 'package:loginpage/features/instructor_profile/logic/cubit/instructor_profile_cubit.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/profile_body.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';

import '../../../../core/injection/injection.dart';
import '../widgets/profile_header.dart';

class InstructorProfilePage extends StatefulWidget {
  const InstructorProfilePage({super.key});

  @override
  State<InstructorProfilePage> createState() => _InstructorProfilePage();
}

class _InstructorProfilePage extends State<InstructorProfilePage> {
  late InstructorProfileCubit instructorProfileCubit;
  @override
  void initState() {
    super.initState();
    instructorProfileCubit = getIt<InstructorProfileCubit>();
    instructorProfileCubit.emitGetInstructorProfile();
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddCoursePage(),
                      ),
                    ).then((_) {
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
