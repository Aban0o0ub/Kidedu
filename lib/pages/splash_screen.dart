// import 'package:flutter/material.dart';
// import 'package:loginpage/widgets/lower_stickers.dart';
// import 'package:loginpage/widgets/upper_stickers_photo.dart';
// import 'dart:async';
// import 'login_page.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   SplashScreenState createState() => SplashScreenState();
// }

// class SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();

//     // Delay 3 seconds, then navigate if widget is still mounted
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginPage()),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           const Align(
//             alignment: Alignment.topCenter,
//             child: UpperStickersPhoto(),
//           ),
//           const Align(
//             alignment: Alignment.bottomCenter,
//             child: LowerStickersPhoto(),
//           ),
//           Center(
//             child: Image.asset(
//               'assets/images/Logo.jpeg',
//               height: 160,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
