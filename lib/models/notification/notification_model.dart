import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class NotificationModel {
  String asset;
  String title;
  String description;
  String? time;

  NotificationModel({
    required this.asset,
    required this.title,
    required this.description,
    required this.time,
  });
}