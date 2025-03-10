import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'appbar.dart';

class ConditionsPage extends StatefulWidget {


  const ConditionsPage({super.key,});

  @override
  // ignore: library_private_types_in_public_api
  _ConditionsPageState createState() => _ConditionsPageState();
}

class _ConditionsPageState extends State<ConditionsPage> {
  String content = "Loading..."; 

  @override
  void initState() {
    super.initState();
    _loadPolicy();
  }

  // تحميل محتوى الملف من assets
  Future<void> _loadPolicy() async {
    try {
      final text = await rootBundle.loadString("assets/pii/terms_conditions.md");
      setState(() {
        content = text;
      });
    } catch (e) {
      setState(() {
        content = "Error loading document.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Terms & Conditions',), // استخدام الـ AppBar المخصص
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(
  data: content,
  styleSheet: MarkdownStyleSheet.fromTheme(
    Theme.of(context).copyWith(
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: 18), // تحديد حجم الخط للنص العادي
      ),
    ),
  ),
),

      ),
    );
  }
}
