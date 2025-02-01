import 'package:bson/bson.dart';
import 'package:dio/dio.dart';
import '../../../../core/helper/object_id_converter.dart';

class Kid {
  @ObjectIdConverter()
  ObjectId? id;
  String? name;
  String? email;
  String? password;
  int? age;
  String? gender;
  String? governorate;
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? image;

  Kid({
    this.id,
    this.name,
    this.email,
    this.password,
    this.age,
    this.gender,
    this.governorate,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.image,
  });

  factory Kid.fromJson(Map<String, dynamic> json) {
    return Kid(
      id: json['_id'],
      name: json['Name'],
      email: json['Email'],
      password: json['Password'],
      age: json['Age'],
      gender: json['Gender'],
      governorate: json['Governorate'],
      phoneNumber: json['PhoneNumber'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      image: json['Image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Name': name,
      'Email': email,
      'Password': password,
      'Age': age,
      'Gender': gender,
      'Governorate': governorate,
      'PhoneNumber': phoneNumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'Image': image,
    };
  }

  static Future<Kid> fetchKid(Dio dio, String kidId) async {
    try {
      final response = await dio.get('user_kid/$kidId');
      return Kid.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching kid data: ${e.toString()}');
    }
  }

  static Future<Kid> createKid(Dio dio, Kid newKid) async {
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
}

///////////////////////////////////////////////////////////////////////////////
class Instructor {
  int? id;
  String? name;
  String? email;
  String? password;
  String? governorate;
  String? phoneNumber;
  String? bio;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? image;
  String? title;
  String? experience;

  Instructor({
    this.id,
    this.name,
    this.email,
    this.password,
    this.bio,
    this.governorate,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.image,
    this.title,
    this.experience,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['_id'],
      name: json['Name'],
      email: json['Email'],
      password: json['Password'],
      bio: json['Bio'],
      governorate: json['Governorate'],
      phoneNumber: json['PhoneNumber'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      image: json['Image'],
      title: json['Title'],
      experience: json['Experience'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Name': name,
      'Email': email,
      'Password': password,
      'Bio': bio,
      'Governorate': governorate,
      'PhoneNumber': phoneNumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'Image': image,
      'Title': title,
      'Experience': experience,
    };
  }

  static Future<Instructor> fetchInstructor(Dio dio, int instructorId) async {
    try {
      final response = await dio.get('user_instructor/$instructorId');
      return Instructor.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching instructor data: ${e.toString()}');
    }
  }

  static Future<Instructor> createInstructor(
      Dio dio, Instructor newInstructor) async {
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
}
