import 'dart:convert'; // ضروري لتحويل JSON
import 'package:dio/dio.dart';
import 'package:loginpage/core/helper/cache_helper.dart';
import 'package:loginpage/features/add_course/data/models/Course_Model.dart';
import 'package:loginpage/features/login/data/models/user.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';

import '../../features/cart/data/model/cart_model.dart';
import '../../features/payment/data/model/payment_model.dart';

class WebServices {
  final Dio dio;

  WebServices(this.dio);

  Future<KidResponse> createNewKid(KidData newKid) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }
      final response = await dio.post(
        'user_kid',
        data: newKid.toJson(),
      );
      KidResponse kid = KidResponse.fromJson(response.data);

      return kid;
    } catch (e) {
      throw Exception('Error creating new kid: ${e.toString()}');
    }
  }

  Future<InstructorResponse> createNewInstructor(
      InstructorData newInstructor) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }
      final response = await dio.post(
        'user_instructor',
        data: newInstructor.toJson(),
      );
      InstructorResponse instructor =
          InstructorResponse.fromJson(response.data);

      return instructor;
    } catch (e) {
      throw Exception('Error creating new instructor: ${e.toString()}');
    }
  }

  Future<LoginResponse> loginUser(User loginUser) async {
    try {
      final response = await dio.post(
        'authentication/login',
        data: loginUser.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        LoginResponse loginData = LoginResponse.fromJson(response.data);

        if (loginData.token != null) {
          await CacheHelper.setData(key: "token", value: loginData.token);

          if (response.data['role'] == 'kid') {
            String kidJson = jsonEncode(response.data['kid']);
            await CacheHelper.setData(key: "user_data", value: kidJson);
            await CacheHelper.setData(key: "role", value: 'kid');
          } else if (response.data['role'] == 'instructor') {
            String instructorJson = jsonEncode(response.data['instructor']);
            await CacheHelper.setData(key: "user_data", value: instructorJson);
            await CacheHelper.setData(key: "role", value: 'instructor');
          }
        }

        return loginData;
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error login new user ${e.toString()}');
    }
  }

  Future<KidData> getKidByToken() async {
    try {
      String? token = CacheHelper.getData(key: "token");
      String? userJson = CacheHelper.getData(key: "user_data");
      String? role = CacheHelper.getData(key: "role");

      if (token == null || userJson == null || role == null) {
        throw Exception('Missing token, user data or role');
      }

      Map<String, dynamic> userMap = jsonDecode(userJson);

      if (role != 'kid') {
        throw Exception('User is not a kid');
      }

      KidData cachedKidData = KidData.fromJson(userMap);
      return cachedKidData;
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
      String? userJson = CacheHelper.getData(key: "user_data");
      String? role = CacheHelper.getData(key: "role");

      if (token == null || userJson == null || role == null) {
        throw Exception('Missing token, user data or role');
      }

      Map<String, dynamic> userMap = jsonDecode(userJson);

      if (role != 'instructor') {
        throw Exception('User is not a instructor');
      }
      InstructorData cachedinstructorData = InstructorData.fromJson(userMap);
      return cachedinstructorData;
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
      final responseData = response.data;
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data')) {
        final courseData = responseData['data']['new_course'];
        String courseId = courseData["_id"];
        List<String> courses =
            CacheHelper.getData(key: "courseIds")?.cast<String>() ?? [];
        courses.add(courseId);
        await CacheHelper.setData(key: "courseIds", value: courses);
        print("✅ Updated courseIds in cache: $courses");
        return CourseResponse.fromJson(courseData);
      }
      throw Exception("Invalid response format: ${response.data}");
    } catch (e) {
      throw Exception('Error creating new course: ${e.toString()}');
    }
  }

  Future<CourseData> getCourseById(String id) async {
    try {
      String? token = await CacheHelper.getData(key: "token");
      if (id.isEmpty) {
        throw Exception('Course ID is not available');
      }
      if (token == null || token.isEmpty) {
        throw Exception('Token is not available');
      }
      final response = await dio.get(
        'course/$id',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );
      CourseResponse courseResponse = CourseResponse.fromJson(response.data);
      if (courseResponse.data != null) {
        return courseResponse.data!;
      } else {
        throw Exception("Course data not found in response.");
      }
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
      if (response.data == null ||
          response.data["data"] == null ||
          response.data["data"]["new_course"] == null) {
        throw Exception("No course data found for this category");
      }
      var newCourse = response.data["data"]["new_course"];

      List<CourseData> courses = [];

      if (newCourse is List) {
        courses =
            newCourse.map((course) => CourseData.fromJson(course)).toList();
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

  Future<List<CourseData>> getAllCoursesByInstructor() async {
    try {
      String? token = CacheHelper.getData(key: "token");

      final response = await dio.get(
        'course/getCoursesForInstructor',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((course) => CourseData.fromJson(course))
            .toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Unexpected error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching courses: ${e.toString()}");
    }
  }

  Future<CartModel> addCart(Map<String, dynamic> cartCourseData) async {
    try {
      String? token = await CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }

      final addCartRequest =
          AddCartRequest(courseIds: cartCourseData['courseIds']);

      final response = await dio.post(
        'cart/add',
        data: addCartRequest.toJson(),
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );

      final responseData = response.data;

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('cart')) {
        final addCartResponse = AddCartResponse.fromJson(responseData);
        return addCartResponse.cart;
      }

      throw Exception("Invalid response format: ${response.data}");
    } catch (e) {
      throw Exception('Error adding course to cart: ${e.toString()}');
    }
  }

  Future<CartModel> getCart() async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) throw Exception('Missing token');

      final response = await dio.get(
        'cart/',
        options: Options(headers: {'token': 'Bearer $token'}),
      );

      final responseData = response.data['cart'];

      if (responseData == null) {
        throw Exception("Received null response data");
      }

      return CartModel.fromJson(responseData);
    } catch (e) {
      throw Exception('Error fetching cart data: ${e.toString()}');
    }
  }

  Future<RemoveCartResponse> removeFromCart(
      Map<String, dynamic> cartCourseData) async {
    try {
      String? token = await CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }

      final response = await dio.delete(
        'cart/remove',
        data: cartCourseData,
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );

      final responseData = response.data;

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('cart')) {
        final removeCartResponse = RemoveCartResponse.fromJson(responseData);
        return removeCartResponse;
      }

      throw Exception("Invalid response format: ${response.data}");
    } catch (e) {
      throw Exception('Error removing course from cart: ${e.toString()}');
    }
  }

  Future<PaymentResponse> processPayment(PaymentRequest paymentRequest) async {
    try {
      String? token = await CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }

      final response = await dio.post(
        'payment/process',
        data: paymentRequest.toJson(),
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        PaymentResponse paymentResponse =
            PaymentResponse.fromJson(response.data);
        return paymentResponse;
      } else {
        throw Exception('Failed to process payment');
      }
    } catch (e) {
      throw Exception('Error processing payment: ${e.toString()}');
    }
  }

  Future<List<CourseData>> getAllCoursesByKid() async {
    try {
      String? token = CacheHelper.getData(key: "token");

      final response = await dio.get(
        'course/myPurchasedCourses',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final courses = data['purchasedCourses'] as List;
        return courses.map((course) => CourseData.fromJson(course)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Unexpected error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching courses: ${e.toString()}");
    }
  }

  Future<List<CourseData>> getTrendingCourses() async {
    try {
      String? token = CacheHelper.getData(key: "token");

      final response = await dio.get(
        'course/trending',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data != null && data['trendingCourses'] != null) {
          return List<CourseData>.from(
            data['trendingCourses']
                .map((course) => CourseData.fromJson(course)),
          );
        } else {
          return [];
        }
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Unexpected error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching courses: ${e.toString()}");
    }
  }
}
