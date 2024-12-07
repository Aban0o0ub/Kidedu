import 'package:json_annotation/json_annotation.dart';
part 'kid.g.dart';

@JsonSerializable()
class Kid {
  @JsonKey(name: '_id')
  int? id;
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'Email')
  String? email;
  @JsonKey(name: 'Password')
  String? password;
  @JsonKey(name: 'Age')
  int? age;
  @JsonKey(name: 'Gender')
  String? gender;
  @JsonKey(name: 'Governorate')
  String? governorate;
  @JsonKey(name: 'PhoneNumber')
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;
  @JsonKey(name: 'Image')
  String? image;

  Kid(
      {this.id,
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
      this.image});

  factory Kid.fromJson(Map<String, dynamic> json) => _$KidFromJson(json);
  Map<String, dynamic> toJson() => _$KidToJson(this);
}

@JsonSerializable()
class Instructor {
  @JsonKey(name: '_id')
  int? id;
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'Email')
  String? email;
  @JsonKey(name: 'Password')
  String? password;
  @JsonKey(name: 'Governorate')
  String? governorate;
  @JsonKey(name: 'PhoneNumber')
  String? phoneNumber;
  @JsonKey(name: 'Bio')
  String? bio;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;
  @JsonKey(name: 'Image')
  String? image;
  @JsonKey(name: 'Title')
  String? title;
  @JsonKey(name: 'Experience')
  String? experience;

  Instructor(
      {this.id,
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
      this.experience});

  factory Instructor.fromJson(Map<String, dynamic> json) =>
      _$InstructorFromJson(json);
  Map<String, dynamic> toJson() => _$InstructorToJson(this);
}
