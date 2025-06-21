import 'package:flutter/material.dart';
import '../../data/models/quiz.dart';

class QuizOptionWidget extends StatefulWidget {
  final TextEditingController quizTitleController;
  final TextEditingController passingScoreController;
  final TextEditingController timeLimitController;
  final List<QuestionFormData> questions;
  final Function(List<QuestionFormData>) onQuestionsChanged;

  const QuizOptionWidget({
    super.key,
    required this.quizTitleController,
    required this.passingScoreController,
    required this.timeLimitController,
    required this.questions,
    required this.onQuestionsChanged,
  });

  @override
  State<QuizOptionWidget> createState() => _QuizOptionWidgetState();
}

class _QuizOptionWidgetState extends State<QuizOptionWidget> {
  void _addQuestion() {
    setState(() {
      widget.questions.add(QuestionFormData());
      widget.onQuestionsChanged(widget.questions);
    });
  }

  void _removeQuestion(int index) {
    if (widget.questions.length > 1) {
      setState(() {
        widget.questions.removeAt(index);
        widget.onQuestionsChanged(widget.questions);
      });
    }
  }

  void _addOption(int questionIndex) {
    setState(() {
      final question = widget.questions[questionIndex];
      final newId = question.options.length + 1;
      question.options.add(OptionFormData(id: newId));
      widget.onQuestionsChanged(widget.questions);
    });
  }

  void _removeOption(int questionIndex, int optionIndex) {
    setState(() {
      final question = widget.questions[questionIndex];
      if (question.options.length > 2) {
        question.options.removeAt(optionIndex);
        // Update IDs
        for (int i = 0; i < question.options.length; i++) {
          question.options[i].id = i + 1;
        }
        widget.onQuestionsChanged(widget.questions);
      }
    });
  }

  void _updateQuestionText(int index, String text) {
    widget.questions[index].questionText = text;
    widget.onQuestionsChanged(widget.questions);
  }

  void _updateOptionText(int questionIndex, int optionIndex, String text) {
    widget.questions[questionIndex].options[optionIndex].text = text;
    widget.onQuestionsChanged(widget.questions);
  }

  void _updateCorrectAnswer(int questionIndex, int optionIndex) {
    setState(() {
      final question = widget.questions[questionIndex];
      // Reset all options
      for (var option in question.options) {
        option.isCorrect = false;
      }
      // Set selected option as correct
      question.options[optionIndex].isCorrect = true;
      widget.onQuestionsChanged(widget.questions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiz Details:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF02457A),
          ),
        ),
        const SizedBox(height: 15),
        
        // Quiz Title
        TextField(
          controller: widget.quizTitleController,
          decoration: InputDecoration(
            labelText: 'Quiz Title',
            hintText: 'Enter quiz title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 15),
        
        // Passing Score and Time Limit
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.passingScoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Passing Score %',
                  hintText: '70',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: widget.timeLimitController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Time Limit (min)',
                  hintText: '30',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Questions Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Questions:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF02457A),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addQuestion,
              icon: const Icon(Icons.add),
              label: const Text('Add Question'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF02457A),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        
        // Questions List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.questions.length,
          itemBuilder: (context, questionIndex) {
            return _buildQuestionCard(questionIndex);
          },
        ),
      ],
    );
  }

  Widget _buildQuestionCard(int questionIndex) {
    final question = widget.questions[questionIndex];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${questionIndex + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.questions.length > 1)
                  IconButton(
                    onPressed: () => _removeQuestion(questionIndex),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            
            // Question Text
            TextField(
              onChanged: (text) => _updateQuestionText(questionIndex, text),
              decoration: InputDecoration(
                hintText: 'Enter question text',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // Points
            Row(
              children: [
                const Text('Points: '),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '1',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    onChanged: (value) {
                      question.points = int.tryParse(value) ?? 1;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            // Options
            const Text(
              'Options:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: question.options.length,
              itemBuilder: (context, optionIndex) {
                return _buildOptionRow(questionIndex, optionIndex);
              },
            ),
            
            // Add Option Button
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () => _addOption(questionIndex),
              icon: const Icon(Icons.add),
              label: const Text('Add Option'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow(int questionIndex, int optionIndex) {
    final option = widget.questions[questionIndex].options[optionIndex];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Correct Answer Radio
          Radio<int>(
            value: optionIndex,
            groupValue: widget.questions[questionIndex].options
                .indexWhere((o) => o.isCorrect),
            onChanged: (value) {
              if (value != null) {
                _updateCorrectAnswer(questionIndex, value);
              }
            },
          ),
          
          // Option Text
          Expanded(
            child: TextField(
              onChanged: (text) => _updateOptionText(questionIndex, optionIndex, text),
              decoration: InputDecoration(
                hintText: 'Option ${optionIndex + 1}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          
          // Remove Option Button
          if (widget.questions[questionIndex].options.length > 2)
            IconButton(
              onPressed: () => _removeOption(questionIndex, optionIndex),
              icon: const Icon(Icons.remove_circle, color: Colors.red),
            ),
        ],
      ),
    );
  }
}