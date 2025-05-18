import 'package:flutter/material.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  String? _selectedOption;

  final List<Map<String, String>> _options = [
    {'label': 'A', 'text': '1/4'},
    {'label': 'B', 'text': '1/2'},
    {'label': 'C', 'text': '3/4'},
    {'label': 'D', 'text': '5/8'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 25, left: 25, right: 10),
      children: [
        const Text(
          "Quiz:-",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xff02457A),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Which of the following is the correct sum of the fractions 3/8 + 2/8?",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff02457A),
          ),
        ),
        const SizedBox(height: 10),
        ..._options.map((option) {
          return RadioListTile<String>(
            contentPadding: EdgeInsets.all(0),
            value: option['label']!,
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
            title: Text(
              '${option['label']}) ${option['text']}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xff02457A),
              ),
            ),
            activeColor: const Color(0xff02457A),
          );
        }).toList(),
      ],
    );
  }
}
