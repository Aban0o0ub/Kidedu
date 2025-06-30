import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/core/helper/cache_helper.dart';
import 'package:loginpage/core/networking/web_services.dart';
import 'package:provider/provider.dart';
import 'core/injection/injection.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'features/add_course/logic/cubit/add_course_cubit.dart';
import 'features/cart/logic/cubit/cart_cubit.dart';
import 'features/kid_profile/logic/cubit/kid_profile_cubit.dart';
import 'features/kid_profile/ui/widgets/book_mark_manager.dart';
import 'features/login/data/repo/my_repo.dart';
import 'features/login/logic/cubit/my_cubit.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BookmarkManager.loadBookmarks();
  await CacheHelper.cacheInitialization();
  initGetIt();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {},
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
            create: (_) => LoginRepo(WebServices(createAndSetupDio()))),
      ],
      child: MultiProvider(
        providers: [
          BlocProvider(create: (_) => RoleCubit()),
          BlocProvider<AddCourseCubit>(
            create: (context) => getIt<AddCourseCubit>(),
          ),
          BlocProvider<CartCubit>(
            create: (_) => getIt<CartCubit>()..emitGetCart(),
          ),
          BlocProvider(
            create: (context) => LoginCubit(
              RepositoryProvider.of<LoginRepo>(context),
            ),
          ),
          BlocProvider<KidProfileCubit>(
            create: (_) => getIt<KidProfileCubit>(),
          ),
        ],
        child: const KidEdu(),
      ),
    ),
  );
}

class KidEdu extends StatefulWidget {
  const KidEdu({super.key});

  @override
  State<KidEdu> createState() => _KidEduState();
}

class _KidEduState extends State<KidEdu> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initAppLinks();
  }

  void _initAppLinks() async {
    _appLinks = AppLinks();

    final Uri? initialUri = await _appLinks.getInitialAppLink();
    if (initialUri != null) {
      _handleLink(initialUri);
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleLink(uri);
      },
      onError: (err) {},
    );
  }

  void _handleLink(Uri uri) {
    if (uri.path.contains('reset-password') ||
        uri.toString().contains('reset-password')) {
      final token = uri.queryParameters['token'];
      final role = uri.queryParameters['role'];

      if (mounted) {
        GoRouter.of(context).go(
          Routes.resetPassword,
          extra: {
            'token': token,
            'role': role,
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          theme: ThemeData(
            fontFamily: 'Alegreya',
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
        // return MaterialApp(
        //   theme: ThemeData(
        //     fontFamily: 'Alegreya',
        //   ),
        //   debugShowCheckedModeBanner: false,
        //   home: const ResetPasswordPage(),
        // );
      },
    );
  }
}
