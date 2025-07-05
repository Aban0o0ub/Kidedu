import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../course_details/logic/cubit/course_details_cubit.dart';
import '../../../../core/widgets/arrow_back.dart';

class CourseHeaderSection extends StatefulWidget {
  const CourseHeaderSection({super.key});

  @override
  State<CourseHeaderSection> createState() => _CourseHeaderSectionState();
}

class _CourseHeaderSectionState extends State<CourseHeaderSection> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _shareCourse(dynamic course) {
    if (course == null) return;
    
    String courseName = course.courseName ?? 'Amazing Course';
    String instructorName = course.instructorName ?? 'Expert Instructor';
    String description = course.description ?? 'Check out this amazing course!';
    String price = course.price != null ? '${course.price} EGP' : 'Free';
    
    String shareText = '''
🎓 $courseName

👨‍🏫 Instructor: $instructorName
💰 Price: $price

📝 $description

Join this amazing course now! 🚀

#KidEdu #OnlineLearning #Education
    ''';
    
    Share.share(shareText, subject: 'Check out this course: $courseName');
  }

  void _showShareOptions(dynamic course) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Share Course',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF02457A),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareOption(
                    icon: Icons.share,
                    label: 'Share',
                    onTap: () {
                      Navigator.pop(context);
                      _shareCourse(course);
                    },
                  ),
                  _buildShareOption(
                    icon: Icons.copy,
                    label: 'Copy Link',
                    onTap: () {
                      Navigator.pop(context);
                      _copyLink(course);
                    },
                  ),
                  _buildShareOption(
                    icon: Icons.message,
                    label: 'WhatsApp',
                    onTap: () {
                      Navigator.pop(context);
                      _shareToWhatsApp(course);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF02457A),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF02457A),
            ),
          ),
        ],
      ),
    );
  }

  void _copyLink(dynamic course) {
   // String courseName = course?.courseName ?? 'Amazing Course';
    String courseLink = 'https://kidedu.app/course/${course?.id ?? 'unknown'}';
    
    Clipboard.setData(ClipboardData(text: courseLink)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Course link copied to clipboard!'),
            ],
          ),
          backgroundColor: Color(0xFF02457A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    });
  }

  void _shareToWhatsApp(dynamic course) {
    String courseName = course?.courseName ?? 'Amazing Course';
    String message = 'Check out this amazing course: $courseName on KidEdu! 🎓';
    
    Share.share(message, subject: courseName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
      builder: (context, state) {
        List<String> imageUrls = [];
        dynamic course;
        
        if (state is GetCourseSuccess) {
          course = state.course;
          if (state.course.courseImages != null && state.course.courseImages!.isNotEmpty) {
            // Filter out empty strings and invalid URLs
            imageUrls = state.course.courseImages!
                .where((url) => url.isNotEmpty)
                .toList();
          }
        }

        // If no valid images, show default image
        if (imageUrls.isEmpty) {
          imageUrls = ['assets/images/CourseDefaultPhoto.jpeg'];
        }

        return Stack(
          children: [
            Container(
              height: 330,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  final imageUrl = imageUrls[index];
                  
                  return ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    child: _buildImageWidget(imageUrl),
                  );
                },
              ),
            ),

            // Dots indicator (only show if more than 1 image)
            if (imageUrls.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    imageUrls.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index 
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ),

            // Navigation arrows (only show if more than 1 image)
            if (imageUrls.length > 1) ...[
              // Left arrow
              Positioned(
                left: 16,
                top: 0,
                bottom: 60, // Above dots
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentIndex > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Right arrow
              Positioned(
                right: 16,
                top: 0,
                bottom: 60, // Above dots
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentIndex < imageUrls.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],

            // Back arrow and share button
            const Positioned(
              top: 20,
              left: 10,
              child: ArrowBack(),
            ),
            Positioned(
              top: 40,
              right: 10,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => _showShareOptions(course),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share,
                        size: 24,
                        color: Color(0xFF02457A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    // If imageUrl is empty or null, show default image
    if (imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/CourseDefaultPhoto.jpeg',
        fit: BoxFit.cover,
        width: double.infinity,
        height: 330,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 330,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.image_not_supported, size: 50),
            ),
          );
        },
      );
    }

    // Check if it's an asset or network image
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 330,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/CourseDefaultPhoto.jpeg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 330,
          );
        },
      );
    } else {
      // Convert relative path to full URL
      String fullImageUrl = imageUrl;
      if (imageUrl.startsWith('/uploads/')) {
        fullImageUrl = 'http://192.168.1.3:3000$imageUrl';
      } else if (!imageUrl.startsWith('http')) {
        // Add slash if imageUrl doesn't start with one
        String pathWithSlash = imageUrl.startsWith('/') ? imageUrl : '/$imageUrl';
        fullImageUrl = 'http://192.168.1.3:3000$pathWithSlash';
      }
      
      return Image.network(
        fullImageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 330,
        errorBuilder: (context, error, stackTrace) {
          // Handle 404 and other network errors by showing default image
          print('Course header image loading failed for URL: $fullImageUrl, Error: $error');
          return Container(
            width: double.infinity,
            height: 330,
            color: Colors.grey[200],
            child: Image.asset(
              'assets/images/CourseDefaultPhoto.jpeg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 330,
              errorBuilder: (context, error, stackTrace) {
                // Final fallback
                return Container(
                  width: double.infinity,
                  height: 330,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Image not available',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 330,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}