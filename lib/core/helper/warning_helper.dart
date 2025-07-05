import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'cache_helper.dart';

class WarningHelper {
  static const String _courseEndWarningKey = 'course_end_warning_shown';

  static Future<void> showCourseEndWarningIfNeeded(BuildContext context) async {
    final bool hasShownWarning = CacheHelper.getData(key: _courseEndWarningKey) ?? false;
    
    if (!hasShownWarning) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            "Important Notice".tr(),
            style: const TextStyle(
              color: Color(0xFF02457A),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Don't forget to end the course after completing your content to make it visible to children.".tr(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "I understand".tr(),
                style: const TextStyle(
                  color: Color(0xFF02457A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );

      await CacheHelper.setData(key: _courseEndWarningKey, value: true);
    }
  }

  static Future<void> resetWarnings() async {
    await CacheHelper.removeData(key: _courseEndWarningKey);
  }
} 