import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  static final List<Map<String, dynamic>> _bookmarkedCourses = [];
  static const String _bookmarkKey = 'bookmarked_courses';
  
  static List<Map<String, dynamic>> get bookmarkedCourses => List.unmodifiable(_bookmarkedCourses);
  
  static Future<void> loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? bookmarksString = prefs.getString(_bookmarkKey);
      
      if (bookmarksString != null) {
        final List<dynamic> bookmarksList = json.decode(bookmarksString);
        _bookmarkedCourses.clear();
        _bookmarkedCourses.addAll(
          bookmarksList.map((item) => Map<String, dynamic>.from(item)).toList()
        );
      }
    } catch (e) {
      print('Error loading bookmarks: $e');
    }
  }
  
  // حفظ البيانات في الجهاز
  static Future<void> _saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String bookmarksString = json.encode(_bookmarkedCourses);
      await prefs.setString(_bookmarkKey, bookmarksString);
    } catch (e) {
      print('Error saving bookmarks: $e');
    }
  }
  
  static bool isCourseBookmarked(String courseId) {
    return _bookmarkedCourses.any((course) => course['id'] == courseId);
  }
  
  static Future<void> addToBookmark(Map<String, dynamic> course) async {
    if (!isCourseBookmarked(course['id'])) {
      _bookmarkedCourses.add(course);
      await _saveBookmarks();
    }
  }
  
  static Future<void> removeFromBookmark(String courseId) async {
    _bookmarkedCourses.removeWhere((course) => course['id'] == courseId);
    await _saveBookmarks();
  }
  
  static Future<void> toggleBookmark(Map<String, dynamic> course) async {
    if (isCourseBookmarked(course['id'])) {
      await removeFromBookmark(course['id']);
    } else {
      await addToBookmark(course);
    }
  }
  
  // مسح كل البوك مارك
  static Future<void> clearAllBookmarks() async {
    _bookmarkedCourses.clear();
    await _saveBookmarks();
  }
}