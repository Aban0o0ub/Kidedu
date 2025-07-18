import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/notification_badge.dart';
import '../../../../core/notifications/notification_cubit.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/injection/injection.dart';
import '../../../kid_profile/logic/cubit/kid_profile_cubit.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key, required this.kidName});
  final String kidName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w), // تقليل التباعد الجانبي
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.r),
          bottomRight: Radius.circular(25.r),
        ),
      ),
      
      child: Row(
        children: [
                   

          BlocBuilder<KidProfileCubit, KidProfileState>(
            builder: (context, state) {
              ImageProvider kidImage;
              if (state is KidProfileSuccess) {
                final kid = state.kid;
                if (kid.image != null && kid.image!.isNotEmpty) {
                  if (kid.image!.startsWith('http') || kid.image!.startsWith('/uploads/')) {
                    kidImage = NetworkImage(kid.image!.startsWith('http') 
                        ? kid.image! 
                        : 'http://192.168.43.204:3000${kid.image}');
                  } else {
                    kidImage = const AssetImage('assets/images/kidprofile.jpeg');
                  }
                } else {
                  kidImage = const AssetImage('assets/images/kidprofile.jpeg');
                }
              } else {
                kidImage = const AssetImage('assets/images/kidprofile.jpeg');
              }
              
              return ClipOval(
                child: Container(
                  height: 70.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: kidImage,
                      fit: BoxFit.cover,
                      onError: (error, stackTrace) {
                        // Fallback to default image on error
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 15.w), 
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome $kidName',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'What do you learn to do today?',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white70, // لون أخف للنص
                  ),
                ),
              ],
            ),
          ),
          BlocProvider.value(
            value: getIt<NotificationCubit>(),
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                int notificationCount = 0;
                if (state is NotificationCountState) {
                  notificationCount = state.count;
                } else if (state is NotificationInitial) {
                  // If still initial, force load
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<NotificationCubit>().loadNotificationCount();
                  });
                }
                
                return InkWell(
                  onTap: () {
                    // Clear notifications when user taps
                    context.read<NotificationCubit>().clearNotifications();
                    // Navigate to notification page
                    context.push(Routes.notificationPage);
                  },
                  child: NotificationBadge(
                    count: notificationCount,
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.notifications,
                      size: 30,
                      color: const Color.fromARGB(255, 250, 205, 56),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
