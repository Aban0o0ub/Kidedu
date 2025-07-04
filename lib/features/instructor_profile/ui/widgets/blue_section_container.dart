import 'package:flutter/material.dart';

class BlueSectionContainer extends StatelessWidget {
  final String title;
  final Widget content;
  final Widget? actionIcon;
  
  const BlueSectionContainer({
    super.key,
    required this.title,
    required this.content,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // البوكس الخلفي الذي يغطي كل شيء
        Container(
          width: double.infinity, 
          margin: const EdgeInsets.only(top: 15), 
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF02457A),
                const Color(0xFF0A5999),
                const Color(0xFF02457A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16), // الزوايا المدورة
           
          ),
          child: Stack(
            children: [
              // دوائر ديكور صغيرة في الخلفية
              Positioned(
                top: 20,
                right: 30,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 20,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 80,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              // خطوط ديكور رفيعة
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100), // حد أدنى للارتفاع
            ],
          ),
        ),
        
        // المحتوى فوق البوكس
        Column(
          children: [
            // Header مع العنوان والأيقونات
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white, // أبيض لأنها فوق البوكس الأزرق
                    ),
                  ),
                  if (actionIcon != null) actionIcon!,
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // محتوى القسم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: content,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
} 