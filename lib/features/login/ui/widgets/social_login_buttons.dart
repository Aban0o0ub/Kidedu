import 'package:flutter/material.dart';
import '../../../sign_up/ui/widgets/icon_button.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Iconbutton(
          assetPath: 'assets/images/Googleicon.webp',
          onPressed: () {},
        ),
        const SizedBox(width: 20),
        Iconbutton(
          assetPath: 'assets/images/facebookicon.png',
          onPressed: () {},
        ),
        const SizedBox(width: 20),
        Iconbutton(
          assetPath: 'assets/images/appstoreicon.png',
          onPressed: () {},
        ),
      ],
    );
  }
}
