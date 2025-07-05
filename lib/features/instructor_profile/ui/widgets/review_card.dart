import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../kid_profile/logic/cubit/kid_profile_cubit.dart';
import '../../../../core/injection/injection.dart';

Widget buildHorizontalReviewCard({
  required String name,
  required String review,
  required int rating,
  String? courseName,
  String? instructorName,
  String? kidImageUrl, // Keep for compatibility but unused
}) {
  return Container(
    width: 312,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFF02457A), width: 1),
    ),
    child: Row(
      children: [
        // Profile picture (optional) - using KidProfileCubit for current kid image
        BlocBuilder<KidProfileCubit, KidProfileState>(
          builder: (context, state) {
            print('🔥 NEW Review Card - KidProfileCubit State: $state');
            ImageProvider kidImage;
            if (state is KidProfileSuccess) {
              final kid = state.kid;
              print('🔥 NEW Review Card - Kid Image: ${kid.image}');
              if (kid.image != null && kid.image!.isNotEmpty) {
                if (kid.image!.startsWith('http') || kid.image!.startsWith('/uploads/')) {
                  kidImage = NetworkImage(kid.image!.startsWith('http') 
                      ? kid.image! 
                      : 'http://192.168.1.3:3000${kid.image}');
                  print('🔥 NEW Review Card - Using network image: ${kid.image}');
                } else {
                  kidImage = const AssetImage('assets/images/kidprofile.jpeg');
                  print('🔥 NEW Review Card - Using default asset');
                }
              } else {
                kidImage = const AssetImage('assets/images/kidprofile.jpeg');
                print('🔥 NEW Review Card - Empty image, using default');
              }
            } else {
              kidImage = const AssetImage('assets/images/kidprofile.jpeg');
              print('🔥 NEW Review Card - Not success state, using default');
            }
            
            return CircleAvatar(
              radius: 30,
              backgroundImage: kidImage,
            );
          },
        ),
        const SizedBox(width: 10),
        // Review text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF02457A),
                ),
              ),
              const SizedBox(height: 8),
              if (courseName != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    courseName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF02457A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              // Rating stars
              Row(
                children: List.generate(
                  rating,
                  (index) => const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 15,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                review,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF02457A),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
