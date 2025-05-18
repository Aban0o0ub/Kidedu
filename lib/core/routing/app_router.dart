import 'package:go_router/go_router.dart';
import '../../features/add_course/ui/views/add_course_page.dart';
import '../../features/cart/ui/views/cart.dart';
import '../../features/course_details/ui/views/course_details.dart';
import '../../features/home/ui/views/home_page.dart';
import '../../features/home/ui/views/my_courses.dart';
import '../../features/instructor_profile/ui/views/instructor_profile_page.dart';
import '../../features/kid_profile/ui/views/achievments.dart';
import '../../features/kid_profile/ui/views/edit_profile.dart';
import '../../features/kid_profile/ui/views/settings.dart';
import '../../features/lesson/ui/views/add_lesson.dart';
import '../../features/login/ui/views/login_page.dart';
import '../../features/onBoarding/ui/welcome_page.dart';
import '../../features/payment/ui/views/checkout_courses.dart';
import '../../features/payment/ui/views/payment_page.dart';
import '../../features/sign_up/ui/views/auth_instructor.dart';
import '../../features/sign_up/ui/views/auth_kid.dart';
import '../../features/sign_up/ui/views/role_page.dart';
import '../widgets/privacy_policy.dart';
import '../widgets/terms_conditions.dart';
import 'routes.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.welcomePage,
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: Routes.roleSelectionPage,
      builder: (context, state) => const RoleSelectionPage(),
    ),
    GoRoute(
      path: Routes.authKidPage,
      builder: (context, state) => const AuthKid(),
    ),
    GoRoute(
      path: Routes.authInstructorPage,
      builder: (context, state) => const AuthInstructor(),
    ),
    GoRoute(
      path: Routes.homePage,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: Routes.instructorProfilePage,
      builder: (context, state) => const InstructorProfilePage(),
    ),
    GoRoute(
      path: Routes.addCoursePage,
      builder: (context, state) => const AddCoursePage(),
    ),
    GoRoute(
      path: Routes.loginPage,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.policyPage,
      builder: (context, state) => const PolicyPage(),
    ),
    GoRoute(
      path: Routes.conditionsPage,
      builder: (context, state) => const ConditionsPage(),
    ),
    GoRoute(
      path: Routes.editProfilePage,
      builder: (context, state) => const EditProfile(),
    ),
    GoRoute(
      path: Routes.achievementPage,
      builder: (context, state) => const AchievmentPage(),
    ),
    GoRoute(
      path: Routes.settingsPage,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: Routes.courseDetails,
      builder: (context, state) => CourseDetails(),
    ),
    GoRoute(
      path: Routes.paymentScreen,
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: Routes.paymentDetailsView,
      builder: (context, state) => const PaymentDetailsView(),
    ),
    GoRoute(
      path: Routes.cartPage,
      builder: (context, state) => const Cart(),
    ),
    GoRoute(
      path: Routes.myCourses,
      builder: (context, state) => const MyCourses(),
    ),
    GoRoute(
      path: Routes.addLessonPage,
      builder: (context, state) => const AddLessonPage(),
    ),
  ],
);
