import 'package:flutter/material.dart';
import 'package:loginpage/views/login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController nextpage = PageController();
  int pagenumber = 0;

  Widget dotpageview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: i == pagenumber ? 26 : 9,
          height: 9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: i == pagenumber
                ? const Color(0xFF1877F2)
                : const Color(0xFF9D9D9D),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: nextpage,
        itemCount: 3,
        onPageChanged: (value) {
          setState(() {
            pagenumber = value;
          });
        },
        itemBuilder: (context, index) {
          return Transform.scale(
            scale: index == pagenumber ? 1.0 : 0.9,
            child: Stack(
              children: [
                Column(
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
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 150),
                    child: dotpageview(),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 25,
                  child: InkWell(
                    onTap: () {
                      if (index < 2) {
                        nextpage.animateToPage(
                          index + 1,
                          duration: const Duration(milliseconds: 450),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 150,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
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
                      child: Center(
                        child: Text(
                          index < 2 ? "Next" : "Get Start",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
