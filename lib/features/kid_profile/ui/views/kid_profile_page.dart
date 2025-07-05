import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/features/kid_profile/logic/cubit/kid_profile_cubit.dart';
import 'package:loginpage/features/kid_profile/ui/widgets/profile_item.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import '../../../../core/routing/routes.dart';

class KidProfilePage extends StatefulWidget {
  const KidProfilePage({super.key, this.kid});
  final KidData? kid;

  @override
  State<KidProfilePage> createState() => _KidProfilePageState();
}

class _KidProfilePageState extends State<KidProfilePage> {
  late KidProfileCubit kidProfileCubit;
  @override
  void initState() {
    super.initState();
    kidProfileCubit = getIt<KidProfileCubit>();
    kidProfileCubit.emitGetKidProfile();
  }

  void _refreshProfile() {
    kidProfileCubit.emitGetKidProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: kidProfileCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100), // مساحة تحت عشان الناف بار
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // صورة واسم الطفل
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            BlocBuilder<KidProfileCubit, KidProfileState>(
                              builder: (context, state) {
                                if (state is KidProfileSuccess) {
                                  final kid = state.kid;
                                  return CircleAvatar(
                                    radius: 60,
                                    backgroundImage: (kid.image != null && kid.image!.isNotEmpty)
                                        ? (kid.image!.startsWith('http') || kid.image!.startsWith('/uploads/'))
                                            ? NetworkImage(kid.image!.startsWith('http') 
                                                ? kid.image! 
                                                : 'http://192.168.1.3:3000${kid.image}')
                                            : AssetImage('assets/images/kidprofile.jpeg')
                                        : const AssetImage('assets/images/kidprofile.jpeg') as ImageProvider,
                                  );
                                } else {
                                  return const CircleAvatar(
                                    radius: 60,
                                    backgroundImage: AssetImage('assets/images/kidprofile.jpeg'),
                                  );
                                }
                              },
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
                        BlocBuilder<KidProfileCubit, KidProfileState>(
                          builder: (context, state) {
                            if (state is KidProfileSuccess) {
                              KidData? kid = state.kid;
          
                              if (kid.name == null || kid.name!.isEmpty) {
                                return Text(
                                  "Kid name not available",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                );
                              }
                              return Text(
                                kid.name!,
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              );
                            } else if (state is KidProfileFailure) {
                              return Text(
                                "There is an error: ${state.error}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // قائمة البروفايل
                  BlocBuilder<KidProfileCubit, KidProfileState>(
                    builder: (context, state) {
                      return profileitem(
                        image: 'assets/images/editprofile.jpeg',
                        title: 'Edit profile',
                        onTap: () async {
                          if (state is KidProfileSuccess) {
                            final result = await context.push(
                              Routes.editProfilePage,
                              extra: {
                                'name': state.kid.name,
                                'email': state.kid.email,
                                'phone': state.kid.phoneNumber,
                                'age': state.kid.age?.toString(),
                                'governorate': state.kid.governorate,
                                'gender': state.kid.gender,
                                'image': state.kid.image,
                              },
                            );
        
                            if (result == true) {
                              _refreshProfile();
                            }
                          } else {
                            final result =
                                await context.push(Routes.editProfilePage);
                            if (result == true) {
                              _refreshProfile();
                            }
                          }
                        },
                      );
                    },
                  ),
                  Divider(color: Theme.of(context).primaryColor),
                  profileitem(
                    image: 'assets/images/notifications.jpeg',
                    title: 'Notifications',
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      context.push(Routes.notificationPage);
                    },
                  ),
                  Divider(color: Theme.of(context).primaryColor),
                  profileitem(
                    image: 'assets/images/achievements.jpeg',
                    title: 'Achievements',
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      context.push(Routes.achievementPage);
                    },
                  ),
                  Divider(color: Theme.of(context).primaryColor),
                  profileitem(
                    image: 'assets/images/courses.jpeg',
                    title: 'My courses',
                    onTap: () {},
                  ),
                  Divider(color: Theme.of(context).primaryColor),
                  // profileitem(
                  //   image: 'assets/images/evaluation.jpeg',
                  //   title: 'Evaluation',
                  //   onTap: () {},
                  // ),
                  // const Divider(color: Color(0xFF02457A)),
                  profileitem(
                    image: 'assets/images/bookmark.jpeg',
                    title: 'Bookmarks',
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      context.push(Routes.bookmarkPage);
                    },
                  ),
                  Divider(color: Theme.of(context).primaryColor),
                  profileitem(
                    image: 'assets/images/settings.jpeg',
                    title: 'Settings',
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      context.push(Routes.settingsPage);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}