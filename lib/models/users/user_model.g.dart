// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      email: json['email'] as String,
      userName: json['userName'] as String,
      role: json['role'] as String,
      uid: json['uid'] as String?,
      reference: json['reference'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userName': instance.userName,
      'email': instance.email,
      'role': instance.role,
      'uid': instance.uid,
      'reference': instance.reference,
    };
