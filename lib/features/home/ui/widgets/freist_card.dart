// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class FirstCard extends StatelessWidget {
//   const FirstCard({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 195,
//       width: 352,
//       decoration: BoxDecoration(
//         color: Colors.white, // Add background color if needed
//         borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded corners
//         border: Border.all(
//           color: Color(0XFF02457A), // Border color
//           width: 2, // Optional: Adjust border width
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1), // Light shadow color
//             spreadRadius: 2,
//             blurRadius: 10,
//             offset: Offset(0, 5), // Shadow position
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Image.asset(
//               "assets/images/blackfriday.jpg"),
//           Text(
//             textAlign: TextAlign.center,
//             "Save up to \n50% !",
//             style: TextStyle(
//               fontSize: 28.sp,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF02457A),
//               letterSpacing: 1,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstCard extends StatelessWidget {
  const FirstCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195.h, // استخدام screenutil لجعل الارتفاع متجاوبًا
      width: 352.w,  // استخدام screenutil لجعل العرض متجاوبًا
      decoration: BoxDecoration(
        color: Colors.white, // لون الخلفية
        borderRadius: BorderRadius.circular(20.r), // جعل الزوايا دائرية باستخدام ScreenUtil
        border: Border.all(
          color: const Color(0XFF02457A), // لون الإطار
          width: 2, // سمك الإطار
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // ظل خفيف
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5), // موضع الظل
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r), // تنعيم الحواف العلوية
                bottomLeft: Radius.circular(18.r),
              ),
              child: Image.asset(
                "assets/images/blackfriday.jpg",
                fit: BoxFit.cover, // يجعل الصورة تملأ المساحة المحددة
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              "Save up to \n50% !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp, // تصغير الخط قليلًا ليكون متناسقًا
                fontWeight: FontWeight.bold,
                color: const Color(0xFF02457A),
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
