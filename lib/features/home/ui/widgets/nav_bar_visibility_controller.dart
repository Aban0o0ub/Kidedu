import 'package:flutter/material.dart';

// class NavBarVisibilityController {
//   static final ValueNotifier<bool> isNavBarVisible = ValueNotifier<bool>(true);

//   static void showNavBar() {
//     isNavBarVisible.value = true;
//   }

//   static void hideNavBar() {
//     isNavBarVisible.value = false;
//   }
// }
class NavBarVisibilityController {
  static final ValueNotifier<bool> isNavBarVisible = ValueNotifier<bool>(true);

  static void showNavBar() {
    // Ensure that this is done after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isNavBarVisible.value = true;
    });
  }

  static void hideNavBar() {
    // Ensure that this is done after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isNavBarVisible.value = false;
    });
  }
}
