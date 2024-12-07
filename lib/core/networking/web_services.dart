import 'package:dio/dio.dart';
import 'package:loginpage/features/login/data/models/user.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import 'package:retrofit/retrofit.dart';
part 'web_services.g.dart';

@RestApi(baseUrl: 'http://192.168.1.6:3000/api/')
abstract class WebServices {
  factory WebServices(Dio dio, {String? baseUrl}) = _WebServices;

  // @GET('user_kid')
  // Future<List<Kid>> getAllKids();

  @POST('user_kid')
  Future<Kid> createNewKid(@Body() Kid newkid);

  @POST('user_instructor')
  Future<Instructor> createNewInstructor(@Body() Instructor newinstructor);

  @POST('user_kid/login')
  Future<User> loginUserKid(@Body() User loginkid);

  @POST('user_instructor/login')
  Future<User> loginUserInstructor(@Body() User logininstructor);

  @GET('user_kid/{kidId}')
  Future<Kid> getKidById(@Path('_id') int kidId);

  @POST('user_kid/{kidId}')
  Future<Kid> updateKidProfile(
      @Path('_id') int kidId, @Body() Map<String, dynamic> kidData);

  @GET('user_instructor/{instructorId}')
  Future<Instructor> getInstructorById(@Path('_id') int instructorId);

  @POST('user_instructor/{instructorId}')
  Future<Instructor> updateInstructorProfile(@Path('_id') int instructorId,
      @Body() Map<String, dynamic> instructorData);
}
