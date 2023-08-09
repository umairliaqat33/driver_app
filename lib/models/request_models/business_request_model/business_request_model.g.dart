// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessRequestModel _$BusinessRequestModelFromJson(
        Map<String, dynamic> json) =>
    BusinessRequestModel(
      requestId: json['requestId'] as String,
      isRideCancelled: json['isRideCancelled'] as bool,
      isRideCompleted: json['isRideCompleted'] as bool,
      pickupLocationLatitude:
          (json['pickupLocationLatitude'] as num).toDouble(),
      pickupLocationLongitude:
          (json['pickupLocationLongitude'] as num).toDouble(),
      dropOffLocationLatitude:
          (json['dropOffLocationLatitude'] as num).toDouble(),
      dropOffLocationLongitude:
          (json['dropOffLocationLongitude'] as num).toDouble(),
      fare: (json['fare'] as num).toDouble(),
      riderType: json['riderType'] as String,
      acceptorDriverId: json['acceptorDriverId'] as String?,
      declinedUsersIdList: (json['declinedUsersIdList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$BusinessRequestModelToJson(
        BusinessRequestModel instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'isRideCompleted': instance.isRideCompleted,
      'isRideCancelled': instance.isRideCancelled,
      'pickupLocationLatitude': instance.pickupLocationLatitude,
      'pickupLocationLongitude': instance.pickupLocationLongitude,
      'dropOffLocationLatitude': instance.dropOffLocationLatitude,
      'dropOffLocationLongitude': instance.dropOffLocationLongitude,
      'fare': instance.fare,
      'riderType': instance.riderType,
      'acceptorDriverId': instance.acceptorDriverId,
      'declinedUsersIdList': instance.declinedUsersIdList,
    };
