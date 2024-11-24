import 'package:dio/dio.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import 'package:retrofit/retrofit.dart';
part 'web_services.g.dart';

@RestApi(baseUrl: 'http://localhost:3000/api/')
abstract class WebServices {
  factory WebServices(Dio dio, {String? baseUrl}) = _WebServices;

  @GET('user_kid')
  Future<List<Kid>> getAllKids();
}
