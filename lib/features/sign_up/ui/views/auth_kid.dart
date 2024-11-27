import 'package:flutter/material.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import 'package:loginpage/features/sign_up/ui/widgets/kid_auth_body.dart';
import 'package:loginpage/features/sign_up/ui/widgets/upper_stickers_photo.dart';

class AuthKid extends StatefulWidget {
  const AuthKid({super.key});

  @override
  AuthKidState createState() => AuthKidState();
}

class AuthKidState extends State<AuthKid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: const SingleChildScrollView(
          child: Stack(
            children: [
              UpperStickersPhoto(),
              ArrowBack(),
              KidAuthBody(),
            ],
          ),
        ),
      ),
    );
  }
}
