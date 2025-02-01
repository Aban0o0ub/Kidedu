//import 'package:bson/bson.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/features/kid_profile/logic/cubit/kid_profile_cubit.dart';
import 'package:loginpage/features/kid_profile/ui/views/edit_profile.dart';
import 'package:loginpage/features/kid_profile/ui/widgets/profile_item.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
//import 'package:loginpage/features/sign_up/data/models/kid.dart';

class KidProfilePage extends StatefulWidget {
  const KidProfilePage({super.key});

  @override
  State<KidProfilePage> createState() => _KidProfilePageState();
}

class _KidProfilePageState extends State<KidProfilePage> {
  @override
  Widget build(BuildContext context) {
    //---------------------------------------------------------------

    KidProfileCubit kidProfileCubit = getIt<KidProfileCubit>();
    return BlocProvider(
      create: (context) => kidProfileCubit,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
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
                    //--------------------------------------------------------------------------
                    BlocBuilder<KidProfileCubit, KidProfileState>(
                      bloc: kidProfileCubit,
                      builder: (context, state) {
                        if (state is GetSingleKid) {
                          Kid kid = Kid();
                          //print("Kid Name: ${kid.name}");
                          return Text(
                            kid.name ?? "Amr",
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF02457A),
                            ),
                          );
                        }
                        return const Text(
                          "Kid Name",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF02457A),
                          ),
                        );
                      },
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
                          MaterialPageRoute(
                              builder: (context) => EditProfile()),
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
      ),
    );
  }
}
