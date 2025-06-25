import 'package:flutter/material.dart';
import 'package:loginpage/features/add_course/ui/widgets/header_image.dart';
import '../../../../core/widgets/arrow_back.dart';

class CourseHeaderSection extends StatelessWidget {
  const CourseHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const HeaderImage(),
        const Positioned(
          top: 20,
          left: 10,
          child: ArrowBack(),
        ),
        Positioned(
          top: 40,
          right: 10,
          child: Row(
            children: [
              InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.share,
                  size: 24,
                  color: Color(0xFF02457A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}