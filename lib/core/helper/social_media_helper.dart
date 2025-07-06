import 'auth_service.dart';
import 'cache_helper.dart';

class SocialMediaHelper {
  static String _getUserSpecificKey(String baseKey) {
    final userId = AuthService.getUserId();
    return userId != null ? '${userId}_$baseKey' : baseKey;
  }

  // Save social media links to cache
  static Future<void> saveFacebookLink(String link) async {
    await CacheHelper.setData(key: _getUserSpecificKey('facebook_link'), value: link);
  }

  static Future<void> saveBehanceLink(String link) async {
    await CacheHelper.setData(key: _getUserSpecificKey('behance_link'), value: link);
  }

  static Future<void> saveLinkedInLink(String link) async {
    await CacheHelper.setData(key: _getUserSpecificKey('linkedin_link'), value: link);
  }

  static Future<void> saveGitHubLink(String link) async {
    await CacheHelper.setData(key: _getUserSpecificKey('github_link'), value: link);
  }

  // Get social media links from cache
  static String? getFacebookLink() {
    return CacheHelper.getData(key: _getUserSpecificKey('facebook_link'));
  }

  static String? getBehanceLink() {
    return CacheHelper.getData(key: _getUserSpecificKey('behance_link'));
  }

  static String? getLinkedInLink() {
    return CacheHelper.getData(key: _getUserSpecificKey('linkedin_link'));
  }

  static String? getGitHubLink() {
    return CacheHelper.getData(key: _getUserSpecificKey('github_link'));
  }

  // Get all social media links
  static Map<String, String?> getAllLinks() {
    return {
      'facebook': getFacebookLink(),
      'behance': getBehanceLink(),
      'linkedin': getLinkedInLink(),
      'github': getGitHubLink(),
    };
  }

  // Save all links at once
  static Future<void> saveAllLinks(Map<String, String> links) async {
    if (links['facebook'] != null) await saveFacebookLink(links['facebook']!);
    if (links['behance'] != null) await saveBehanceLink(links['behance']!);
    if (links['linkedin'] != null) await saveLinkedInLink(links['linkedin']!);
    if (links['github'] != null) await saveGitHubLink(links['github']!);
  }

  // Clear all social media links
  static Future<void> clearAllLinks() async {
    await CacheHelper.removeData(key: _getUserSpecificKey('facebook_link'));
    await CacheHelper.removeData(key: _getUserSpecificKey('behance_link'));
    await CacheHelper.removeData(key: _getUserSpecificKey('linkedin_link'));
    await CacheHelper.removeData(key: _getUserSpecificKey('github_link'));
  }
} 