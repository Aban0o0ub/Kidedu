import '../../../../core/networking/web_services.dart';
import '../models/quiz.dart';

class QuizRepo {
  final WebServices webServices;

  QuizRepo(this.webServices);

  Future<AddQuizResponse> addQuiz(AddQuizRequest newQuiz) async {
    return await webServices.addQuiz(newQuiz);
  }

  Future<SubmitQuizResponse> submitQuiz(SubmitQuizRequest submitQuiz) async {
    return await webServices.submitQuiz(submitQuiz);
  } 

Future<GetQuizzesResponse> getQuizzes(String lessonId) async {
    return await webServices.getQuizzes(lessonId);
  } 
}
