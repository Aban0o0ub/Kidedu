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
    // جلب الكويزات عند تحميل الصفحة
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
          _buildSectionHeader(),
          const SizedBox(height: 12),
          Expanded(
            child: _buildContentContainer(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff02457A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "Quiz",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContentContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
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
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetQuizzesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetQuizzesFailure) {
            return _buildErrorMessage(state.error);
          }

          if (state is GetQuizzesSuccess) {
            if (state.quizzes.isEmpty) {
              return _buildNoQuizMessage();
            }

            // إذا لم يتم اختيار كويز بعد، اختر الأول
            if (selectedQuiz == null) {
              selectedQuiz = state.quizzes.first;
            }

            return _buildQuizContent(state.quizzes);
          }

          // إذا كان في submit loading، اظهر loading
          if (state is SubmitQuizLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return _buildNoQuizMessage();
        },
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.quiz,
          size: 64,
          color: const Color(0xff02457A),
        ),
        const SizedBox(height: 20),
        
        // إذا كان عندنا أكتر من كويز، اظهر dropdown للاختيار
        if (quizzes.length > 1) ...[
          Text(
            'Select Quiz',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<QuizListItem>(
            value: selectedQuiz,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          const SizedBox(height: 20),
        ],

        Text(
          selectedQuiz!.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            children: [
              _buildQuizInfo('Questions', selectedQuiz!.questions.length.toString()),
              const SizedBox(height: 8),
              _buildQuizInfo('Time Limit', '${selectedQuiz!.timeLimit} minutes'),
              const SizedBox(height: 8),
              _buildQuizInfo('Passing Score', '${selectedQuiz!.passingScore}%'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isQuizStarted = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff02457A),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Start Quiz',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizInfo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

 Widget _buildQuizQuestions() {
  if (selectedQuiz == null) return _buildNoQuizMessage();
  
  final currentQuestion = selectedQuiz!.questions[currentQuestionIndex];

  return SingleChildScrollView(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / selectedQuiz!.questions.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xff02457A)),
          ),
          const SizedBox(height: 16),

          // Question counter
          Text(
            'Question ${currentQuestionIndex + 1} of ${selectedQuiz!.questions.length}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // Question text
          Text(
            currentQuestion.questionText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Options
          ...currentQuestion.options.map((option) {
            final isSelected = selectedAnswers[currentQuestion.id] == option.optionId;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedAnswers[currentQuestion.id] = option.optionId;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xff02457A).withOpacity(0.1)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xff02457A)
                          : Colors.grey[300]!,
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
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xff02457A)
                                : Colors.grey[400]!,
                            width: 2,
                          ),
                          color: isSelected
                              ? const Color(0xff02457A)
                              : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option.text,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected
                                ? const Color(0xff02457A)
                                : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
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
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentQuestionIndex--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                  ),
                  child: const Text('Previous'),
                )
              else
                const SizedBox(),
              ElevatedButton(
                onPressed: selectedAnswers[currentQuestion.id] != null
                    ? () {
                        if (currentQuestionIndex < selectedQuiz!.questions.length - 1) {
                          setState(() {
                            currentQuestionIndex++;
                          });
                        } else {
                          _submitQuiz();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff02457A),
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  currentQuestionIndex < selectedQuiz!.questions.length - 1
                      ? 'Next'
                      : 'Submit Quiz',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
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
      builder: (context) => AlertDialog(
        title: Text(
          result.passed ? 'Congratulations!' : 'Quiz Failed',
          style: TextStyle(
            color: result.passed ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              result.passed ? Icons.check_circle : Icons.cancel,
              size: 64,
              color: result.passed ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score: ${result.score}%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              result.passed
                  ? 'You have passed the quiz!'
                  : 'You need ${selectedQuiz!.passingScore}% to pass.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                isQuizStarted = false;
                currentQuestionIndex = 0;
                selectedAnswers.clear();
              });
            },
            child: Text(result.passed ? 'Continue' : 'Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoQuizMessage() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "No quiz available for this lesson",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String error) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            "Error loading quizzes",
            style: TextStyle(
              fontSize: 16,
              color: Colors.red[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<QuizCubit>().emitGetQuizzes(widget.lesson.id);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}