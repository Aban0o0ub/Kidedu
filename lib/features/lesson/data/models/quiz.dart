class AddQuizRequest {
  final String lessonId;
  final String title;
  final int passingScore;
  final int timeLimit;
  final List<QuestionRequest> questions;

  AddQuizRequest({
    required this.lessonId,
    required this.title,
    required this.passingScore,
    required this.timeLimit,
    required this.questions,
  });

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'title': title,
      'passingScore': passingScore,
      'timeLimit': timeLimit,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class QuestionRequest {
  final String questionText;
  final String questionType;
  final int points;
  final List<OptionRequest> options;

  QuestionRequest({
    required this.questionText,
    required this.questionType,
    required this.points,
    required this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'questionType': questionType,
      'points': points,
      'options': options.map((o) => o.toJson()).toList(),
    };
  }
}

class OptionRequest {
  final int id;
  final String text;
  final bool isCorrect;

  OptionRequest({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCorrect': isCorrect,
    };
  }
}
class AddQuizResponse {
  final String status;
  final String message;
  final Quiz quiz;

  AddQuizResponse({
    required this.status,
    required this.message,
    required this.quiz,
  });

  factory AddQuizResponse.fromJson(Map<String, dynamic> json) {
    return AddQuizResponse(
      status: json['status'],
      message: json['message'],
      quiz: Quiz.fromJson(json['data']['quiz']),
    );
  }
}

class Quiz {
  final String quizId;
  final String title;
  final String lessonId;
  final String instructorId;
  final int passingScore;
  final int timeLimit;
  final List<Question> questions;

  Quiz({
    required this.quizId,
    required this.title,
    required this.lessonId,
    required this.instructorId,
    required this.passingScore,
    required this.timeLimit,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      quizId: json['quizId'],
      title: json['title'],
      lessonId: json['lessonId'],
      instructorId: json['instructorId'],
      passingScore: json['passingScore'],
      timeLimit: json['timeLimit'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}

class Question {
  final String questionId;
  final String questionText;
  final String questionType;
  final int points;
  final List<Option> options;

  Question({
    required this.questionId,
    required this.questionText,
    required this.questionType,
    required this.points,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'],
      questionText: json['questionText'],
      questionType: json['questionType'],
      points: json['points'],
      options: (json['options'] as List)
          .map((o) => Option.fromJson(o))
          .toList(),
    );
  }
}

class Option {
  final String optionId;
  final int id;
  final String text;
  final bool isCorrect;

  Option({
    required this.optionId,
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      optionId: json['optionId'],
      id: json['id'],
      text: json['text'],
      isCorrect: json['isCorrect'],
    );
  }
}
////////////////////////////////////////////////////////////////////////
class SubmitQuizRequest {
  final String quizId;
  final List<AnswerRequest> answers;

  SubmitQuizRequest({
    required this.quizId,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

class AnswerRequest {
  final String questionId;
  final int answer;

  AnswerRequest({
    required this.questionId,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answer': answer,
    };
  }
}
class SubmitQuizResponse {
  final String status;
  final SubmitQuizResult data;

  SubmitQuizResponse({
    required this.status,
    required this.data,
  });

  factory SubmitQuizResponse.fromJson(Map<String, dynamic> json) {
    return SubmitQuizResponse(
      status: json['status'],
      data: SubmitQuizResult.fromJson(json['data']),
    );
  }
}

class SubmitQuizResult {
  final int score;
  final bool passed;
  final List<QuestionResult> results;

  SubmitQuizResult({
    required this.score,
    required this.passed,
    required this.results,
  });

  factory SubmitQuizResult.fromJson(Map<String, dynamic> json) {
    return SubmitQuizResult(
      score: json['score'],
      passed: json['passed'],
      results: (json['results'] as List)
          .map((r) => QuestionResult.fromJson(r))
          .toList(),
    );
  }
}

class QuestionResult {
  final String questionId;
  final bool isCorrect;

  QuestionResult({
    required this.questionId,
    required this.isCorrect,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionId: json['questionId'],
      isCorrect: json['isCorrect'],
    );
  }
}
class QuestionFormData {
  String questionText;
  String questionType;
  int points;
  List<OptionFormData> options;

  QuestionFormData({
    this.questionText = '',
    this.questionType = 'multiple-choice',
    this.points = 1,
    List<OptionFormData>? options,
  }) : options = options ?? [
    OptionFormData(id: 1),
    OptionFormData(id: 2),
  ];

  QuestionRequest toQuestionRequest() {
    return QuestionRequest(
      questionText: questionText,
      questionType: questionType,
      points: points,
      options: options.map((o) => o.toOptionRequest()).toList(),
    );
  }
}

class OptionFormData {
  int id;
  String text;
  bool isCorrect;

  OptionFormData({
    required this.id,
    this.text = '',
    this.isCorrect = false,
  });

  OptionRequest toOptionRequest() {
    return OptionRequest(
      id: id,
      text: text,
      isCorrect: isCorrect,
    );
  }
}
//////////////////////////////////////////////////////////////////////////////////////
class GetQuizzesResponse {
  final bool success;
  final List<QuizListItem> quizzes;

  GetQuizzesResponse({
    required this.success,
    required this.quizzes,
  });

  factory GetQuizzesResponse.fromJson(Map<String, dynamic> json) {
    return GetQuizzesResponse(
      success: json['success'] ?? false,
      quizzes: (json['quizzes'] as List? ?? [])
          .map((q) => QuizListItem.fromJson(q))
          .toList(),
    );
  }
}

// نموذج عنصر الكويز في القائمة
class QuizListItem {
  final String id;
  final String title;
  final String lessonId;
  final String instructorId;
  final List<QuizQuestion> questions;
  final int passingScore;
  final int timeLimit;
  final List<dynamic> attempts;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  QuizListItem({
    required this.id,
    required this.title,
    required this.lessonId,
    required this.instructorId,
    required this.questions,
    required this.passingScore,
    required this.timeLimit,
    required this.attempts,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory QuizListItem.fromJson(Map<String, dynamic> json) {
    return QuizListItem(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      lessonId: json['lessonId'] ?? '',
      instructorId: json['instructorId'] ?? '',
      questions: (json['questions'] as List? ?? [])
          .map((q) => QuizQuestion.fromJson(q))
          .toList(),
      passingScore: json['passingScore'] ?? 0,
      timeLimit: json['timeLimit'] ?? 0,
      attempts: json['attempts'] ?? [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      version: json['__v'] ?? 0,
    );
  }
}

class QuizQuestion {
  final String id;
  final String questionText;
  final String questionType;
  final List<QuizOption> options;
  final int points;

  QuizQuestion({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.options,
    required this.points,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['_id'] ?? '',
      questionText: json['questionText'] ?? '',
      questionType: json['questionType'] ?? '',
      options: (json['options'] as List? ?? [])
          .map((o) => QuizOption.fromJson(o))
          .toList(),
      points: json['points'] ?? 0,
    );
  }
}

class QuizOption {
  final String id;
  final int optionId;
  final String text;
  final bool isCorrect;

  QuizOption({
    required this.id,
    required this.optionId,
    required this.text,
    required this.isCorrect,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['_id'] ?? '',
      optionId: json['id'] ?? 0,
      text: json['text'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
    );
  }
}