import 'package:dio/dio.dart';
import 'package:loginpage/features/add_course/data/models/add_course.dart';
import 'package:loginpage/features/login/data/models/user.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

class WebServices {
  final Dio dio;

  WebServices(this.dio);

  Future<Kid> createNewKid(Kid newKid) async {
    try {
      final response = await dio.post(
        'user_kid',
        data: newKid.toJson(),
      );
      return Kid.fromJson(response.data);
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

  Future<Kid> getKidById(String kidId) async {
    try {
      final response = await dio.get('user_kid/$kidId');
      return Kid.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching kid by ID: ${e.toString()}');
    }
  }

  Future<Kid> updateKidProfile(String kidId, Kid kidData) async {
    try {
      final response = await dio.post(
        'user_kid/$kidId',
        data: kidData.toJson(),
      );
      return Kid.fromJson(response.data);
    } catch (e) {
      throw Exception('Error updating kid profile: ${e.toString()}');
    }
  }

  Future<Instructor> getInstructorById(int instructorId) async {
    try {
      final response = await dio.get('user_instructor/$instructorId');
      return Instructor.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching instructor by ID: ${e.toString()}');
    }
  }

  Future<Instructor> updateInstructorProfile(
      int instructorId, Map<String, dynamic> instructorData) async {
    try {
      final response = await dio.post(
        'user_instructor/$instructorId',
        data: instructorData,
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

  Future<CourseModel> getCourseById(int courseId) async {
    try {
      final response = await dio.get('course/$courseId');
      return CourseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching course by ID: ${e.toString()}');
    }
  }
}
