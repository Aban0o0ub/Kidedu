import 'package:loginpage/core/helper/cache_helper.dart';

class AuthService {
  // Constants for cache keys
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userRoleKey = 'userRole';
  static const String _userEmailKey = 'userEmail';
  static const String _userIdKey = 'userId';
  static const String _userNameKey = 'userName';

  /// حفظ بيانات المستخدم بعد تسجيل الدخول الناجح
  static Future<bool> saveUserSession({
    required String role,
    required String email,
    String? userId,
    String? userName,
  }) async {
    try {
      await CacheHelper.setData(key: _isLoggedInKey, value: true);
      await CacheHelper.setData(key: _userRoleKey, value: role);
      await CacheHelper.setData(key: _userEmailKey, value: email);
      
      if (userId != null) {
        await CacheHelper.setData(key: _userIdKey, value: userId);
      }
      
      if (userName != null) {
        await CacheHelper.setData(key: _userNameKey, value: userName);
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// فحص إذا كان المستخدم مسجل دخوله
  static bool isLoggedIn() {
    return CacheHelper.getData(key: _isLoggedInKey) ?? false;
  }

  /// الحصول على دور المستخدم المحفوظ
  static String? getUserRole() {
    return CacheHelper.getData(key: _userRoleKey);
  }

  /// الحصول على إيميل المستخدم المحفوظ
  static String? getUserEmail() {
    return CacheHelper.getData(key: _userEmailKey);
  }

  /// الحصول على معرف المستخدم المحفوظ
  static String? getUserId() {
    return CacheHelper.getData(key: _userIdKey);
  }

  /// الحصول على اسم المستخدم المحفوظ
  static String? getUserName() {
    return CacheHelper.getData(key: _userNameKey);
  }

  /// الحصول على جميع بيانات المستخدم المحفوظة
  static Map<String, dynamic> getUserData() {
    return {
      'isLoggedIn': isLoggedIn(),
      'role': getUserRole(),
      'email': getUserEmail(),
      'userId': getUserId(),
      'userName': getUserName(),
    };
  }

  /// مسح جلسة المستخدم (logout)
  static Future<bool> clearUserSession() async {
    try {
      await CacheHelper.removeData(key: _isLoggedInKey);
      await CacheHelper.removeData(key: _userRoleKey);
      await CacheHelper.removeData(key: _userEmailKey);
      await CacheHelper.removeData(key: _userIdKey);
      await CacheHelper.removeData(key: _userNameKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// الحصول على المسار المناسب حسب دور المستخدم
  static String getHomeRouteForRole(String? role) {
    switch (role) {
      case 'kid':
        return '/home';
      case 'instructor':
        return '/instructorProfile';  // ✅ تم تصحيح المسار
      case 'admin':
        return '/adminEarnings';     // ✅ تم تصحيح المسار أيضاً
      default:
        return '/';  // العودة للـ welcome page
    }
  }

  /// فحص صحة جلسة المستخدم
  static bool isValidSession() {
    return isLoggedIn() && getUserRole() != null && getUserEmail() != null;
  }

  /// تسجيل الخروج وحذف كل البيانات المتعلقة بالمستخدم
  static Future<void> logout() async {
    // Clear user session data
    await CacheHelper.removeData(key: _isLoggedInKey);
    await CacheHelper.removeData(key: _userRoleKey);
    await CacheHelper.removeData(key: _userEmailKey);
    await CacheHelper.removeData(key: _userIdKey);
    await CacheHelper.removeData(key: _userNameKey);

    // Clear notifications
    await CacheHelper.removeData(key: 'notifications');
    await CacheHelper.removeData(key: 'notifications_cleared');

    // Clear social media links for the user
    final userId = getUserId();
    if (userId != null) {
      await CacheHelper.removeData(key: '${userId}_facebook_link');
      await CacheHelper.removeData(key: '${userId}_behance_link');
      await CacheHelper.removeData(key: '${userId}_linkedin_link');
      await CacheHelper.removeData(key: '${userId}_github_link');
    }
  }
} 