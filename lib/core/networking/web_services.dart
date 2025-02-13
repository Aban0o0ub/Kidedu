import 'package:dio/dio.dart';
import 'package:loginpage/core/helper/cache_helper.dart';
import 'package:loginpage/features/add_course/data/models/add_course.dart';
import 'package:loginpage/features/login/data/models/user.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

class WebServices {
  final Dio dio;

  WebServices(this.dio);

  Future<KidResponse> createNewKid(NewKid newKid) async {
    try {
      final response = await dio.post(
        'user_kid',
        data: newKid.toJson(),
      );
      KidResponse kid = KidResponse.fromJson(response.data);
      CacheHelper.setData(key: "token", value: kid.data!.token);
      CacheHelper.setData(key: "kidId", value: kid.data!.newKid!.sId);
      print(CacheHelper.getData(key: "token"));
      return kid;
    } catch (e) {
      throw Exception('Error creating new kid: ${e.toString()}');
    }
  }

  Future<Instructor> createNewInstructor(Instructor newInstructor) async {
    try {
      final response = await dio.post(
        'user_instructor',
        data: newInstructor.toJson(),
      );
      return Instructor.fromJson(response.data);
    } catch (e) {
      throw Exception('Error creating new instructor: ${e.toString()}');
    }
  }

  Future<User> loginUserKid(User loginKid) async {
    try {
      final response = await dio.post(
        'user_kid/login',
        data: loginKid.toJson(),
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Error logging in as kid: ${e.toString()}');
    }
  }

  Future<User> loginUserInstructor(User loginInstructor) async {
    try {
      final response = await dio.post(
        'user_instructor/login',
        data: loginInstructor.toJson(),
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Error logging in as instructor: ${e.toString()}');
    }
  }

  Future<NewKid> getKidById(String kidId) async {
    try {
      String token = CacheHelper.getData(key: "token");
      final response = await dio.get(
        'user_kid/$kidId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final kidResponse = KidResponse.fromJson(response.data);
      return kidResponse.data!.newKid!;
    } catch (e) {
      throw Exception('Error fetching kid by ID: ${e.toString()}');
    }
  }

  Future<KidResponse> updateKidProfile(
      String kidId, KidResponse kidData, String token) async {
    try {
      final response = await dio.post(
        'user_kid/$kidId',
        data: kidData.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return KidResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error updating kid profile: ${e.toString()}');
    }
  }

  Future<Instructor> getInstructorById(
      String instructorId, String token) async {
    try {
      final response = await dio.get(
        'user_instructor/$instructorId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return Instructor.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching instructor by ID: ${e.toString()}');
    }
  }

  Future<Instructor> updateInstructorProfile(String instructorId,
      Map<String, dynamic> instructorData, String token) async {
    try {
      final response = await dio.post(
        'user_instructor/$instructorId',
        data: instructorData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return Instructor.fromJson(response.data);
    } catch (e) {
      throw Exception('Error updating instructor profile: ${e.toString()}');
    }
  }

  Future<CourseModel> addNewCourse(CourseModel newCourse, String token) async {
    try {
      final response = await dio.post(
        'course',
        data: newCourse.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return CourseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error creating new course: ${e.toString()}');
    }
  }

  Future<CourseModel> getCourseById(int courseId, String token) async {
    try {
      final response = await dio.get(
        'course/$courseId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return CourseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching course by ID: ${e.toString()}');
    }
  }
}
