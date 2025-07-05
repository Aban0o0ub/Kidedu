import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import '../../../home/ui/views/home_page.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Image.asset('assets/images/emptycart.jpg', height: 400, width: 400),
          SizedBox(height: 30),
          Text(
            "Your cart is empty!",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 180),
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              context.push(
                Routes.homePage,
                extra: {
                  'courseTitles': HomePage.courseTitles,
                  'backgroundImages': HomePage.backgroundImages,
                  'iconImages': HomePage.iconImages,
                },
              );
            },
            child: Text(
              "Explore now",
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
