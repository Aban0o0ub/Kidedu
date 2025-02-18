// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class SecondCard extends StatelessWidget {
//   const SecondCard({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20), // Curved border radius
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20), // Rounded corners
//             border: Border.all(
//               color: Color(0XFF02457A), // Border color
//               width: 2, // Border width
//             )),
//         height: 195,
//         width: 352,
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: CustomPaint(
//                 painter: DiagonalPainter(),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 0.0, top: 0),
//                   child: Image.asset(
//                       height: 182,
//                       width: 180,
//                       "assets/images/32705320-removebg-preview 1.png"),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 10.0),
//                   child: Text(
//                     "Explore\n Now!",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 28.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0XFF02457A),
//                       letterSpacing: 1,
//                     ),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DiagonalPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Color(0xFF02457A) // Blue color
//       ..style = PaintingStyle.fill;

//     final path = Path()
//       ..moveTo(0, size.height) // Bottom-left corner
//       ..lineTo(0, size.height * 0.1) // Halfway up the left side
//       ..lineTo(size.width - 50, size.height) // Bottom-right corner
//       ..close(); // Close the shape

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondCard extends StatelessWidget {
  const SecondCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195.h, // جعل الارتفاع متكيفًا
      width: 352.w, // جعل العرض متكيفًا
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r), // استخدام .r لجعل الزوايا ديناميكية
        border: Border.all(
          color: const Color(0XFF02457A), // لون الحدود
          width: 2.w, // جعل سمك الحدود متكيفًا
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: DiagonalPainter(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.w, top: 0.h),
                child: Image.asset(
                  "assets/images/blackfriday.jpg",
                  height: 182.h, 
                  width: 180.w, 
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Text(
                  "Explore\n Now!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.sp, // استخدام .sp لحجم النصوص
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF02457A),
                    letterSpacing: 1.w, // استخدام .w للتباعد بين الحروف
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

class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF02457A) // اللون الأزرق
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height) // الزاوية السفلى اليسرى
      ..lineTo(0, size.height * 0.1) // الصعود قليلًا
      ..lineTo(size.width * 0.85, size.height) // تحريك النقطة اليمنى لتكون متناسقة
      ..close(); // إغلاق الشكل

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
