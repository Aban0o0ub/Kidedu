import 'package:flutter/material.dart';
import 'package:loginpage/core/helper/cache_helper.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = CacheHelper.getData(key: 'isDarkMode') ?? false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    CacheHelper.setData(key: 'isDarkMode', value: _isDarkMode); 
    notifyListeners();
  }
}
