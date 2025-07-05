import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../lesson/logic/cubit/section_cubit.dart';
import '../../../login/logic/cubit/my_cubit.dart';
import '../widgets/section_tile.dart';
import '../../../../core/routing/routes.dart';

class CourseContentSection extends StatelessWidget {
  final String courseId;
  final bool isCourseEnded;
  final VoidCallback onEndCourse;
  
  const CourseContentSection({
    super.key,
    required this.courseId,
    required this.isCourseEnded,
    required this.onEndCourse,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleCubit, String?>(
      builder: (context, userRole) {
        if (userRole == 'instructor' || userRole == 'kid') {
          return Stack(
            children: [
              Container(
                width: double.infinity, 
                margin: const EdgeInsets.only(top: 15), 
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF02457A),
                      const Color(0xFF0A5999),
                      const Color(0xFF02457A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16), // الزوايا المدورة
                 
                ),
                child: Stack(
                  children: [
                    // دوائر ديكور صغيرة في الخلفية
                    Positioned(
                      top: 20,
                      right: 30,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 20,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 80,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    // خطوط ديكور رفيعة
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.2),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100), // حد أدنى للارتفاع
                  ],
                ),
              ),
              
              // المحتوى فوق البوكس
              Column(
                children: [
                  // Header مع كلمة Content والأيقونات
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Content",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white, // أبيض لأنها فوق البوكس الأزرق
                          ),
                        ),
                        if (userRole == 'instructor')
                          Row(
                            children: [
                              GestureDetector(
                                onTap: onEndCourse,
                                child: const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (!isCourseEnded) 
                                GestureDetector(
                                  onTap: () {
                                    context.push(Routes.addLessonPage, extra: {
                                      'courseId': courseId
                                    });
                                  },
                                  child: const Icon(
                                    Icons.add_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // محتوى الـ Sections
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BlocBuilder<SectionCubit, SectionState>(
                      builder: (context, sectionState) {
                        if (sectionState is GetSectionLoading) {
                          return const SizedBox(
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else if (sectionState is GetSectionSuccess) {
                          final sections = sectionState.response.sections;

                          if (sections.isEmpty) {
                            return const SizedBox(
                              height: 100,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_outlined,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "No sections available",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color:  Color(0xFF02457A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Container(
                            constraints: const BoxConstraints(minHeight: 100),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: sections.length,
                              itemBuilder: (context, index) {
                                final section = sections[index];
                                return ExpandableSectionTile(
                                  section: section,
                                );
                              },
                            ),
                          );
                        } else if (sectionState is GetSectionFailure) {
                          return SizedBox(
                            height: 100,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red[300],
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Failed to load sections",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red[300],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () {
                                      // إضافة retry logic هنا إذا كان متاح
                                    },
                                    child: const Text(
                                      "Tap to retry",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        
                        return const SizedBox(
                          height: 100,
                          child: Center(
                            child: Text(
                              "Loading content...",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          );
        }
        return const SizedBox(); 
      },
    );
  }
}