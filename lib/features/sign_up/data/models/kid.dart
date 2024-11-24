import 'package:json_annotation/json_annotation.dart';
part 'kid.g.dart';

@JsonSerializable()
class Kid {
  @JsonKey(name: '_id')
  String? id;
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
      this.v});

  factory Kid.fromJson(Map<String, dynamic> json) => _$KidFromJson(json);
  Map<String, dynamic> toJson() => _$KidToJson(this);
}
