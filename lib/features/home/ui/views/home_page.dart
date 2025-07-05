import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/search/ui/views/search.dart';
import 'package:loginpage/features/home/ui/widgets/home.dart';
import 'package:provider/provider.dart';
import '../../../cart/logic/cubit/cart_cubit.dart';
import '../../../cart/ui/views/cart.dart';
import '../../../kid_profile/ui/views/kid_profile_page.dart';
import '../../../kid_profile/ui/widgets/notification_helper.dart';
import '../../../sign_up/data/models/kid.dart';
import '../widgets/nav_bar_visibility_controller.dart';
import 'my_courses.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static List<String> backgroundImages = [
    "assets/images/yellow.jpg",
    "assets/images/pink.jpg",
    "assets/images/orange.jpg",
    "assets/images/green.jpg",
    "assets/images/babyblue.jpg"
  ];

  static List<String> iconImages = [
    "assets/images/education.jpg",
    "assets/images/skills.jpg",
    "assets/images/sports.jpg",
    "assets/images/Games.jpg",
    "assets/images/arts.jpg"
  ];

  static List<String> courseTitles = [
    "Education",
    "Skills",
    "Sports",
    "Games",
    "Arts"
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class TabControllerHelper {
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(2);
  
  // للتأكد من أن التطبيق دائماً يرجع للـ Home tab عند بداية أي navigation
  static void resetToHomeTab() {
    selectedIndexNotifier.value = 2;
  }
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 2;
  late List<Widget> _screens;
  @override
  void dispose() {
    TabControllerHelper.selectedIndexNotifier.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (!mounted) return;
    setState(() {
      selectedIndex = TabControllerHelper.selectedIndexNotifier.value;
      if (selectedIndex == 4) {
        context.read<CartCubit>().emitGetCart();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _showWelcomeNotificationOnLogin();
    
    // تعيين قيمة default للـ tab لو مفيش قيمة محددة
    if (TabControllerHelper.selectedIndexNotifier.value == 2) {
      // لو القيمة الحالية هي الـ default (2)، خليها زي ما هي
      // لكن لو مختلفة، سيبها
    }
    
    _screens = [
      KidProfilePage(kid: KidData()),
      SearchPage(),
      Home(
        courseTitles: HomePage.courseTitles,
        backgroundImages: HomePage.backgroundImages,
        iconImages: HomePage.iconImages,
        kid: KidData(),
      ),
      MyCourses(),
      Cart(),
    ];
    TabControllerHelper.selectedIndexNotifier.addListener(_onTabChanged);
  }

  Future<void> _showWelcomeNotificationOnLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    await NotificationHelper.showWelcomeNotification();

    await Future.delayed(const Duration(seconds: 2));
    await NotificationHelper.showKeepLearningNotification();
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final tabParam = GoRouterState.of(context).uri.queryParameters['tab'];
    if (tabParam != null) {
      final tabIndex = int.tryParse(tabParam);
      if (tabIndex != null && tabIndex != TabControllerHelper.selectedIndexNotifier.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            TabControllerHelper.selectedIndexNotifier.value = tabIndex;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selectedIndex == 2, // يمكن الخروج فقط لو كان في الـ Home tab
      onPopInvoked: (didPop) {
        if (!didPop && selectedIndex != 2) {
          // لو مش في الـ Home tab، ارجع للـ Home tab
          TabControllerHelper.selectedIndexNotifier.value = 2;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false, // Keep navigation bar fixed when keyboard appears
        body: Stack(
          children: [
            IndexedStack(
              index: selectedIndex,
              children: _screens,
            ),
          ValueListenableBuilder<bool>(
            valueListenable: NavBarVisibilityController.isNavBarVisible,
            builder: (context, isVisible, child) {
              return isVisible
                  ? ValueListenableBuilder<int>(
                      valueListenable:
                          TabControllerHelper.selectedIndexNotifier,
                      builder: (context, currentIndex, _) {
                        // selectedIndex = currentIndex;
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: ConvexAppBar(
                            key: ValueKey(currentIndex),
                            backgroundColor: const Color(0xff02457A),
                            initialActiveIndex: currentIndex,
                            color: Colors.white,
                            height: 55,
                            style: TabStyle.reactCircle,
                            items: const [
                              TabItem(icon: Icons.person),
                              TabItem(icon: Icons.search),
                              TabItem(icon: Icons.home),
                              TabItem(icon: Icons.ondemand_video_rounded),
                              TabItem(icon: Icons.shopping_cart_outlined),
                            ],
                            onTap: (index) {
                              TabControllerHelper.selectedIndexNotifier.value =
                                  index;
                            },
                          ),
                        );
                      },
                    )
                  : const SizedBox.shrink();
            },
          )
        ],
      ),
      ),
    );
  }
}
