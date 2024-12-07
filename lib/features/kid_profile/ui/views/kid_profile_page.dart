import 'package:flutter/material.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import 'package:loginpage/features/kid_profile/ui/views/edit_profile.dart';
import 'package:loginpage/features/kid_profile/ui/widgets/profile_item.dart';

class KidProfilePage extends StatelessWidget {
  const KidProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: ArrowBack(),
            ),
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage('assets/images/kidprofile.jpeg'),
                      ),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Kid Name",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF02457A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  profileitem(
                    image: 'assets/images/editprofile.jpeg',
                    title: 'Edit profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfile()),
                      );
                    },
                  ),
                  const Divider(color: Color(0xFF02457A)),
                  profileitem(
                    image: 'assets/images/notifications.jpeg',
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  const Divider(color: Color(0xFF02457A)),
                  profileitem(
                    image: 'assets/images/achievements.jpeg',
                    title: 'Achievements',
                    onTap: () {},
                  ),
                  const Divider(color: Color(0xFF02457A)),
                  profileitem(
                    image: 'assets/images/courses.jpeg',
                    title: 'My courses',
                    onTap: () {},
                  ),
                  const Divider(color: Color(0xFF02457A)),
                  profileitem(
                    image: 'assets/images/evaluation.jpeg',
                    title: 'Evaluation',
                    onTap: () {},
                  ),
                  const Divider(color: Color(0xFF02457A)),
                  profileitem(
                    image: 'assets/images/bookmark.jpeg',
                    title: 'Bookmarks',
                    onTap: () {},
                  ),
                  const Divider(color: Color(0xFF02457A)),
                  profileitem(
                    image: 'assets/images/settings.jpeg',
                    title: 'Settings',
                    onTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
