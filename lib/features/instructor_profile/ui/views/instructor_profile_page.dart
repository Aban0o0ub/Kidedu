import 'package:flutter/material.dart';
import 'package:loginpage/features/add_course/ui/views/add_course_page.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/profile_body.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';

class InstructorProfilePage extends StatelessWidget {
  const InstructorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                //ProfileHeader(),
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
    );
  }
}
