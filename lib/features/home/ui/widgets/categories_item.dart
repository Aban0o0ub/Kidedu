import 'package:flutter/material.dart';

class CategoriesItem extends StatelessWidget {
  const CategoriesItem({
    super.key,
    required this.backgroundImage,
    required this.iconImage,
    required this.title,
    required this.onTap, required Null Function() onPressed,
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
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: Image.asset(
                backgroundImage,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      iconImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, right: 3),
                    child: Text(
                      title,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 18, 
                        color: Theme.of(context).primaryColor,
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
