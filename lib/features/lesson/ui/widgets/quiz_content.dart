import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/lesson.dart';
import '../../data/models/quiz.dart';
import '../../logic/cubit/quiz_cubit.dart';

class QuizContent extends StatefulWidget {
  final LessonModel lesson;
  final QuizCubit? quizCubit;

  const QuizContent({
    super.key,
    required this.lesson,
    this.quizCubit,
  });

  @override
  State<QuizContent> createState() => _QuizContentState();
}

class _QuizContentState extends State<QuizContent> {
  int currentQuestionIndex = 0;
  Map<String, int> selectedAnswers = {};
  bool isQuizStarted = false;
  QuizListItem? selectedQuiz;

  @override
  void initState() {
    super.initState();
    context.read<QuizCubit>().emitGetQuizzes(widget.lesson.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: _buildContentContainer(),
          ),
        ],
      ),
    );
  }

 
  Widget _buildContentContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xff02457A), width: 1),
      ),
      child: BlocConsumer<QuizCubit, QuizState>(
        listener: (context, state) {
          if (state is SubmitQuizSuccess) {
            _showResultDialog(state.submitQuiz.data);
          } else if (state is SubmitQuizFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetQuizzesLoading) {
            return _buildLoading();
          }

          if (state is GetQuizzesFailure) {
            return _buildErrorMessage(state.error);
          }

          if (state is GetQuizzesSuccess) {
            if (state.quizzes.isEmpty) {
              return _buildNoQuizMessage();
            }

            if (selectedQuiz == null) {
              selectedQuiz = state.quizzes.first;
            }

            return _buildQuizContent(state.quizzes);
          }

          if (state is SubmitQuizLoading) {
            return _buildLoading(message: "Submitting your answers...");
          }

          return _buildNoQuizMessage();
        },
      ),
    );
  }

  Widget _buildLoading({String message = "Loading quiz..."}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff02457A)),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff02457A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizContent(List<QuizListItem> quizzes) {
    if (selectedQuiz == null) return _buildNoQuizMessage();

    if (!isQuizStarted) {
      return _buildQuizSelection(quizzes);
    }

    return _buildQuizQuestions();
  }

  Widget _buildQuizSelection(List<QuizListItem> quizzes) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Quiz icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Color(0xff02457A),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('🎯', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 24),

          // Quiz dropdown if multiple quizzes
          if (quizzes.length > 1) ...[
            Text(
              'Choose Your Quiz',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff02457A),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xff02457A)),
              ),
              child: DropdownButtonFormField<QuizListItem>(
                value: selectedQuiz,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                items: quizzes.map((quiz) {
                  return DropdownMenuItem<QuizListItem>(
                    value: quiz,
                    child: Text(quiz.title),
                  );
                }).toList(),
                onChanged: (QuizListItem? newQuiz) {
                  setState(() {
                    selectedQuiz = newQuiz;
                    currentQuestionIndex = 0;
                    selectedAnswers.clear();
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Quiz title
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xff02457A)),
            ),
            child: Text(
              selectedQuiz!.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff02457A),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          // Quiz info cards
          Row(
            children: [
              Expanded(
                  child: _buildInfoCard('Questions',
                      selectedQuiz!.questions.length.toString(), '📝')),
              SizedBox(width: 12),
              Expanded(
                  child: _buildInfoCard(
                      'Time', '${selectedQuiz!.timeLimit} min', '⏰')),
              SizedBox(width: 12),
              Expanded(
                  child: _buildInfoCard(
                      'Pass Score', '${selectedQuiz!.passingScore}%', '🏆')),
            ],
          ),

          const SizedBox(height: 32),

          // Start button
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isQuizStarted = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff02457A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🚀', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 12),
                  Text(
                    'Start Quiz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, String emoji) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xff02457A)),
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 18)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff02457A),
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizQuestions() {
    if (selectedQuiz == null) return _buildNoQuizMessage();

    final currentQuestion = selectedQuiz!.questions[currentQuestionIndex];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xff02457A)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1} of ${selectedQuiz!.questions.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff02457A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('🎯', style: TextStyle(fontSize: 18)),
                  ],
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) /
                        selectedQuiz!.questions.length,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff02457A)),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Question text
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xff02457A)),
            ),
            child: Text(
              currentQuestion.questionText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff02457A),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Options
          ...currentQuestion.options.map((option) {
            final isSelected =
                selectedAnswers[currentQuestion.id] == option.optionId;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedAnswers[currentQuestion.id] = option.optionId;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xff02457A).withOpacity(0.1) : Colors.white,
                    border: Border.all(
                      color: Color(0xff02457A),
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Color(0xff02457A) : Colors.transparent,
                          border: Border.all(
                            color: Color(0xff02457A),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option.text,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Color(0xff02457A) : Colors.black87,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 30),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentQuestionIndex > 0)
                Container(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentQuestionIndex--;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 16),
                        SizedBox(width: 8),
                        Text('Previous'),
                      ],
                    ),
                  ),
                )
              else
                const SizedBox(),
              Container(
                height: 45,
                child: ElevatedButton(
                  onPressed: selectedAnswers[currentQuestion.id] != null
                      ? () {
                          if (currentQuestionIndex <
                              selectedQuiz!.questions.length - 1) {
                            setState(() {
                              currentQuestionIndex++;
                            });
                          } else {
                            _submitQuiz();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedAnswers[currentQuestion.id] != null
                        ? Color(0xff02457A)
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentQuestionIndex < selectedQuiz!.questions.length - 1
                            ? 'Next'
                            : 'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        currentQuestionIndex < selectedQuiz!.questions.length - 1
                            ? Icons.arrow_forward
                            : Icons.send,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _submitQuiz() {
    if (selectedQuiz == null) return;

    final answers = selectedAnswers.entries.map((entry) {
      return AnswerRequest(
        questionId: entry.key,
        answer: entry.value,
      );
    }).toList();

    final request = SubmitQuizRequest(
      quizId: selectedQuiz!.id,
      answers: answers,
    );

    context.read<QuizCubit>().emitSubmitQuiz(request);
  }

  void _showResultDialog(SubmitQuizResult result) {
    if (selectedQuiz == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xff02457A), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Result icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: result.passed ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    result.passed ? '🎉' : '💪',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Result title
              Text(
                result.passed ? 'Congratulations!' : 'Keep Trying!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff02457A),
                ),
              ),
              const SizedBox(height: 16),

              // Score display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xff02457A), width: 2),
                ),
                child: Text(
                  'Your Score: ${result.score}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff02457A),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Result message
              Text(
                result.passed
                    ? 'You have passed the quiz! 🏆'
                    : 'You need ${selectedQuiz!.passingScore}% to pass. Try again! 📚',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Action button
              Container(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      isQuizStarted = false;
                      currentQuestionIndex = 0;
                      selectedAnswers.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff02457A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    result.passed ? 'Continue Learning!' : 'Try Again!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoQuizMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('📝', style: TextStyle(fontSize: 30)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No Quiz Available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "There's no quiz for this lesson yet.\nCheck back later!",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('⚠️', style: TextStyle(fontSize: 30)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Something went wrong",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                context.read<QuizCubit>().emitGetQuizzes(widget.lesson.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff02457A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}