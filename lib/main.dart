import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
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
import 'core/widgets/app_themes.dart';
import 'features/add_course/logic/cubit/add_course_cubit.dart';
import 'features/cart/logic/cubit/cart_cubit.dart';
import 'features/kid_profile/logic/cubit/kid_profile_cubit.dart';
import 'features/kid_profile/ui/widgets/book_mark_manager.dart';
import 'features/kid_profile/ui/widgets/theme_provider.dart';
import 'features/login/data/repo/my_repo.dart';
import 'features/login/logic/cubit/my_cubit.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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
     EasyLocalization(
       supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
              create: (_) => LoginRepo(WebServices(createAndSetupDio()))),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            BlocProvider(create: (_) {
              final roleCubit = RoleCubit();
              // تحميل الدور المحفوظ عند بدء التطبيق
              roleCubit.loadSavedRole();
              return roleCubit;
            }),
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
              create: (_) => getIt<KidProfileCubit>()..emitGetKidProfile(),
            ),
          ],
          child: const KidEdu(),
        ),
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
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeProvider.isDarkMode 
                ? ThemeMode.dark 
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          );
        },
      );
    },
  );
}
}
