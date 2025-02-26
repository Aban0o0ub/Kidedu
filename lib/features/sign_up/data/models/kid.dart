import 'package:dio/dio.dart';

import '../../../../core/helper/cache_helper.dart';

class KidResponse {
  String? status;
  KidDataWrapper? data; // تعديل اسم الكلاس

  KidResponse({this.status, this.data});

  KidResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? KidDataWrapper.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class KidDataWrapper {  
  KidData? newKid;
  String? token;

  KidDataWrapper({this.newKid, this.token});

  KidDataWrapper.fromJson(Map<String, dynamic> json) {
    newKid = json['newKid'] != null ? KidData.fromJson(json['newKid']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.newKid != null) {
      data['newKid'] = this.newKid!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class KidData {
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

  KidData(
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

  KidData.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = {};
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

  static Future<KidResponse> createKid(Dio dio, KidData newKid) async {
    try {
      final response = await dio.post(
        'user_kid',
        data: newKid.toJson(), 
      );
      return KidResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error creating new kid: ${e.toString()}');
    }
  }
}


///////////////////////////////////////////////////////////////////////////////
class InstructorResponse {
  String? status;
  InstructorData? data;

  InstructorResponse({this.status, this.data});

  InstructorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? InstructorData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class InstructorData {
  NewInstructor? newinstructor;
  String? token;

  InstructorData({this.newinstructor, this.token});

  InstructorData.fromJson(Map<String, dynamic> json) {
    newinstructor =
        json['newinstructor'] != null ? NewInstructor.fromJson(json['instructor']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (newinstructor != null) {
      data['newinstructor'] = newinstructor!.toJson();
    }
    data['token'] = token;
    return data;
  }
}
class NewInstructor {
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

  NewInstructor({
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

  factory NewInstructor.fromJson(Map<String, dynamic> json) {
    return NewInstructor(
      id: json['_id'],
      name: json['Name'],
      email: json['Email'],
      password: json['Password'],
      bio: json['Bio'],
      governorate: json['Governorate'],
      phoneNumber: json['PhoneNumber'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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

  static Future<InstructorResponse> fetchInstructor(Dio dio, String instructorId) async {
    try {
      final response = await dio.get('user_instructor/$instructorId');
      return InstructorResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching instructor data: ${e.toString()}');
    }
  }

  static Future<InstructorResponse> createInstructor(Dio dio, NewInstructor newInstructor) async {
    try {
      final response = await dio.post(
        'user_instructor',
        data: newInstructor.toJson(),
      );
      InstructorResponse instructor = InstructorResponse.fromJson(response.data);
      
      CacheHelper.setData(key: "token", value: instructor.data!.token);
      
      return instructor;
    } catch (e) {
      throw Exception('Error creating new instructor: ${e.toString()}');
    }
  }
}
