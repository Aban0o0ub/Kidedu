import '../../../../core/helper/cache_helper.dart';
import '../../../../core/networking/web_services.dart';
import '../models/quiz.dart';

class QuizRepo {
  final WebServices webServices;

  QuizRepo(this.webServices);

  Future<AddQuizResponse> addQuiz(AddQuizRequest newQuiz) async {
    return await webServices.addQuiz(newQuiz);
  }

  Future<SubmitQuizResponse> submitQuiz(SubmitQuizRequest submitQuiz) async {
    String? token = await CacheHelper.getData(key: "token");

    if (token == null) {
      throw Exception('Token is missing');
    }

    return await webServices.submitQuiz(submitQuiz);
  } 
}
