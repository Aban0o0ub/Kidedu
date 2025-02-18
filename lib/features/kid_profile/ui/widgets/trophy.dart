import 'package:flutter/material.dart';

class TrophyWidget extends StatelessWidget {
  final Map<String, dynamic> trophy;
  
  const TrophyWidget({super.key, required this.trophy});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF02457A)),
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              trophy['image'],
              height: 100,
              width: 100, 
              fit: BoxFit.cover, 
            ),
          ),
          SizedBox(height: 10),
          Text(
            trophy['title'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("from ${trophy['points']} points"),
        ],
      ),
    );
  }
}