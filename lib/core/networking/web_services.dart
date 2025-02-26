import 'dart:convert'; // ضروري لتحويل JSON
import 'package:dio/dio.dart';
import 'package:loginpage/core/helper/cache_helper.dart';
import 'package:loginpage/features/add_course/data/models/add_course.dart';
import 'package:loginpage/features/login/data/models/user.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

class WebServices {
  final Dio dio;

  WebServices(this.dio);

  Future<KidResponse> createNewKid(KidData newKid) async {
    try {
      final response = await dio.post(
        'user_kid',
        data: newKid.toJson(),
      );
      KidResponse kid = KidResponse.fromJson(response.data);

      if (kid.data != null) {
        await CacheHelper.setData(key: "token", value: kid.data!.token);

        if (kid.data!.newKid != null) {
          String kidJson = jsonEncode(kid.data!.newKid!.toJson());
          await CacheHelper.setData(key: "kid_data", value: kidJson);
        }
      }

      return kid;
    } catch (e) {
      throw Exception('Error creating new kid: ${e.toString()}');
    }
  }

  Future<InstructorResponse> createNewInstructor(
      NewInstructor newInstructor) async {
    try {
      final response = await dio.post(
        'user_instructor',
        data: newInstructor.toJson(),
      );
      InstructorResponse instructor =
          InstructorResponse.fromJson(response.data);
      CacheHelper.setData(key: "token", value: instructor.data!.token);
      return instructor;
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

  Future<KidData> getKidByToken() async {
    try {
      String? token = CacheHelper.getData(key: "token");
      String? kidDataJson = CacheHelper.getData(key: "kid_data");

      if (token == null || kidDataJson == null) {
        throw Exception('Missing token or kid data');
      }

      Map<String, dynamic> kidMap = jsonDecode(kidDataJson);
      KidData cachedKidData = KidData.fromJson(kidMap);

      final response = await dio.get(
        'user_kid/profile',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );

      final kidResponse = KidResponse.fromJson(response.data);

      return kidResponse.data?.newKid ?? cachedKidData;
    } catch (e) {
      throw Exception('Error fetching kid: ${e.toString()}');
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

  Future<NewInstructor> getInstructorByToken() async {
    try {
      String? token = CacheHelper.getData(key: "token");

      if (token == null) {
        throw Exception('Missing token');
      }

      final response = await dio.get(
        'user_instructor/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final instructorResponse = InstructorResponse.fromJson(response.data);
      return instructorResponse.data!.newinstructor!;
    } catch (e) {
      throw Exception('Error fetching instructor: ${e.toString()}');
    }
  }

  // Future<Instructor> updateInstructorProfile(String instructorId,
  //     Map<String, dynamic> instructorData, String token) async {
  //   try {
  //     final response = await dio.post(
  //       'user_instructor/$instructorId',
  //       data: instructorData,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //     );
  //     return Instructor.fromJson(response.data);
  //   } catch (e) {
  //     throw Exception('Error updating instructor profile: ${e.toString()}');
  //   }
  // }

  Future<CourseModel> addNewCourse(CourseModel newCourse) async {
    try {
      String? token = CacheHelper.getData(key: "token");

      if (token == null) {
        throw Exception('Missing token');
      }

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
