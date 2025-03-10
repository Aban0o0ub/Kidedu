import 'package:flutter/material.dart';

class SimpleSettingsTile extends StatelessWidget {
  final String title;

  final VoidCallback onTap;

  const SimpleSettingsTile({
    super.key,
    required this.title,
   
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500,color: Colors.red,decoration: TextDecoration.underline, // ✅ إضافة خط تحت النص
          decorationColor: Colors.red, // ✅ لون الخط نفس لون النص
          decorationThickness: 1,)),
      onTap: onTap,
    );
  }
}

