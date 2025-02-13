import 'package:dio/dio.dart';

class KidResponse {
  String? status;
  Data? data;

  KidResponse({this.status, this.data});

  KidResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  NewKid? newKid;
  String? token;

  Data({this.newKid, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    newKid =
        json['newKid'] != null ? new NewKid.fromJson(json['newKid']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.newKid != null) {
      data['newKid'] = this.newKid!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class NewKid {
  String? sId;
  String? name;
  String? email;
  String? password;
  int? age;
  String? gender;
  String? governorate;
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;
  int? iV;

  NewKid(
      {this.sId,
      this.name,
      this.email,
      this.password,
      this.age,
      this.gender,
      this.governorate,
      this.phoneNumber,
      this.createdAt,
      this.updatedAt,
      this.iV});

  NewKid.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['Name'];
    email = json['Email'];
    password = json['Password'];
    age = json['Age'];
    gender = json['Gender'];
    governorate = json['Governorate'];
    phoneNumber = json['PhoneNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['Name'] = this.name;
    data['Email'] = this.email;
    data['Password'] = this.password;
    data['Age'] = this.age;
    data['Gender'] = this.gender;
    data['Governorate'] = this.governorate;
    data['PhoneNumber'] = this.phoneNumber;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }

  static Future<KidResponse> fetchKid(Dio dio, String kidId) async {
    try {
      final response = await dio.get('user_kid/$kidId');
      return KidResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching kid data: ${e.toString()}');
    }
  }

  static Future<KidResponse> createKid(Dio dio, KidResponse newKid) async {
    try {
      final response = await dio.post(
        'user_kid',
        data: newKid.toJson(),
      );
      KidResponse createdKid = KidResponse.fromJson(response.data);
      return createdKid;
    } catch (e) {
      throw Exception('Error creating new kid: ${e.toString()}');
    }
  }
}

///////////////////////////////////////////////////////////////////////////////
class Instructor {
  String? id;
  String? name;
  String? email;
  String? password;
  String? governorate;
  String? phoneNumber;
  String? bio;
  DateTime? createdAt;
  DateTime? updatedAt;
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
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null, // تحويل createdAt إلى DateTime
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'],
      image: json['Image'],
      title: json['Title'],
      experience: json['Experience'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (id != null) data['_id'] = id;
    if (name != null) data['Name'] = name;
    if (email != null) data['Email'] = email;
    if (password != null) data['Password'] = password;
    if (bio != null) data['Bio'] = bio;
    if (governorate != null) data['Governorate'] = governorate;
    if (phoneNumber != null) data['PhoneNumber'] = phoneNumber;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();
    if (v != null) data['__v'] = v;
    if (image != null) data['Image'] = image;
    if (title != null) data['Title'] = title;
    if (experience != null) data['Experience'] = experience;

    return data;
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
      Instructor createdInstructor = Instructor.fromJson(response.data);
      return createdInstructor;
    } catch (e) {
      throw Exception('Error creating new instructor: ${e.toString()}');
    }
  }
}
