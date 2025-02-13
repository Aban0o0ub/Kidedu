import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 141.h,
      decoration: const BoxDecoration(
        color: Color(0XFF02457A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20),
            child: Image.asset(
              'assets/images/kid pic (2).png',
              height: 90.h,
              width: 80.w,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome Adam',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )),
                Text('What do you learn to do today?',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 30),
            child: Image.asset("assets/images/notification icon.png"),
          )
        ],
      ),
    );
  }
}
