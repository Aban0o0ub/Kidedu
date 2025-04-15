import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/onBoarding/ui/circle_border.dart';
import '../../../core/routing/routes.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController pageController = PageController();
  int pageNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: 3,
                  onPageChanged: (value) {
                    setState(() {
                      pageNumber = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 30),
                        Image.asset(
                          index == 0
                              ? "assets/images/FirstWP.jpeg"
                              : index == 1
                                  ? "assets/images/SecondWP.jpeg"
                                  : "assets/images/ThirdWP.jpeg",
                        ),
                        const SizedBox(height: 20),
                        Text(
                          index == 0
                              ? 'Inspiring Courses'
                              : index == 1
                                  ? 'Best Instructors'
                                  : 'Track your progress',
                          style: const TextStyle(
                            color: Color(0xFF02457A),
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            index == 0
                                ? 'Our courses aim to inspire and educate, offering a variety of content that meets your needs. Available online or offline, we simplify complex topics through engaging educational courses and provide hands-on activities for skill development.'
                                : index == 1
                                    ? 'Our instructors are industry experts, bringing you top-notch knowledge and experience. Join our community and gain insights from the best professionals in town and online!'
                                    : 'Monitor your learning journey with ease! Track your progress, celebrate your achievements, and earn points and rewards as you reach your goals.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF02457A),
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (index == 2) const SizedBox(height: 20),
                        if (index == 2)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Text(
                              "Ready? Let's take your knowledge to the next level!...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF02457A),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(100, 100),
                    painter: CircleBorderPainter(pageNumber),
                  ),
                  InkWell(
                    onTap: () {
                      if (pageNumber < 2) {
                        pageController.animateToPage(
                          pageNumber + 1,
                          duration: const Duration(milliseconds: 450),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.push(Routes.roleSelectionPage);
                      }
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1877F2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        pageNumber < 2
                            ? Icons.arrow_forward_ios_rounded
                            : Icons.check_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
