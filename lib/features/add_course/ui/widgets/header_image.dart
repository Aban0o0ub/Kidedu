import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeaderImage extends StatelessWidget {
  const HeaderImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 330,
          width: 430,
          decoration: const BoxDecoration(
            color: Color(0xffB7B7B7),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: const Center(
            child: Image(
              image: AssetImage('assets/images/CourseDefaultPhoto.jpeg'),
            ),
          ),
        ),
      ),
    );
  }
}
