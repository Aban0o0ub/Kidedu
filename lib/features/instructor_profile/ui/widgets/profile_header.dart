import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
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
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.4),
                child: IconButton(
                  onPressed: () {
                    context.push(Routes.notificationPage);
                  },
                  icon: const Icon(Icons.notifications),
                  color: Color(0xFF1977F3),
                ),
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.4),
                child: IconButton(
                  onPressed: () {
                    context.push(Routes.settingsPage);
                  },
                  icon: const Icon(Icons.settings),
                  color: Color(0xFF1977F3),
                ),
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.4),
                child: IconButton(
                  onPressed: () {
                    context.push(Routes.earningsScreen);
                  },
                  icon: const Icon(Icons.monetization_on),
                  color: Color(0xFF02457A),
                ),
              ),
            ],
          ),
        ),
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
