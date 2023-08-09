import 'package:json_annotation/json_annotation.dart';

part 'driver_request_model.g.dart';

@JsonSerializable()
class DriverRequestModel {
  bool isRideCompleted;
  final double offeredFare;
  final String requestId;
  final double pickupLocationLatitude;
  final double pickupLocationLongitude;
  final double dropOffLocationLatitude;
  final double dropOffLocationLongitude;
  final int? time;
  String? imageLink;

  DriverRequestModel({
    required this.offeredFare,
    required this.dropOffLocationLatitude,
    required this.dropOffLocationLongitude,
    required this.pickupLocationLatitude,
    required this.pickupLocationLongitude,
    required this.requestId,
    this.isRideCompleted = false,
    this.time,
    this.imageLink,
  });

  factory DriverRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DriverRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverRequestModelToJson(this);
}
