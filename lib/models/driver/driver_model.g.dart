// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverModel _$DriverModelFromJson(Map<String, dynamic> json) => DriverModel(
      email: json['email'] as String,
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      number: json['number'] as String?,
      address: json['address'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      drivingLicense: json['drivingLicense'] as String?,
      licenseExpiry: json['licenseExpiry'] as String?,
      licenseBackLink: json['licenseBackLink'] as String?,
      licenseFrontLink: json['licenseFrontLink'] as String?,
      profileImageLink: json['profileImageLink'] as String?,
      vehicleNo: json['vehicleNo'] as String?,
      vehicleType: json['vehicleType'] as String?,
      approvalStatus: json['approvalStatus'] as String?,
      hasVehicle: json['hasVehicle'] as bool?,
      isVerified: json['isVerified'] as bool?,
      rating: (json['rating'] as num?)?.toDouble(),
      totalRatings: json['totalRatings'] as int?,
    );

Map<String, dynamic> _$DriverModelToJson(DriverModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'uid': instance.uid,
      'name': instance.name,
      'number': instance.number,
      'address': instance.address,
      'drivingLicense': instance.drivingLicense,
      'licenseExpiry': instance.licenseExpiry,
      'dateOfBirth': instance.dateOfBirth,
      'profileImageLink': instance.profileImageLink,
      'licenseFrontLink': instance.licenseFrontLink,
      'licenseBackLink': instance.licenseBackLink,
      'vehicleNo': instance.vehicleNo,
      'vehicleType': instance.vehicleType,
      'approvalStatus': instance.approvalStatus,
      'hasVehicle': instance.hasVehicle,
      'isVerified': instance.isVerified,
      'rating': instance.rating,
      'totalRatings': instance.totalRatings,
    };
