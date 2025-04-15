import 'package:dio/dio.dart';

class KidResponse {
  String? status;
  KidDataWrapper? data; 

  KidResponse({this.status, this.data});

  KidResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? KidDataWrapper.fromJson(json['data']) : null;
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
    if (newKid != null) {
      data['newKid'] = newKid!.toJson();
    }
    data['token'] = token;
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
    data['_id'] = sId;
    data['Name'] = name;
    data['Email'] = email;
    data['Password'] =password;
    data['Age'] = age;
    data['Gender'] = gender;
    data['Governorate'] = governorate;
    data['PhoneNumber'] =phoneNumber;
    data['createdAt'] =createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
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
  InstructorDataWrapper? data;

  InstructorResponse({this.status, this.data});

  InstructorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? InstructorDataWrapper.fromJson(json['data']) : null;
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

class InstructorDataWrapper {
  InstructorData? newInstructor;
  String? token;

  InstructorDataWrapper({this.newInstructor, this.token});

  InstructorDataWrapper.fromJson(Map<String, dynamic> json) {
    newInstructor =
        json['newInstructor'] != null ? InstructorData.fromJson(json['newInstructor']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (newInstructor != null) {
      data['newInstructor'] = newInstructor!.toJson();
    }
    data['token'] = token;
    return data;
  }
}
class InstructorData {
  String? id;
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

  InstructorData({
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

  InstructorData.fromJson(Map<String, dynamic> json) {
  id = json['_id'];
  name = json['Name'];
  email = json['Email'];
  password = json['Password'];
  bio = json['Bio'];
  governorate = json['Governorate'];
  phoneNumber = json['PhoneNumber'];
  createdAt = json['createdAt'];
  updatedAt = json['updatedAt'];
  v = json['__v'];
  image = json['Image'];
  title = json['Title'];
  experience = json['Experience'];
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
    if (createdAt != null) data['createdAt'] = createdAt;
    if (updatedAt != null) data['updatedAt'] = updatedAt;
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

  static Future<InstructorResponse> createInstructor(Dio dio, InstructorData newInstructor) async {
    try {
      final response = await dio.post(
        'user_instructor',
        data: newInstructor.toJson(),
      );
      return InstructorResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error creating new instructor: ${e.toString()}');
    }
  }
}
