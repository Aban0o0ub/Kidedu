import 'package:flutter/material.dart';

class QuizOptionWidget extends StatefulWidget {
  final TextEditingController questionController;
  final List<TextEditingController> answerControllers;
  final List<String> answers;
  final String? selectedAnswer;
  final ValueChanged<String?> onAnswerChanged;

  const QuizOptionWidget({
    super.key,
    required this.questionController,
    required this.answerControllers,
    required this.answers,
    required this.selectedAnswer,
    required this.onAnswerChanged,
  });

  @override
  State<QuizOptionWidget> createState() => _QuizOptionWidgetState();
}

class _QuizOptionWidgetState extends State<QuizOptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiz:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF02457A),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: widget.questionController,
          decoration: InputDecoration(
            hintText: 'Enter question',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const Text(
          'Answers :-',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF02457A),
          ),
        ),
        const SizedBox(height: 15),
        for (int i = 0; i < 4; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextField(
              controller: widget.answerControllers[i],
              decoration: InputDecoration(
                hintText: 'answer ${i + 1}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        const Text(
          'Correct Answer :-',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          value: widget.selectedAnswer,
          hint: const Text('Select an answer'),
          items: widget.answers.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: widget.onAnswerChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}