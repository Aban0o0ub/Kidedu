import 'package:flutter/material.dart';
import 'package:loginpage/widgets/arrow_back.dart';
import 'package:loginpage/widgets/upper_stickers_photo.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const UpperStickersPhoto(), // الخلفية العلوية
          const ArrowBack(),
          Column(
            children: [
              const SizedBox(height: 240), // مساحة لترك الصورة العلوية والنصوص
              const Text(
                'Role',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF02457A),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Who are you?',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF02457A),
                ),
              ),
              const SizedBox(height: 20),
              // Container الكبير
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container الصغير الأول
                      Stack(
                        clipBehavior: Clip.none, // لضمان عرض الصورة خارج الحدود
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30),
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD8D8),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Kid',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF02457A),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -9,
                            bottom:
                                0, // لجعل قاعدة الصورة ملامسة لقاعدة الكونتينر الصغير
                            child: Image.asset(
                              'assets/images/kidPhoto.png',
                              height: 170, // تكبير حجم الصورة
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Container الصغير الثاني
                      Stack(
                        clipBehavior: Clip.none, // لضمان عرض الصورة خارج الحدود
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30),
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: const BoxDecoration(
                              color: Color(0xFFABE8EA),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Instructor',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF02457A),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom:
                                15, // لجعل قاعدة الصورة ملامسة لقاعدة الكونتينر الصغير
                            child: Image.asset(
                              'assets/images/InstructorPhoto.png',
                              height: 150, // تكبير حجم الصورة
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
