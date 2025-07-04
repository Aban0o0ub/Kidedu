import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/core/widgets/appbar.dart';
import '../../../home/ui/widgets/course_card.dart';

class BookmarkedCoursesPage extends StatefulWidget {
  final List<Map<String, dynamic>> bookmarkedCourses;
  final Function(Map<String, dynamic>) onUpdate;
  
  const BookmarkedCoursesPage({
    super.key,
    required this.bookmarkedCourses,
    required this.onUpdate,
  });
  
  @override
  State<BookmarkedCoursesPage> createState() => _BookmarkedCoursesPageState();
}

class _BookmarkedCoursesPageState extends State<BookmarkedCoursesPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: "Bookmark".tr(),onBackPressed: () => Navigator.pop(context),),
        body: widget.bookmarkedCourses.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No bookmarked courses yet.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.bookmarkedCourses.length,
                itemBuilder: (context, index) {
                  final course = widget.bookmarkedCourses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CourseCard(
                      key: ValueKey(course['id']),
                      courseImages: course['courseImages'],
                      courseName: course['courseName'],
                      instructor: course['instructor'],
                      description: course['description'],
                      price: course['price'],
                      availability: course['availability'],
                      id: course['id'],
                      forceBlueBookmarkIcon: true,
                      onBookmark: (data) {
                        // نعمل كوبي من الليست
                        final updatedList = List<Map<String, dynamic>>.from(
                          widget.bookmarkedCourses
                        );
                        updatedList.removeWhere((c) => c['id'] == data['id']);
                        
                        // نبعت التحديث للـ parent
                        widget.onUpdate(data);
                        
                        // نحديث الليست المحلية
                        setState(() {
                          widget.bookmarkedCourses.clear();
                          widget.bookmarkedCourses.addAll(updatedList);
                        });
                        
                        // نعرض رسالة تأكيد
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Course removed from bookmarks'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}