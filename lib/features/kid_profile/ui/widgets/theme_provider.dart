import 'package:flutter/material.dart';
import 'package:loginpage/core/helper/cache_helper.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = CacheHelper.getData(key: 'isDarkMode') ?? false;
  
  bool get isDarkMode => _isDarkMode;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode; // Fixed: removed asterisks
    CacheHelper.setData(key: 'isDarkMode', value: _isDarkMode);
    notifyListeners();
  }
  
  void setThemeValue(bool value) {
    _isDarkMode = value;
    _saveThemePreference(); // Save preference
    notifyListeners(); // Notify listeners after saving
  }
  
  // Added the missing method
  void _saveThemePreference() {
    CacheHelper.setData(key: 'isDarkMode', value: _isDarkMode);
  }
}

