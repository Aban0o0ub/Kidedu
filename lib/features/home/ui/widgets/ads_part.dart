// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:loginpage/features/home/ui/widgets/freist_card.dart';
// import 'package:loginpage/features/home/ui/widgets/secound_card.dart';

// class AdsPart extends StatelessWidget {
//   const AdsPart({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: CarouselSlider(
//         options: CarouselOptions(
//             autoPlay: true,
//             enlargeCenterPage: true,
//             aspectRatio: 16 / 9,
//             enableInfiniteScroll: false),
//         items: [const FirstCard(), const SecondCard()].map((card) {
//           return Builder(
//             builder: (BuildContext context) {
//               return card;
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/features/home/ui/widgets/freist_card.dart';
import 'package:loginpage/features/home/ui/widgets/secound_card.dart';

class AdsPart extends StatelessWidget {
  const AdsPart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12), 
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            //aspectRatio: 20 / 12,
            aspectRatio: 18 / 9,
            enableInfiniteScroll: false,
            viewportFraction: 0.9, 
            clipBehavior: Clip.hardEdge,
          ),
          items: [const FirstCard(), const SecondCard()],
        ),
      ),
    );
  }
}

