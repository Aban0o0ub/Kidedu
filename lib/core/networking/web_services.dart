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
      InstructorData newInstructor) async {
    try {
      final response = await dio.post(
        'user_instructor',
        data: newInstructor.toJson(),
      );
      InstructorResponse instructor =
          InstructorResponse.fromJson(response.data);

      if (instructor.data != null) {
        await CacheHelper.setData(key: "token", value: instructor.data!.token);

        if (instructor.data!.newInstructor != null) {
          String instructorJson =
              jsonEncode(instructor.data!.newInstructor!.toJson());
          await CacheHelper.setData(
              key: "instructor_data", value: instructorJson);
        }
      }

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

  Future<InstructorData> getInstructorByToken() async {
    try {
      String? token = CacheHelper.getData(key: "token");
      String? instructorDataJson = CacheHelper.getData(key: "instructor_data");
 print("DEBUG: Token from cache -> $token");
    print("DEBUG: Instructor data from cache -> $instructorDataJson");
      if (token == null || instructorDataJson == null) {
        throw Exception('Missing token or instructor data');
      }

      Map<String, dynamic> instructorMap = jsonDecode(instructorDataJson);
      InstructorData cachedinstructorData =
          InstructorData.fromJson(instructorMap);
    print("DEBUG: Cached instructor data -> ${cachedinstructorData.toString()}");
      final response = await dio.get(
        'user_instructor/profile',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );
    print("DEBUG: API Response -> ${response.data}");
      final instructorResponse = InstructorResponse.fromJson(response.data);
    print("DEBUG: Parsed InstructorResponse -> ${instructorResponse.toString()}");
      return instructorResponse.data?.newInstructor ?? cachedinstructorData;
    } catch (e) {
          print("ERROR: Exception occurred -> ${e.toString()}");
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

  Future<CourseResponse> addNewCourse(CourseRequest newCourse) async {
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
          'token': 'Bearer $token',
        },
      ),
    );

    return CourseResponse.fromJson(response.data);
  } catch (e) {
    throw Exception('Error creating new course: ${e.toString()}');
  }
}

  

  Future<CourseResponse> getCourseById(int courseId, String token) async {
    try {
      final response = await dio.get(
        'course/$courseId',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );
      return CourseResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching course by ID: ${e.toString()}');
    }
  }
  
Future<List<CourseData>> getCourseByCategory(String category) async {
  try {
    String? token = CacheHelper.getData(key: "token");
    final response = await dio.get(
      'course/category',
      queryParameters: {'category': category}, 
      options: Options(
        headers: {
          'token': 'Bearer $token',
        },
      ),
    );
    if (response.data == null || response.data["data"] == null || response.data["data"]["new_course"] == null) {
      throw Exception("No course data found for this category");
    }
    var newCourse = response.data["data"]["new_course"];

    List<CourseData> courses = [];

    if (newCourse is List) {
      courses = newCourse.map((course) => CourseData.fromJson(course)).toList();
    } else if (newCourse is Map<String, dynamic>) {
      courses.add(CourseData.fromJson(newCourse));
    } else {
      throw Exception("Unexpected format of course data");
    }

    return courses;
  } catch (e) {
    throw Exception('Error fetching course by category: ${e.toString()}');
  }
}



}
