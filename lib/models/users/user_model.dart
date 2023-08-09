import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String userName;
  String email;
  String role;
  String? uid;
  String? reference;

  UserModel({
    required this.email,
    required this.userName,
    required this.role,
    this.uid,
    this.reference,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
