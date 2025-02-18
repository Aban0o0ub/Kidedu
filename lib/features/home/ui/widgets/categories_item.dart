import 'package:flutter/material.dart';

class CategoriesItem extends StatelessWidget {
  const CategoriesItem({
    super.key,
    required this.backgroundImage,
    required this.iconImage,
    required this.title,
    required this.onTap,
  });

  final String backgroundImage;
  final String iconImage;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 110,
        width: 120,
        child: Stack(
          clipBehavior: Clip.hardEdge, // يمنع تجاوز المحتوى
          children: [
            Positioned.fill(
              child: Image.asset(
                backgroundImage,
                fit: BoxFit.cover, // يملأ الـ SizedBox بالكامل
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // محاذاة العناصر لليسار
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      iconImage,
                      fit: BoxFit.cover, // يجعل الأيقونة تتناسب مع الحجم المحدد
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, right: 3),
                    child: Text(
                      title,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 18, // تصغير الحجم قليلاً ليكون أكثر توازناً
                        color: Color(0xFF02457A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
