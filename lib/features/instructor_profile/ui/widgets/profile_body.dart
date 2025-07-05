import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/instructor_profile/logic/cubit/instructor_profile_cubit.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/course_box.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/info_container.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/blue_section_container.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/social_media_edit_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/helper/social_media_helper.dart';
import '../../../course_details/logic/cubit/course_details_cubit.dart';
import '../../../reviews/logic/cubit/reviews_cubit.dart';
import '../../logic/cubit/my_courses_cubit.dart';

class ProfileBody extends StatefulWidget {
  final List<dynamic>? courses;
  final List<dynamic>? reviews;
  final bool showEditIcons;

  const ProfileBody({
    super.key,
    this.courses,
    this.reviews,
    this.showEditIcons = true,
  });

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  CourseDetailsCubit courseDetailsCubit = getIt<CourseDetailsCubit>();
  Map<String, String?> socialMediaLinks = {};

  @override
  void initState() {
    super.initState();
    _loadSocialMediaLinks();
  }

  void _loadSocialMediaLinks() {
    setState(() {
      socialMediaLinks = SocialMediaHelper.getAllLinks();
    });
  }

  void _refreshSocialMediaLinks() {
    _loadSocialMediaLinks();
  }

  void _showSocialMediaEditDialog() {
    showDialog(
      context: context,
      builder: (context) => SocialMediaEditDialog(
        onSave: _refreshSocialMediaLinks,
      ),
    );
  }

