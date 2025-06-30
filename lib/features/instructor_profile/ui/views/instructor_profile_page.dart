// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:loginpage/features/instructor_profile/logic/cubit/instructor_profile_cubit.dart';
// import 'package:loginpage/features/instructor_profile/ui/widgets/profile_body.dart';
// import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
// import '../../../../core/injection/injection.dart';
// import '../../../../core/routing/routes.dart';
// import '../../../login/logic/cubit/my_cubit.dart';
// import '../../../reviews/logic/cubit/reviews_cubit.dart';
// import '../../logic/cubit/my_courses_cubit.dart';
// import '../widgets/profile_header.dart';

// class InstructorProfilePage extends StatefulWidget {
//   final String? instructorId; 
  
//   const InstructorProfilePage({super.key, this.instructorId});
  
//   @override
//   State<InstructorProfilePage> createState() => _InstructorProfilePageState();
// }

// class _InstructorProfilePageState extends State<InstructorProfilePage> {
//   late InstructorProfileCubit instructorProfileCubit;
//   late MyCoursesCubit myCoursesCubit;
//   late ReviewsCubit reviewsCubit;
//   String? instructorId;
  
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
    
//     // جيب الـ ID من الـ arguments
//     final arguments = GoRouterState.of(context).extra as Map<String, dynamic>?;
//     if (arguments != null) {
//       instructorId = arguments['_id'];
//     }

//     instructorProfileCubit = getIt<InstructorProfileCubit>();
//     myCoursesCubit = getIt<MyCoursesCubit>();
//     reviewsCubit = getIt<ReviewsCubit>();

//     if (instructorId != null) {
//       instructorProfileCubit.emitGetOnlyInstructor(instructorId!);
//       myCoursesCubit.emitGetMyCourses();
//       reviewsCubit.emitGetReviewsByInstructor();
//     } else {
//       instructorProfileCubit.emitGetInstructorProfile();
//       myCoursesCubit.emitGetMyCourses();
//       reviewsCubit.emitGetReviewsByInstructor();
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RoleCubit, String?>(
//       builder: (context, role) {
//         final bool isStudent = role == 'student';
//         final bool isInstructor = role == 'instructor';
//         final bool isViewingOwnProfile = widget.instructorId == null && isInstructor;
        
//         return MultiBlocProvider(
//           providers: [
//             BlocProvider.value(value: instructorProfileCubit),
//             BlocProvider.value(value: myCoursesCubit),
//             BlocProvider.value(value: reviewsCubit),
//           ],
//           child: Scaffold(
//             backgroundColor: Colors.white,
//             body: Stack(
//               fit: StackFit.expand,
//               children: [
//                 SingleChildScrollView(
//                   padding: EdgeInsets.only(
//                     bottom: isViewingOwnProfile ? 100 : 20, // مساحة للزرار بس للإنستراكتور
//                   ),
//                   child: Column(
//                     children: [
//                       const ProfileHeader(),
//                       ProfileBody(
//                         showEditButtons: isViewingOwnProfile, // بس الإنستراكتور يشوف أزرار التعديل
//                         isStudentView: isStudent, // عشان نعرف إن ده طالب
//                         isViewingOwnProfile: isViewingOwnProfile, // متغير جديد للتحكم في الـ edit buttons
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 // الزرار ده بس للإنستراكتور اللي بيشوف بروفايله
//                 if (isViewingOwnProfile)
//                   Positioned(
//                     bottom: 20,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: CustomButton(
//                         onPressed: () {
//                           context.push(Routes.addCoursePage).then((_) {
//                             FocusScope.of(context).unfocus();
//                           });
//                         },
//                         text: "Add a new course",
//                         width: 320,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/instructor_profile/logic/cubit/instructor_profile_cubit.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/profile_body.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../reviews/logic/cubit/reviews_cubit.dart';
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
  late ReviewsCubit reviewsCubit;
  // @override
  // void initState() {
  //   super.initState();
  //   instructorProfileCubit = getIt<InstructorProfileCubit>();
  //   instructorProfileCubit.emitGetInstructorProfile();

  //   myCoursesCubit = getIt<MyCoursesCubit>();
  //   myCoursesCubit.emitGetMyCourses();

  //   reviewsCubit = getIt<ReviewsCubit>();
  //   reviewsCubit.emitGetReviewsByInstructor();
  // }
   @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    instructorProfileCubit = getIt<InstructorProfileCubit>();
    myCoursesCubit = getIt<MyCoursesCubit>();
    reviewsCubit = getIt<ReviewsCubit>();

    final args = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (args != null && args['deletedCourseId'] != null) {
      myCoursesCubit.emitGetMyCourses();
    } else {
      myCoursesCubit.emitGetMyCourses();
    }

    instructorProfileCubit.emitGetInstructorProfile();
    reviewsCubit.emitGetReviewsByInstructor();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: instructorProfileCubit),
        BlocProvider.value(value: myCoursesCubit),
        BlocProvider.value(value: reviewsCubit),
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