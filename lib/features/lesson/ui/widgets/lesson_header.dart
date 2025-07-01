// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../logic/cubit/lesson_cubit.dart';

// class LessonHeader extends StatelessWidget {
//   final int selectedLessonIndex;
  
//   const LessonHeader({
//     super.key,
//     required this.selectedLessonIndex,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20, left: 80),
//       child: Row(
//         children: [
//           const ImageIcon(
//             AssetImage("assets/images/Group 583.png"),
//             color: Color(0xff02457A),
//           ),
//           const SizedBox(width: 10),
//           BlocBuilder<LessonCubit, LessonState>(
//             builder: (context, state) {
//               if (state is GetLessonSuccess && state.response.lessons.isNotEmpty) {
//                 return Text(
//                   "Lesson: ${state.response.lessons[selectedLessonIndex].name}",
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xff02457A),
//                   ),
//                 );
//               }
//               return const Text(
//                 "Loading Lesson...",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xff02457A),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }