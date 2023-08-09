import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel {
  double? latitude;
  double? longitude;
  String? userName;
  String? vehicleType;
  String? userId;
  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.userName,
    required this.vehicleType,
    required this.userId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
