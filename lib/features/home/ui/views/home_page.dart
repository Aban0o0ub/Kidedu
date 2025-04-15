import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/features/search/ui/search.dart';
import 'package:loginpage/features/home/ui/widgets/home.dart';
import '../../../cart/ui/views/cart.dart';
import '../../../kid_profile/ui/views/kid_profile_page.dart';
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

class _HomePageState extends State<HomePage> {
  int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xff02457A),
        initialActiveIndex: selectedIndex,
        color: Colors.white,
        height: 65,
        style: TabStyle.reactCircle,
        items: const [
          TabItem(icon: Icons.person),
          TabItem(icon: Icons.search),
          TabItem(icon: Icons.home),
          TabItem(icon: Icons.ondemand_video_rounded),
          TabItem(icon: Icons.shopping_cart_outlined),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }

  List<Widget> screens = [
    KidProfilePage(),
    SearchPage(),
    Home(
        courseTitles: HomePage.courseTitles,
        backgroundImages: HomePage.backgroundImages,
        iconImages: HomePage.iconImages),
    MyCourses(),
    Cart(),
  ];
}