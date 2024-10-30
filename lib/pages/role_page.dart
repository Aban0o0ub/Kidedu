import 'package:flutter/material.dart';
import 'package:loginpage/widgets/upper_stickers_photo.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const UpperStickersPhoto(), // الخلفية
          Positioned(
            top: 40, // تحديد المسافة من أعلى الشاشة
            left: 20, // تحديد المسافة من اليسار
            child: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.black), // رمز السهم
              onPressed: () {
                Navigator.pop(context); // العودة إلى الصفحة السابقة
              },
            ),
          ),
          // المحتوى الرئيسي
          Column(
            children: [
              const SizedBox(height: 240), // مساحة أعلى المحتوى
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
              const SizedBox(height: 35),
              GestureDetector(
                onTap: () {
                  //"Kid"
                },
                child: Stack(
                  // استخدام Stack لعرض الصورة فوق الكونتينر
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.pink[100],
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      height: 100, // تأكد من تحديد ارتفاع الكونتينر
                    ),
                    const Positioned(
                      left: 20, // تعديل المسافة من اليسار
                      top: 10, // جعل الصورة أعلى بقليل
                      child: Text(
                        'Kid',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF02457A),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20, // تعديل المسافة من اليمين
                      top: -20, // تعديل لجعل الصورة فوق الكونتينر
                      child: Image.asset(
                        'assets/images/kidPhoto.png', // صورة الطفل
                        height: 70, // زيادة حجم الصورة
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  //"Instructor"
                },
                child: Stack(
                  // استخدام Stack لعرض الصورة فوق الكونتينر
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      height: 100, // تأكد من تحديد ارتفاع الكونتينر
                    ),
                    const Positioned(
                      left: 20, // تعديل المسافة من اليسار
                      top: 10, // جعل النص أعلى بقليل
                      child: Text(
                        'Instructor',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF02457A),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20, // تعديل المسافة من اليمين
                      top: -20, // تعديل لجعل الصورة فوق الكونتينر
                      child: Image.asset(
                        'assets/images/InstructorPhoto.png',
                        height: 128, // زيادة حجم الصورة
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
