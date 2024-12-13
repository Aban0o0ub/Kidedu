import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background image
        Container(
          height: MediaQuery.of(context).size.width - 96,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/InstructorProfilePhoto.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 30,
          right: 10,
          child: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.4),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
              color: const Color(0xFF1977F3),
            ),
          ),
        ),
        Positioned(
          top: 30,
          right: 50,
          child: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.4),
            child: IconButton(
              onPressed: () {
                // Action for settings button
              },
              icon: const Icon(Icons.settings),
              color: const Color(0xFF1977F3),
            ),
          ),
        ),
        // Camera icon
        Positioned(
          top: 265,
          right: 10,
          child: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.4),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt_rounded),
              color: const Color(0xFF757575),
            ),
          ),
        ),
      ],
    );
  }
}
