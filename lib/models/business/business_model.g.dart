// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessModel _$BusinessModelFromJson(Map<String, dynamic> json) =>
    BusinessModel(
      email: json['email'] as String,
      name: json['name'] as String?,
      uid: json['uid'] as String?,
      number: json['number'] as String?,
      location: json['location'] as String?,
      pointOfContact: json['pointOfContact'] as String?,
      imageLink: json['imageLink'] as String?,
      approvalStatus: json['approvalStatus'] as String?,
    );

Map<String, dynamic> _$BusinessModelToJson(BusinessModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'uid': instance.uid,
      'name': instance.name,
      'pointOfContact': instance.pointOfContact,
      'location': instance.location,
      'number': instance.number,
      'imageLink': instance.imageLink,
      'approvalStatus': instance.approvalStatus,
    };