  Future<void> _launchUrl(String? url) async {
    if (url != null && url.isNotEmpty) {
      try {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Could not open link".tr()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String? _getFirstValidImage(List<String>? images) {
    if (images == null || images.isEmpty) return null;

    for (String image in images) {
      if (image.isNotEmpty) {
        return image;
      }
    }
    return null;
  }

  String _getFullImageUrl(String imagePath) {
    if (imagePath.startsWith('/uploads/')) {
      return 'http://192.168.1.3:3000$imagePath';
    } else if (!imagePath.startsWith('http')) {
      // Add slash if imagePath doesn't start with one
      String pathWithSlash = imagePath.startsWith('/') ? imagePath : '/$imagePath';
      return 'http://192.168.1.3:3000$pathWithSlash';
    }
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<InstructorProfileCubit, InstructorProfileState>(
          builder: (context, state) {
            if (state is InstructorProfileSuccess) {
              var instructor = state.instructor;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      instructor.name ?? "Instructor Name".tr(),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      instructor.title ?? "Title".tr(),
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 30),
                    buildInfoContainer(
                      context: context,
                      header: "Bio".tr(),
                      text: instructor.bio ?? "No bio available".tr(),
                      showEditButton: widget.showEditIcons,
                    ),
                    const SizedBox(height: 20),
                    buildInfoContainer(
                      context: context,
                      header: "Personal Information".tr(),
                      name: instructor.name ?? "Instructor Name".tr(),
                      phone:
                          instructor.phoneNumber ?? "No phone available".tr(),
                      email: instructor.email ?? "No email available".tr(),
                      governorate: instructor.governorate ??
                          "No governorate available".tr(),
                      title: instructor.title ?? "Title".tr(),
                      showEditButton: widget.showEditIcons,
                    ),
                    const SizedBox(height: 20),
                    buildInfoContainer(
                      context: context,
                      header: "Experience".tr(),
                      text: instructor.experience ??
                          "No experience available".tr(),
                      showEditButton: widget.showEditIcons,
                    ),
                    const SizedBox(height: 20),
                    BlueSectionContainer(
                      title: "My Courses".tr(),
                      content: widget.courses != null
                          ? _buildCoursesListWithWhiteStyle(widget.courses!)
                          : BlocBuilder<MyCoursesCubit, MyCoursesState>(
                              builder: (context, state) {
                                if (state is MyCoursesLoading) {
                                  return const SizedBox(
                                    height: 165,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                } else if (state is GetMyCoursesFailure) {
                                  return SizedBox(
                                    height: 165,
                                    child: Center(
                                      child: Text(
                                        "Error: ${state.error}",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  );
                                } else if (state is GetMyCoursesSuccess) {
                                  final courses = state.courses;

                                  if (courses.isEmpty) {
                                    return SizedBox(
                                      height: 165,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.school_outlined,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "No courses yet".tr(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return _buildCoursesListWithWhiteStyle(
                                      courses);
                                } else {
                                  return const SizedBox(
                                    height: 165,
                                    child: Center(
                                      child: Text(
                                        "No courses available.",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<ReviewsCubit, ReviewsState>(
                      builder: (context, state) {
                        // إذا كان هناك مراجعات مباشرة من widget.reviews
                        if (widget.reviews != null && widget.reviews!.isNotEmpty) {
                          return Column(
                            children: [
                              BlueSectionContainer(
                                title: "Reviews".tr(),
                                content: _buildReviewsList(widget.reviews!),
                              ),
                              const SizedBox(height: 30),
                            ],
                          );
                        }

                        // إذا كان هناك مراجعات من الـ state
                        if (state is GetReviewsSuccess && state.reviews.isNotEmpty) {
                          return Column(
                            children: [
                              BlueSectionContainer(
                                title: "Reviews".tr(),
                                content: _buildReviewsList(state.reviews),
                              ),
                              const SizedBox(height: 30),
                            ],
                          );
                        }

                        // في حالة عدم وجود مراجعات، نرجع Container فارغ
                        return Container();
                      },
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Social Links".tr(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                if (widget.showEditIcons)
                                  IconButton(
                                    onPressed: _showSocialMediaEditDialog,
                                    icon: Icon(Icons.edit,
                                        color: Theme.of(context).primaryColor),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildSocialMediaIcon(
                                  imagePath: 'assets/images/facebook.jpeg',
                                  url: socialMediaLinks['facebook'],
                                  label: 'Facebook',
                                ),
                                _buildSocialMediaIcon(
                                  imagePath: 'assets/images/behance.jpeg',
                                  url: socialMediaLinks['behance'],
                                  label: 'Behance',
                                ),
                                _buildSocialMediaIcon(
                                  imagePath: 'assets/images/linkedin.jpeg',
                                  url: socialMediaLinks['linkedin'],
                                  label: 'LinkedIn',
                                ),
                                _buildSocialMediaIcon(
                                  imagePath: 'assets/images/github.jpeg',
                                  url: socialMediaLinks['github'],
                                  label: 'GitHub',
                                ),
                              ],
                            ),
                          ]),
                    ),
                    const SizedBox(height: 30),
                  ]);
            } else if (state is InstructorProfileFailure) {
              return Center(
                child: Text(
                  "${"There is an error:".tr()} ${state.error}",
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).colorScheme.error),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            );
          },
        ),
      ),
    );
  }

  // Widget _buildCoursesList(List<dynamic> courses) {
  //   return SizedBox(
  //     height: 165,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: courses.length,
  //       itemBuilder: (context, index) {
  //         final course = courses[index];
  //         return GestureDetector(
  //           onTap: () {
  //             if (course.id != null && course.id!.isNotEmpty) {
  //               context.push(
  //                 Routes.courseDetails,
  //                 extra: {
  //                   '_id': course.id,
  //                   'courseDetailsCubit': courseDetailsCubit,
  //                 },
  //               );
  //             }
  //           },
  //           child: buildCourseBox(
  //             imagePath:
  //                 _getFirstValidImage(courses[index].courseImages) != null
  //                     ? _getFullImageUrl(
  //                         _getFirstValidImage(courses[index].courseImages)!)
  //                     : "assets/images/CourseDefaultPhoto.jpeg",
  //             courseName: courses[index].courseName ?? 'No Course Name'.tr(),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildCoursesListWithWhiteStyle(List<dynamic> courses) {
    return SizedBox(
      height: 165,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return GestureDetector(
            onTap: () {
              if (course.id != null && course.id!.isNotEmpty) {
                context.push(
                  Routes.courseDetails,
                  extra: {
                    '_id': course.id,
                    'courseDetailsCubit': courseDetailsCubit,
                  },
                );
              }
            },
            child: buildCourseBox(
              imagePath:
                  _getFirstValidImage(courses[index].courseImages) != null
                      ? _getFullImageUrl(
                          _getFirstValidImage(courses[index].courseImages)!)
                      : "assets/images/CourseDefaultPhoto.jpeg",
              courseName: courses[index].courseName ?? 'No Course Name'.tr(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewsList(List<dynamic> reviews) {
    return SizedBox(
      height: 142,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Padding(
            padding:
                EdgeInsets.only(right: index < reviews.length - 1 ? 10 : 0),
            child: buildHorizontalReviewCard(
              name: review.displayKidName,
              review: review.reviewText,
              rating: review.rating,
              courseName: review.displayCourseName,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSocialMediaIcon({
    required String imagePath,
    required String? url,
    required String label,
  }) {
    final bool hasLink = url != null && url.isNotEmpty;
    
    return Tooltip(
      message: hasLink ? "$label: $url" : "No $label link set",
      child: InkWell(
        onTap: hasLink ? () => _launchUrl(url) : null,
        child: Opacity(
          opacity: hasLink ? 1.0 : 0.5,
          child: Container(
            decoration: BoxDecoration(
              border: hasLink 
                  ? Border.all(color: const Color(0xFF02457A), width: 2)
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              imagePath,
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
    );
  }
}
