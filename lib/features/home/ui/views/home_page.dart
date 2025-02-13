import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/home.dart';
import '../widgets/test.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static List<String> backgroundImages = [
    "assets/images/Rectangle 695.png",
    "assets/images/Rectangle 703.png",
    "assets/images/Rectangle 700.png",
    "assets/images/Rectangle 701.png",
    "assets/images/Rectangle 702.png"
  ];

  static List<String> iconImages = [
    "assets/images/learning_13717613 1.png",
    "assets/images/skills_6171936 1.png",
    "assets/images/sports_3311579 1.png",
    "assets/images/puzzle_8317697 1.png",
    "assets/images/paint-brush_4645388 1.png"
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
    const Test1(),
    const Test2(),
    home(
        courseTitles: HomePage.courseTitles,
        backgroundImages: HomePage.backgroundImages,
        iconImages: HomePage.iconImages),
    const Test3(),
    const Test4(),
  ];
}
