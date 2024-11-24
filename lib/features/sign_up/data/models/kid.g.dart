// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kid _$KidFromJson(Map<String, dynamic> json) => Kid(
      id: json['_id'] as String?,
      name: json['Name'] as String?,
      email: json['Email'] as String?,
      password: json['Password'] as String?,
      age: (json['Age'] as num?)?.toInt(),
      gender: json['Gender'] as String?,
      governorate: json['Governorate'] as String?,
      phoneNumber: json['PhoneNumber'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: (json['__v'] as num?)?.toInt(),
    );

Map<String, dynamic> _$KidToJson(Kid instance) => <String, dynamic>{
      '_id': instance.id,
      'Name': instance.name,
      'Email': instance.email,
      'Password': instance.password,
      'Age': instance.age,
      'Gender': instance.gender,
      'Governorate': instance.governorate,
      'PhoneNumber': instance.phoneNumber,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '__v': instance.v,
    };
