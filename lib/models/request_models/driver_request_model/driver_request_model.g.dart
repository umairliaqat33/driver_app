// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverRequestModel _$DriverRequestModelFromJson(Map<String, dynamic> json) =>
    DriverRequestModel(
      offeredFare: (json['offeredFare'] as num).toDouble(),
      dropOffLocationLatitude:
          (json['dropOffLocationLatitude'] as num).toDouble(),
      dropOffLocationLongitude:
          (json['dropOffLocationLongitude'] as num).toDouble(),
      pickupLocationLatitude:
          (json['pickupLocationLatitude'] as num).toDouble(),
      pickupLocationLongitude:
          (json['pickupLocationLongitude'] as num).toDouble(),
      requestId: json['requestId'] as String,
      isRideCompleted: json['isRideCompleted'] as bool? ?? false,
      time: json['time'] as int?,
      imageLink: json['imageLink'] as String?,
    );

Map<String, dynamic> _$DriverRequestModelToJson(DriverRequestModel instance) =>
    <String, dynamic>{
      'isRideCompleted': instance.isRideCompleted,
      'offeredFare': instance.offeredFare,
      'requestId': instance.requestId,
      'pickupLocationLatitude': instance.pickupLocationLatitude,
      'pickupLocationLongitude': instance.pickupLocationLongitude,
      'dropOffLocationLatitude': instance.dropOffLocationLatitude,
      'dropOffLocationLongitude': instance.dropOffLocationLongitude,
      'time': instance.time,
      'imageLink': instance.imageLink,
    };
