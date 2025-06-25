import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:loginpage/core/helper/cache_helper.dart';
import 'package:loginpage/features/add_course/data/models/Course_Model.dart';
import 'package:loginpage/features/login/data/models/user.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import '../../features/cart/data/model/cart_model.dart';
import '../../features/earnings/data/model/earnings_model.dart';
import '../../features/lesson/data/models/lesson.dart';
import '../../features/lesson/data/models/quiz.dart';
import '../../features/lesson/data/models/section.dart';
import '../../features/payment/data/model/payment_model.dart';
import '../../features/reviews/data/models/review_model.dart';

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
      if (token == null) {
        throw Exception('Missing token');
      }
      final response = await dio.get(
        'user_kid/profile',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );

      if (response.data == null) {
        throw Exception('No data returned from API');
      }

      return KidData.fromJson(response.data);
    } catch (e) {
      print('Error in getKidByToken: ${e.toString()}');
      throw Exception('Error fetching kid profile: ${e.toString()}');
    }
  }

  Future<KidResponse> updateKidProfile(KidData kidData) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      bool hasNewImage = kidData.image != null &&
          kidData.image!.isNotEmpty &&
          !kidData.image!.startsWith('http');

      if (hasNewImage) {
        Map<String, dynamic> formFields = {};

        if (kidData.name != null && kidData.name!.isNotEmpty) {
          formFields['Name'] = kidData.name;
        }
        if (kidData.email != null && kidData.email!.isNotEmpty) {
          formFields['Email'] = kidData.email;
        }
        if (kidData.age != null) {
          formFields['Age'] = kidData.age;
        }
        if (kidData.gender != null && kidData.gender!.isNotEmpty) {
          formFields['Gender'] = kidData.gender;
        }
        if (kidData.governorate != null && kidData.governorate!.isNotEmpty) {
          formFields['Governorate'] = kidData.governorate;
        }
        if (kidData.phoneNumber != null && kidData.phoneNumber!.isNotEmpty) {
          formFields['PhoneNumber'] = kidData.phoneNumber;
        }

        formFields['Image'] = await MultipartFile.fromFile(kidData.image!);

        FormData formData = FormData.fromMap(formFields);

        final response = await dio.patch(
          'user_kid/profile',
          data: formData,
          options: Options(
            headers: {'token': 'Bearer $token'},
            validateStatus: (status) => status! < 500,
          ),
        );

        if (response.statusCode == 200) {
          return KidResponse.fromJson(response.data);
        } else {
          throw Exception("Update failed: ${response.statusMessage}");
        }
      } else {
        Map<String, dynamic> jsonData = {};

        if (kidData.name != null && kidData.name!.isNotEmpty) {
          jsonData['Name'] = kidData.name;
        }
        if (kidData.email != null && kidData.email!.isNotEmpty) {
          jsonData['Email'] = kidData.email;
        }
        if (kidData.age != null) {
          jsonData['Age'] = kidData.age;
        }
        if (kidData.gender != null && kidData.gender!.isNotEmpty) {
          jsonData['Gender'] = kidData.gender;
        }
        if (kidData.governorate != null && kidData.governorate!.isNotEmpty) {
          jsonData['Governorate'] = kidData.governorate;
        }
        if (kidData.phoneNumber != null && kidData.phoneNumber!.isNotEmpty) {
          jsonData['PhoneNumber'] = kidData.phoneNumber;
        }

        final response = await dio.patch(
          'user_kid/profile',
          data: jsonData,
          options: Options(
            headers: {
              'token': 'Bearer $token',
              'content-type': 'application/json',
            },
            validateStatus: (status) => status! < 500,
          ),
        );

        if (response.statusCode == 200) {
          return KidResponse.fromJson(response.data);
        } else {
          throw Exception("Update failed: ${response.statusMessage}");
        }
      }
    } catch (e) {
      throw Exception("Error updating kid profile: ${e.toString()}");
    }
  }

  Future<InstructorData> getInstructorByToken() async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }
      final response = await dio.get(
        'user_instructor/profile',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );

      if (response.data == null) {
        throw Exception('No data returned from API');
      }

      return InstructorData.fromJson(response.data);
    } catch (e) {
      print('Error in getInstructorByToken: ${e.toString()}');
      throw Exception('Error fetching instructor profile: ${e.toString()}');
    }
  }

  Future<InstructorResponse> updateInstructorProfile(
      InstructorData instructorData) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      bool hasNewImage = instructorData.image != null &&
          instructorData.image!.isNotEmpty &&
          !instructorData.image!.startsWith('http');

      if (hasNewImage) {
        Map<String, dynamic> formFields = {};

        if (instructorData.name != null && instructorData.name!.isNotEmpty) {
          formFields['Name'] = instructorData.name;
        }
        if (instructorData.email != null && instructorData.email!.isNotEmpty) {
          formFields['Email'] = instructorData.email;
        }

        if (instructorData.governorate != null &&
            instructorData.governorate!.isNotEmpty) {
          formFields['Governorate'] = instructorData.governorate;
        }
        if (instructorData.phoneNumber != null &&
            instructorData.phoneNumber!.isNotEmpty) {
          formFields['PhoneNumber'] = instructorData.phoneNumber;
        }
        if (instructorData.title != null && instructorData.title!.isNotEmpty) {
          formFields['Title'] = instructorData.title; // تأكد إن ده موجود
        }
        if (instructorData.experience != null &&
            instructorData.experience!.isNotEmpty) {
          formFields['Experience'] =
              instructorData.experience; // تأكد إن ده موجود
        }

        formFields['Image'] =
            await MultipartFile.fromFile(instructorData.image!);

        FormData formData = FormData.fromMap(formFields);

        final response = await dio.patch(
          'user_instructor/profile',
          data: formData,
          options: Options(
            headers: {'token': 'Bearer $token'},
            validateStatus: (status) => status! < 500,
          ),
        );

        if (response.statusCode == 200) {
          return InstructorResponse.fromJson(response.data);
        } else {
          throw Exception("Update failed: ${response.statusMessage}");
        }
      } else {
        Map<String, dynamic> jsonData = {};

        if (instructorData.name != null && instructorData.name!.isNotEmpty) {
          jsonData['Name'] = instructorData.name;
        }
        if (instructorData.email != null && instructorData.email!.isNotEmpty) {
          jsonData['Email'] = instructorData.email;
        }
        if (instructorData.governorate != null &&
            instructorData.governorate!.isNotEmpty) {
          jsonData['Governorate'] = instructorData.governorate;
        }
        if (instructorData.phoneNumber != null &&
            instructorData.phoneNumber!.isNotEmpty) {
          jsonData['PhoneNumber'] = instructorData.phoneNumber;
        }

        final response = await dio.patch(
          'user_instructor/profile',
          data: jsonData,
          options: Options(
            headers: {
              'token': 'Bearer $token',
              // 'content-type': 'application/json',
            },
            validateStatus: (status) => status! < 500,
          ),
        );

        if (response.statusCode == 200) {
          return InstructorResponse.fromJson(response.data);
        } else {
          throw Exception("Update failed: ${response.statusMessage}");
        }
      }
    } catch (e) {
      throw Exception("Error updating instructor profile: ${e.toString()}");
    }
  }

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
        throw Exception("No courses available");
      }

      var newCourse = response.data["data"]["new_course"];
      List<CourseData> courses = [];

      if (newCourse is List) {
        if (newCourse.isEmpty) {
          throw Exception("No courses available");
        }
        courses =
            newCourse.map((course) => CourseData.fromJson(course)).toList();
      } else if (newCourse is Map<String, dynamic>) {
        courses.add(CourseData.fromJson(newCourse));
      } else {
        throw Exception("No courses available");
      }

      return courses;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception("No courses available");
      }
      throw Exception('Error fetching course by category: ${e.toString()}');
    } catch (e) {
      if (e.toString().contains("No courses available")) {
        throw Exception("No courses available");
      }
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

  Future<CreateSectionResponse> addSection(
      CreateSectionRequest newSection) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }
      final response = await dio.post(
        'section/${newSection.courseId}',
        data: {
          'title': newSection.title,
        },
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );

      final responseData = response.data;

      return CreateSectionResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Error creating new section: ${e.toString()}');
    }
  }

  Future<GetSectionsResponse> getSectionByCourseId(String courseId) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }

      final response = await dio.get(
        'section/course/$courseId',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return GetSectionsResponse.fromJson(response.data);
      } else if (response.statusCode == 404) {
        return GetSectionsResponse.empty();
      } else {
        throw Exception("Unexpected error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception('Error getting sections: ${e.toString()}');
    }
  }

  Future<LessonResponse> addLesson(LessonCreateRequest newLesson) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }

      Map<String, dynamic> formDataMap = {
        'name': newLesson.name,
        'youtubeVideoUrl': newLesson.youtubeVideoUrl,
        'description': newLesson.description,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await dio.post(
        'lesson/${newLesson.sectionId}',
        data: formData,
        options: Options(
          headers: {
            'token': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final responseData = response.data;

      return LessonResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Error creating new lesson: ${e.toString()}');
    }
  }

  Future<LessonListResponse> getLessonBySectionId(String sectionId) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }

      final response = await dio.get(
        'lesson/$sectionId',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );

      final responseData = response.data;
      return LessonListResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Error getting lessons: ${e.toString()}');
    }
  }

  Future<AddQuizResponse> addQuiz(AddQuizRequest newQuiz) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }
      final response = await dio.post(
        'quiz/',
        data: newQuiz.toJson(),
        options: Options(
          headers: {
            'token': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final responseData = response.data;

      return AddQuizResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Error adding new quiz: ${e.toString()}');
    }
  }

  Future<SubmitQuizResponse> submitQuiz(SubmitQuizRequest request) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception("Missing token");
      }

      final response = await dio.post(
        'quiz/submit',
        data: request.toJson(),
        options: Options(
          headers: {
            'token': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return SubmitQuizResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error submitting quiz: ${e.toString()}');
    }
  }

  Future<ReviewResponseModel> createReviews(
      ReviewRequestModel newReview) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }

      final response = await dio.post(
        'reviews',
        data: newReview.toJson(),
        options: Options(
          headers: {
            'token': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final responseData = response.data;
      return ReviewResponseModel.fromJson(responseData);
    } on DioException catch (dioError) {
      // Handle specific Dio errors
      if (dioError.response != null) {
        throw Exception(
            'Server error: ${dioError.response?.statusCode} - ${dioError.response?.data}');
      } else {
        throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      throw Exception('Error creating review: ${e.toString()}');
    }
  }

  Future<ReviewListResponseModel> getRecentReviews() async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }

      final response = await dio.get(
        'reviews/recent',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );

      if (response.data == null) {
        throw Exception('No data returned from API');
      }

      return ReviewListResponseModel.fromJson(response.data);
    } on DioException catch (dioError) {
      // Handle specific Dio errors
      if (dioError.response != null) {
        print(
            'Server error in getRecentReviews: ${dioError.response?.statusCode} - ${dioError.response?.data}');
        throw Exception(
            'Server error: ${dioError.response?.statusCode} - ${dioError.response?.data}');
      } else {
        print('Network error in getRecentReviews: ${dioError.message}');
        throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      print('Error in getRecentReviews: ${e.toString()}');
      throw Exception('Error fetching recent reviews: ${e.toString()}');
    }
  }

  Future<ReviewListResponseModel> getReviewsByCourse(String courseId) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }

      final response = await dio.get(
        'reviews/course/$courseId',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );

      if (response.data == null) {
        throw Exception('No data returned from API');
      }

      return ReviewListResponseModel.fromJson(response.data);
    } on DioException catch (dioError) {
      // Handle specific Dio errors
      if (dioError.response != null) {
        print(
            'Server error in getReviewsByCourse: ${dioError.response?.statusCode} - ${dioError.response?.data}');
        throw Exception(
            'Server error: ${dioError.response?.statusCode} - ${dioError.response?.data}');
      } else {
        print('Network error in getReviewsByCourse: ${dioError.message}');
        throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      print('Error in getReviewsByCourse: ${e.toString()}');
      throw Exception('Error getting reviews by course: ${e.toString()}');
    }
  }

  Future<ReviewListResponseModel> getReviewsByInstructor() async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }

      final response = await dio.get(
        'reviews/instructor',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );

      if (response.data == null) {
        throw Exception('No data returned from API');
      }

      return ReviewListResponseModel.fromJson(response.data);
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print(
            'Server error in getReviewsByInstructor: ${dioError.response?.statusCode} - ${dioError.response?.data}');
        throw Exception(
            'Server error: ${dioError.response?.statusCode} - ${dioError.response?.data}');
      } else {
        print('Network error in getReviewsByInstructor: ${dioError.message}');
        throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      print('Error in getReviewsByInstructor: ${e.toString()}');
      throw Exception('Error fetching instructor reviews: ${e.toString()}');
    }
  }

  Future<EarningsResponseModel> getInstructorEarnings() async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) throw Exception('Missing token');

      final response = await dio.get(
        'user_instructor/earnings',
        options: Options(headers: {'token': 'Bearer $token'}),
      );

      if (response.statusCode == 500) {
        throw Exception('Server error: Please try again later');
      }

      if (response.data == null) {
        throw Exception('No data returned from API');
      }

      return EarningsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        throw Exception('Server error: Earnings calculation failed');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching earnings data: ${e.toString()}');
    }
  }

  Future<List<CourseData>> getAllCourses() async {
    try {
      String? token = CacheHelper.getData(key: "token");
      final response = await dio.get(
        'course',
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final courseResponse = CourseResponse.fromJson(response.data);
        return courseResponse.allCourses ?? [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            "Unexpected error: ${response.statusCode} - ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching courses: ${e.toString()}");
    }
  }

  Future<ForgetPasswordResponse> forgetPassword(
      ForgetPasswordRequest forgetPassword) async {
    try {
      final response = await dio.post(
        'authentication/forgot-password',
        data: forgetPassword.toJson(),
      );

      // Check if response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ForgetPasswordResponse.fromJson(response.data);
      } else {
        throw Exception('Server returned status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle different types of errors
      if (e.response != null) {
        throw Exception(
            'Server error: ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  Future<ForgetPasswordResponse> resetPassword({
    required String token,
    required ResetPasswordRequest resetPassword,
  }) async {
    try {
      final response = await dio.post(
        'authentication/reset-password/$token',
        data: resetPassword.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ForgetPasswordResponse.fromJson(response.data);
      } else {
        throw Exception('Server returned status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Unknown server error'
            : 'Server error occurred';
        throw Exception('Server error: $errorMessage');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  Future<EndCourseResponse> instructorEndCourse(
      EndCourseRequest endCourse) async {
    try {
      String? token = CacheHelper.getData(key: "token");
      if (token == null) {
        throw Exception('Missing token');
      }
      final response = await dio.post(
        'user_instructor/complete-course',
        data: endCourse.toJson(),
        options: Options(
          headers: {
            'token': 'Bearer $token',
          },
        ),
      );
      final responseData = response.data;
      return EndCourseResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Error completing course: ${e.toString()}');
    }
  }
}
