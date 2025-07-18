import 'package:loginpage/core/helper/cache_helper.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userRoleKey = 'userRole';
  static const String _userEmailKey = 'userEmail';
  static const String _userIdKey = 'userId';
  static const String _userNameKey = 'userName';

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

  static bool isLoggedIn() {
    return CacheHelper.getData(key: _isLoggedInKey) ?? false;
  }

  static String? getUserRole() {
    return CacheHelper.getData(key: _userRoleKey);
  }

  static String? getUserEmail() {
    return CacheHelper.getData(key: _userEmailKey);
  }

  static String? getUserId() {
    return CacheHelper.getData(key: _userIdKey);
  }

  static String? getUserName() {
    return CacheHelper.getData(key: _userNameKey);
  }

  static Map<String, dynamic> getUserData() {
    return {
      'isLoggedIn': isLoggedIn(),
      'role': getUserRole(),
      'email': getUserEmail(),
      'userId': getUserId(),
      'userName': getUserName(),
    };
  }

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

  static String getHomeRouteForRole(String? role) {
    switch (role) {
      case 'kid':
        return '/home';
      case 'instructor':
        return '/instructorProfile';  
      case 'admin':
        return '/adminEarnings';    
      default:
        return '/'; 
    }
  }

  static bool isValidSession() {
    return isLoggedIn() && getUserRole() != null && getUserEmail() != null;
  }

  static Future<void> logout() async {
    await CacheHelper.removeData(key: _isLoggedInKey);
    await CacheHelper.removeData(key: _userRoleKey);
    await CacheHelper.removeData(key: _userEmailKey);
    await CacheHelper.removeData(key: _userIdKey);
    await CacheHelper.removeData(key: _userNameKey);

    // Clear notifications
    await CacheHelper.removeData(key: 'notifications');
    await CacheHelper.removeData(key: 'notifications_cleared');

    final userId = getUserId();
    if (userId != null) {
      await CacheHelper.removeData(key: '${userId}_facebook_link');
      await CacheHelper.removeData(key: '${userId}_behance_link');
      await CacheHelper.removeData(key: '${userId}_linkedin_link');
      await CacheHelper.removeData(key: '${userId}_github_link');
    }
  }
} 