import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import '../../../../core/injection/injection.dart';
import '../../../add_course/data/models/Course_Model.dart';
import '../../../home/logic/cubit/course_category_cubit.dart';
import '../../../login/logic/cubit/my_cubit.dart';
import '../../../../core/routing/routes.dart';

class CourseActionButtons extends StatefulWidget {
  final VoidCallback onUpdateCourse;
  final VoidCallback onDeleteCourse;
  final String courseId;
  
 
  const CourseActionButtons({
    super.key,
    required this.onUpdateCourse,
    required this.onDeleteCourse,
    required this.courseId, required CourseData courseData,
    
  });

  @override
  State<CourseActionButtons> createState() => _CourseActionButtonsState();
}

class _CourseActionButtonsState extends State<CourseActionButtons> {
  bool isLoading = true;
  bool isPurchased = false;
  late CourseCategoryCubit courseCategoryCubit;
   CourseData? courseData;
  get onDeleteCourse => null;

  @override
  void initState() {
    super.initState();
    courseCategoryCubit = getIt<CourseCategoryCubit>();
    _checkPurchaseStatus();
  }

  Future<void> _checkPurchaseStatus() async {
  try {
    // استخدم الدالة الجديدة التي ترجع البيانات
    final List<CourseData> purchasedCourses = await courseCategoryCubit.getKidCoursesData();
    
    // فحص إذا كان الكورس الحالي موجود في القائمة
    final isCoursePurchased = purchasedCourses.any((course) =>
      course.id == widget.courseId
    );
    
    if (mounted) {
      setState(() {
        isPurchased = isCoursePurchased;
        isLoading = false;
      });
    }
  } catch (e) {
    print('Error checking purchase status: $e');
    if (mounted) {
      setState(() {
        isPurchased = false;
        isLoading = false;
      });
    }
  }
}



//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RoleCubit, String?>(
//       builder: (context, userRole) {
//         if (userRole == 'instructor') {
//           // Show Update and Delete buttons for instructor
//           return Column(
//             children: [
//               CustomButton(
//                 onPressed: widget.onUpdateCourse,
//                 text: "Update Course",
//                 width: 384,
//               ),
//               const SizedBox(height: 15),
//               SizedBox(
//                 width: 400,
//                 height: 55,
//                 child: ElevatedButton(
//                   onPressed: widget.onDeleteCourse,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 3,
//                   ),
//                   child: const Text(
//                     "Delete Course",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         } else if (userRole == 'kid') {
//           if (isLoading) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFF02457A),
//               ),
//             );
//           }
          
//           if (isPurchased) {
//            return const SizedBox.shrink();
//           } else {
//             return CustomButton(
//               onPressed: () {
//                 context.push(Routes.paymentDetailsView);
//               },
//               text: "Book Now",
//               width: 384,
//             );
//           }
//         }
//         return CustomButton(
//           onPressed: () {},
//           text: "Book Now",
//           width: 384,
//         );
//       },
//     );
//   }
// }

@override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleCubit, String?>(
      builder: (context, userRole) {
        if (userRole == 'instructor') {
          // Show Update and Delete buttons for instructor
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    context.push(Routes.addCoursePage, extra: courseData);
                  },
                  text: "Update Course",
                  width: double.infinity,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: SizedBox(
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
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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