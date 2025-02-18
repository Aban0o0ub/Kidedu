import 'package:flutter/material.dart';

import '../../../../core/widgets/arrow_back.dart';
import '../widgets/achievement_progress.dart';
import '../widgets/trophy.dart';

class AchievmentPage extends StatefulWidget {
  const AchievmentPage({super.key});

  @override
  _AchievementPage createState() => _AchievementPage();
}

class _AchievementPage extends State<AchievmentPage> {
   PageController _pageController = PageController(viewportFraction: 0.6);
  int _currentIndex = 0;
  double userPoints = 1200;

  final List<Map<String, dynamic>> trophies = [
    {'title': 'Bronze Trophy', 'points': 1000, 'image': 'assets/images/bronzecup.jpg'},
    {'title': 'Silver Trophy', 'points': 3000, 'image': 'assets/images/silvercup.jpg'},
    {'title': 'Gold Trophy', 'points': 5000, 'image': 'assets/images/goldencup.jpg'},
  ];
  @override
  void initState() {
    super.initState();
    int initialPage = trophies.length ~/ 2;
    _currentIndex = initialPage;
    _pageController = PageController(viewportFraction: 0.6, initialPage: initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: ArrowBack(),
            ),
          ),
          SizedBox(height:20 ,),
          SizedBox(
            height: 250,
            child: PageView.builder(
              controller: _pageController,
              itemCount: trophies.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                double scale = index == _currentIndex ? 1.0 : 0.6;
                return Transform.scale(
                  scale: scale,
                  child: TrophyWidget(trophy: trophies[index]),
                );
              },
            ),
          ),
                    SizedBox(height:20 ,),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Your Achievement", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF02457A))),
                SizedBox(height: 20),
                AchievementProgress(userPoints: userPoints, trophies: trophies), // الشريط الجديد
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("How to get points?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF02457A))),
                SizedBox(height: 5),
                Text("1. Complete a course and get 20 points", style: TextStyle(fontSize: 16, color: Color(0xFF02457A))),
                Text("2. Attend 10 offline sessions and get 50 points", style: TextStyle(fontSize: 16, color: Color(0xFF02457A))),
                Text("3. Complete 5 courses under same category and get 100 points", style: TextStyle(fontSize: 16, color: Color(0xFF02457A))),
                Text("4. Leave a review for a completed course and get 20 points", style: TextStyle(fontSize: 16, color: Color(0xFF02457A))),
                Text("5. Watch videos daily for a week and get 70 points", style: TextStyle(fontSize: 16, color: Color(0xFF02457A))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}








