import 'package:flutter/material.dart';

Widget buildInfoContainer({
  required String header,
  String? text,
  String? name,
  String? phone,
  String? email,
  String? governorate,
  String? title,
}) {
  // List to store widgets
  List<Widget> widgetList = [];

  // Add 'text' if it is not null or empty
  if (text != null && text.isNotEmpty) {
    widgetList.add(
      Text(
        text,
        style: const TextStyle(fontSize: 16, color: Color(0xFF02457A)),
      ),
    );
  }

  // Add 'name' if it is not null or empty
  if (name != null && name.isNotEmpty) {
    widgetList.add(
      Text("Name: $name",
          style: const TextStyle(fontSize: 16, color: Color(0xFF02457A))),
    );
  }

  // Add 'phone' if it is not null or empty
  if (phone != null && phone.isNotEmpty) {
    widgetList.add(
      Text("Phone: $phone",
          style: const TextStyle(fontSize: 16, color: Color(0xFF02457A))),
    );
  }

  // Add 'email' if it is not null or empty
  if (email != null && email.isNotEmpty) {
    widgetList.add(
      Text("Email: $email",
          style: const TextStyle(fontSize: 16, color: Color(0xFF02457A))),
    );
  }

  // Add 'governorate' if it is not null or empty
  if (governorate != null && governorate.isNotEmpty) {
    widgetList.add(
      Text("Governorate: $governorate",
          style: const TextStyle(fontSize: 16, color: Color(0xFF02457A))),
    );
  }

  // Add 'title' if it is not null or empty
  if (title != null && title.isNotEmpty) {
    widgetList.add(
      Text("Title: $title",
          style: const TextStyle(fontSize: 16, color: Color(0xFF02457A))),
    );
  }
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFF02457A), width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              header,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF02457A),
              ),
            ),
            IconButton(
              onPressed: () {
                // Action for Edit button
              },
              icon: const Icon(Icons.edit, color: Color(0xFF02457A)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...widgetList,
        // Text(
        //   "Name: $name\nPhone: $phone\nEmail: $email\nGovernorate: $governorate\nTitle: $title\nText: $text",
        //   style: const TextStyle(fontSize: 16, color: Color(0xFF02457A)),
        // ),
      ],
    ),
  );
}
