import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import '../../logic/cubit/instructor_profile_cubit.dart';
import '../../../sign_up/data/models/kid.dart';
import 'dart:io';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/notification_badge.dart';
import '../../../../core/notifications/notification_cubit.dart';
import '../../../../core/injection/injection.dart';

class ProfileHeader extends StatefulWidget {
  final bool showActionIcons;
  
  const ProfileHeader({
    super.key, 
    this.showActionIcons = true, // افتراضياً true للمدرب
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      
      // Update instructor profile with new image
      final instructorCubit = BlocProvider.of<InstructorProfileCubit>(context);
      
      // No need to await - let BlocListener handle the response
      instructorCubit.emitUpdateInstructorProfile(
        instructorData: InstructorData(image: image.path),
      );
    }
  }

  Widget _buildImageContainer(String? currentImageUrl) {
    bool hasSelectedImage = _selectedImage != null;
    bool hasCurrentImage = currentImageUrl != null && currentImageUrl.isNotEmpty;
    
    if (!hasSelectedImage && !hasCurrentImage) {
      // Show default background with overlay instructions
      return Container(
        height: 280,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          child: Stack(
            children: [
              // Default background image
              Image.asset(
                'assets/images/InstructorProfilePhoto.jpeg',
                height: 330,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 280,
                    width: double.infinity,
                    color: const Color(0xffB7B7B7),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Color(0xFF02457A),
                      ),
                    ),
                  );
                },
              ),
              // Overlay with instructions (only when action icons are enabled)
              if (widget.showActionIcons)
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Add your profile picture',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Tap to select an image from the gallery',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // Show selected or current image
    return Container(
      height: 330,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        child: Image(
          image: hasSelectedImage
              ? FileImage(_selectedImage!)
              : NetworkImage(
                  currentImageUrl!.startsWith('http') 
                      ? currentImageUrl 
                      : 'http://192.168.1.3:3000$currentImageUrl'
                ) as ImageProvider,
          height: 330,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 330,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.error,
                  size: 50,
                  color: Color(0xFF02457A),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InstructorProfileCubit, InstructorProfileState>(
      listener: (context, state) {
        print('DEBUG: ProfileHeader BlocListener received state: ${state.runtimeType}');
        
        if (state is UpdateInstructorLoading) {
          print('DEBUG: Showing loading dialog');
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is UpdateInstructorSuccess) {
          print('DEBUG: Update success - closing dialog');
          Navigator.pop(context); // Close loading dialog
          
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Success',
            text: 'Profile image updated successfully!',
            confirmBtnText: 'Okay',
            confirmBtnColor: Colors.green,
          );
        } else if (state is UpdateInstructorFailure) {
          print('DEBUG: Update failure - closing dialog');
          Navigator.pop(context); // Close loading dialog
          
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'Failed to update profile image. Please try again.',
            confirmBtnText: 'Okay',
            confirmBtnColor: Colors.red,
          );
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          BlocConsumer<InstructorProfileCubit, InstructorProfileState>(
            listener: (context, state) {
              // Handle loading states directly in the consumer
              if (state is UpdateInstructorLoading) {
                // Already handled by outer BlocListener
              } else if (state is UpdateInstructorSuccess) {
                // Clear selected image and force UI update after successful upload
                if (mounted) {
                  setState(() {
                    _selectedImage = null; // Clear selected image to show server image
                  });
                }
              } else if (state is UpdateInstructorFailure) {
                // Already handled by outer BlocListener
              }
            },
            builder: (context, state) {
              String? currentImageUrl;
              if (state is InstructorProfileSuccess) {
                currentImageUrl = state.instructor.image;
              } else if (state is UpdateInstructorSuccess) {
                // Get the updated image URL from the UpdateInstructorSuccess state
                currentImageUrl = state.instructor.data?.instructor?.image;
              }
              
              return GestureDetector(
                onTap: widget.showActionIcons ? _pickImage : null,
                child: _buildImageContainer(currentImageUrl),
              );
            },
          ),
          
          // أخفي الأيقونات لو جاي من course details
          if (widget.showActionIcons) ...[
            Positioned(
              top: 30,
              right: 10,
              child: Column(
                children: [
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
                        
                        return NotificationBadge(
                          count: notificationCount,
                          backgroundColor: Colors.red,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.4),
                            child: IconButton(
                              onPressed: () {
                                // Clear notifications when user taps
                                context.read<NotificationCubit>().clearNotifications();
                                context.push(Routes.notificationPage);
                              },
                              icon: const Icon(Icons.notifications),
                              color: Color(0xFF1977F3),
                            ),
                          ),
                        );
                      },
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
                      color: Color(0xFF1977F3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
