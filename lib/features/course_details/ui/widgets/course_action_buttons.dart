import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import '../../../login/logic/cubit/my_cubit.dart';
import '../../../../core/routing/routes.dart';

class CourseActionButtons extends StatelessWidget {
  final VoidCallback onUpdateCourse;
  final VoidCallback onDeleteCourse;
  
  const CourseActionButtons({
    super.key,
    required this.onUpdateCourse,
    required this.onDeleteCourse,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleCubit, String?>(
      builder: (context, userRole) {
        if (userRole == 'instructor') {
          // Show Update and Delete buttons for instructor
          return Column(
            children: [
              CustomButton(
                onPressed: onUpdateCourse,
                text: "Update Course",
                width: 384,
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 400,
                height: 55,
                child: ElevatedButton(
                  onPressed: onDeleteCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Delete Course",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (userRole == 'kid') {
          // Show Book Now button for kid
          return CustomButton(
            onPressed: () {
              context.push(Routes.paymentScreen);
            },
            text: "Book Now",
            width: 384,
          );
        }
        // Default fallback (shouldn't happen if role is properly set)
        return CustomButton(
          onPressed: () {},
          text: "Book Now",
          width: 384,
        );
      },
    );
  }
}