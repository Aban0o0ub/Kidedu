import 'cache_helper.dart';

class SocialMediaHelper {
  static const String _facebookKey = 'facebook_link';
  static const String _behanceKey = 'behance_link';
  static const String _linkedinKey = 'linkedin_link';
  static const String _githubKey = 'github_link';

  // Save social media links to cache
  static Future<void> saveFacebookLink(String link) async {
    await CacheHelper.setData(key: _facebookKey, value: link);
  }

  static Future<void> saveBehanceLink(String link) async {
    await CacheHelper.setData(key: _behanceKey, value: link);
  }

  static Future<void> saveLinkedInLink(String link) async {
    await CacheHelper.setData(key: _linkedinKey, value: link);
  }

  static Future<void> saveGitHubLink(String link) async {
    await CacheHelper.setData(key: _githubKey, value: link);
  }

  // Get social media links from cache
  static String? getFacebookLink() {
    return CacheHelper.getData(key: _facebookKey);
  }

  static String? getBehanceLink() {
    return CacheHelper.getData(key: _behanceKey);
  }

  static String? getLinkedInLink() {
    return CacheHelper.getData(key: _linkedinKey);
  }

  static String? getGitHubLink() {
    return CacheHelper.getData(key: _githubKey);
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
    await CacheHelper.removeData(key: _facebookKey);
    await CacheHelper.removeData(key: _behanceKey);
    await CacheHelper.removeData(key: _linkedinKey);
    await CacheHelper.removeData(key: _githubKey);
  }
} 