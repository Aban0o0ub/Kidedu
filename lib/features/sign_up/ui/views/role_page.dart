import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/arrow_back.dart';
import '../../../login/logic/cubit/my_cubit.dart';
import '../widgets/upper_stickers_photo.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const UpperStickersPhoto(),
          const ArrowBack(),
          Column(
            children: [
              const SizedBox(height: 240),
               Text(
                'Role'.tr(),
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF02457A),
                ),
              ),
              const SizedBox(height: 8),
               Text(
                'Who are you?'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF02457A),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<RoleCubit>().selectRole("kid");
                          context.push(Routes.loginPage).then((_) {
                            FocusScope.of(context).unfocus();
                          });
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFD8D8),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                              child:  Center(
                                child: Text(
                                  'Kid'.tr(),
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF02457A),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: -9,
                              bottom: 0,
                              child: Image.asset(
                                'assets/images/kidPhoto.png',
                                height: 170,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          context.read<RoleCubit>().selectRole("instructor");
                          context.push(Routes.loginPage).then((_) {
                            FocusScope.of(context).unfocus();
                          });
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              decoration: const BoxDecoration(
                                color: Color(0xFFABE8EA),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                ),
                              ),
                              child:  Center(
                                child: Text(
                                  'Instructor'.tr(),
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF02457A),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 15,
                              child: Image.asset(
                                'assets/images/InstructorPhoto.png',
                                height: 150,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<RoleCubit>()
                              .selectRole("admin"); 
                          context.push(Routes.loginPage).then((_) {
                            FocusScope.of(context).unfocus();
                          });
                        },
                        child: Text(
                          'Continue as admin'.tr(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF02457A),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
