import 'package:flutter/material.dart';

class SearchResultsList extends StatelessWidget {
  final List<String> results;

  const SearchResultsList({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Text(
          "No results found",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          leading: Icon(Icons.school, color: Colors.blue[900]),
        );
      },
    );
  }
}
