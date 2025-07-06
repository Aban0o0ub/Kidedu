import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/injection/injection.dart';
import '../../../core/widgets/arrow_back.dart';
import '../../kid_profile/ui/widgets/achievement_progress.dart';
import '../../kid_profile/ui/widgets/trophy.dart';
import '../logic/cubit/achievment_cubit.dart';

class AchievmentPage extends StatefulWidget {
  const AchievmentPage({super.key});

  @override
  State<AchievmentPage> createState() => _AchievmentPageState();
}

class _AchievmentPageState extends State<AchievmentPage> {
  late PageController _pageController;
  late AchievmentCubit achievmentCubit;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> trophies = [
    {
      'title': 'Bronze Trophy',
      'points': 1000,
      'image': 'assets/images/bronzecup.jpg',
      'level': 'Beginner'
    },
    {
      'title': 'Silver Trophy',
      'points': 3000,
      'image': 'assets/images/silvercup.jpg',
      'level': 'Intermediate'
    },
    {
      'title': 'Gold Trophy',
      'points': 6000,
      'image': 'assets/images/goldencup.jpg',
      'level': 'Advanced'
    },
  ];

  @override
  void initState() {
    super.initState();
    int initialPage = trophies.length ~/ 2;
    _currentIndex = initialPage;
    _pageController = PageController(
      viewportFraction: 0.7,
      initialPage: initialPage,
    );
    // context.read<AchievmentCubit>().emitGetMyPoints();
    achievmentCubit = getIt<AchievmentCubit>();
    achievmentCubit.emitGetMyPoints();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
   // final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider.value(
      value: achievmentCubit,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: BlocBuilder<AchievmentCubit, AchievmentState>(
            builder: (context, state) {
              if (state is GetMyPointsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF02457A),
                  ),
                );
              }

              if (state is GetMyPointsFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load points',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.error,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AchievmentCubit>().emitGetMyPoints();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF02457A),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              double userPoints = 0;
              String userLevel = 'Starter';
              if (state is GetMyPointsSuccess) {
                userPoints = state.response.totalPoints.toDouble();
                userLevel = state.response.level;
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const ArrowBack(),
                          const Spacer(),
                          Text(
                            'My Achievements',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF02457A),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 40), // Balance for arrow
                        ],
                      ),
                    ),

                    // Current Points Display
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF02457A), Color(0xFF0369A1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF02457A).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Points',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${userPoints.toInt()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Current Level',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                userLevel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Trophy Section
                    SizedBox(
                      height: screenHeight * 0.3,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: trophies.length,
                        onPageChanged: (index) {
                          setState(() => _currentIndex = index);
                        },
                        itemBuilder: (context, index) {
                          bool isActive = index == _currentIndex;
                          bool isUnlocked =
                              userPoints >= trophies[index]['points'];

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: isActive ? 0 : 20,
                            ),
                            child: TrophyWidget(
                              trophy: trophies[index],
                              isActive: isActive,
                              isUnlocked: isUnlocked,
                            ),
                          );
                        },
                      ),
                    ),

                    // Trophy Info
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            trophies[_currentIndex]['title'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF02457A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Required: ${trophies[_currentIndex]['points']} points',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            userPoints >= trophies[_currentIndex]['points']
                                ? '🎉 Unlocked!'
                                : 'Keep going to unlock!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: userPoints >=
                                      trophies[_currentIndex]['points']
                                  ? Colors.green[600]
                                  : Colors.orange[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Progress Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AchievementProgress(
                        userPoints: userPoints,
                        trophies: trophies,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Points Breakdown (if available)
                    if (state is GetMyPointsSuccess)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Points Breakdown',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF02457A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildBreakdownItem(
                              'Completed Courses',
                              state.response.pointsBreakdown.completedCourses,
                              Icons.book,
                            ),
                            _buildBreakdownItem(
                              'Attended Sessions',
                              state.response.pointsBreakdown.attendedSessions,
                              Icons.event,
                            ),
                            _buildBreakdownItem(
                              'Category Achievements',
                              state.response.pointsBreakdown
                                  .categoryAchievements,
                              Icons.category,
                            ),
                            _buildBreakdownItem(
                              'Given Reviews',
                              state.response.pointsBreakdown.givenReviews,
                              Icons.rate_review,
                            ),
                            // _buildBreakdownItem(
                            //   'Watched Videos',
                            //   state.response.pointsBreakdown.watchedVideos,
                            //   Icons.play_circle,
                            // ),
                            // _buildBreakdownItem(
                            //   'Other Activities',
                            //   state.response.pointsBreakdown.otherActivities,
                            //   Icons.star,
                            // ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // How to get points
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'How to get points?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF02457A),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPointsRule(
                            '🎓 Complete a course',
                            '200 points',
                            Colors.blue,
                          ),
                          _buildPointsRule(
                            '👥 Attend 5 offline sessions',
                            '250 points',
                            Colors.green,
                          ),
                          _buildPointsRule(
                            '🏆 Complete 5 courses in same category',
                            '500 points',
                            Colors.orange,
                          ),
                          _buildPointsRule(
                            '⭐ Leave a course review',
                            '25 points',
                            Colors.purple,
                          ),
                          // _buildPointsRule(
                          //   '📺 Watch videos daily for a week',
                          //   '250 points',
                          //   Colors.red,
                          // ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownItem(String title, int count, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF02457A),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF02457A),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF02457A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF02457A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsRule(String rule, String points, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              rule,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF02457A),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              points,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
