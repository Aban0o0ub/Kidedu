import 'package:flutter/material.dart';
import 'package:loginpage/features/home/ui/widgets/home.dart';
import '../../../../core/widgets/arrow_back.dart';
import 'home_page.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool hasCourses = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ArrowBack(),
          if (!hasCourses) EmptyCartView(),
        ],
      ),
    );
  }
}

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
          ),
          Image.asset('assets/images/emptycart.jpg', height: 400, width: 400),
          Text(
            "Your cart is empty !",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF02457A),
            ),
          ),
          SizedBox(height: 180),
          TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(
          courseTitles: HomePage.courseTitles,
          backgroundImages: HomePage.backgroundImages,
          iconImages: HomePage.iconImages,
        ),
      ),
    ).then((_) {
      FocusScope.of(context).unfocus();
    });
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

class CourseListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> courses = [
    {
      'image': 'assets/images/swimming.jpg',
      'name': 'Arabic',
      'instructor': 'Marena Safwat',
      'status': 'Online',
      'price': '\$49.99',
    },
    {
      'image': 'assets/images/science.jpg',
      'name': 'English',
      'instructor': 'Mirna Hanna',
      'status': 'Offline',
      'price': '\$79.99',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      // padding: EdgeInsets.all(16),
       children: [
      //   Image.asset('assets/images/cart.jpg', width: 352, height: 244, fit: BoxFit.cover),
      //   SizedBox(height: 16),
        ...courses.map((course) => CourseCard(course)).toList(),
       ],
    );
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  CourseCard(this.course);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(course['image'], height: 148, width: 165, fit: BoxFit.cover),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['name'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF02457A)),
                  ),
                  Text("By ${course['instructor']}", style: TextStyle(fontSize: 16, color: Color(0xFF02457A))),
                  Text(
                    course['status'],
                    style: TextStyle(
                      fontSize: 16,
                      color: course['status'] == 'Online' ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    course['price'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF02457A)),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print("Buying ${course['name']}");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF02457A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text("Buy Now", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// class BottomNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;
//   BottomNavBar({required this.selectedIndex, required this.onItemTapped});

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: Color(0xFF02457A),
//       selectedItemColor: Colors.white,
//       unselectedItemColor: Colors.white70,
//       showSelectedLabels: false,
//       showUnselectedLabels: false,
//       currentIndex: selectedIndex,
//       onTap: onItemTapped,
//       items: [
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
//         BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
//         BottomNavigationBarItem(icon: Icon(Icons.shop_two), label: ""),
//         BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
//       ],
//     );
//   }
// }
