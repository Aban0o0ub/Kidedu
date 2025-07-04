import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/instructor_profile/logic/cubit/instructor_profile_cubit.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/profile_body.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../widgets/profile_header.dart';
import '../../logic/cubit/my_courses_cubit.dart';
import '../../../reviews/logic/cubit/reviews_cubit.dart';

class InstructorProfilePage extends StatefulWidget {
  const InstructorProfilePage({super.key});

  @override
  State<InstructorProfilePage> createState() => _InstructorProfilePage();
}

class _InstructorProfilePage extends State<InstructorProfilePage> {
  late InstructorProfileCubit instructorProfileCubit;
  late MyCoursesCubit myCoursesCubit;
  late ReviewsCubit reviewsCubit;
  List<dynamic>? passedCourses;
  List<dynamic>? passedReviews;
  dynamic passedInstructorData;
  bool isViewingFromCourseDetails = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    instructorProfileCubit = getIt<InstructorProfileCubit>();
    myCoursesCubit = getIt<MyCoursesCubit>();
    reviewsCubit = getIt<ReviewsCubit>();

    final args = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final instructorId = args != null ? args['_id'] as String? : null;
    passedCourses = args != null ? args['courses'] as List<dynamic>? : null;
    passedReviews = args != null ? args['reviews'] as List<dynamic>? : null;
    passedInstructorData = args != null ? args['instructorData'] : null;

    isViewingFromCourseDetails = (passedInstructorData != null) || (instructorId != null && instructorId.isNotEmpty);

    if (passedInstructorData != null && passedInstructorData is Map<String, dynamic>) {
      final instructorData = _convertToInstructorData(passedInstructorData);
      instructorProfileCubit.emit(InstructorProfileSuccess(instructorData));
    } else if (instructorId != null && instructorId.isNotEmpty) {
      instructorProfileCubit.emitGetOnlyInstructor(instructorId);
    } else {
      instructorProfileCubit.emitGetInstructorProfile();
      myCoursesCubit.emitGetMyCourses();
      reviewsCubit.emitGetReviewsByInstructor();
    }
  }

  InstructorData _convertToInstructorData(Map<String, dynamic> data) {
    return InstructorData(
      id: data['_id']?.toString(),
      name: data['Name']?.toString(),
      email: data['Email']?.toString(),
      phoneNumber: data['PhoneNumber']?.toString(),
      governorate: data['Governorate']?.toString(),
      bio: data['Bio']?.toString(),
      image: data['Image']?.toString(),
      earnings: data['earnings'] is num ? data['earnings'] : null,
      title: data['title']?.toString(), 
      experience: data['experience']?.toString(), 
    );
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
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  ProfileHeader(showActionIcons: !isViewingFromCourseDetails),
                  ProfileBody(
                    courses: passedCourses,
                    reviews: passedReviews,
                    showEditIcons: !isViewingFromCourseDetails,
                  ),
                ],
              ),
            ),
            if (!isViewingFromCourseDetails)
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