import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'business_model.g.dart';

@JsonSerializable()
class BusinessModel {
  final String email;
  final String? uid;
  final String? name;
  final String? pointOfContact;
  final String? location;
  final String? number;
  final String? imageLink;
  final String? approvalStatus;

  BusinessModel({
    required this.email,
    this.name,
    this.uid,
    this.number,
    this.location,
    this.pointOfContact,
    this.imageLink,
    this.approvalStatus,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessModelToJson(this);

  factory BusinessModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return BusinessModel(
      email: data?['email'],
      name: data?['name'],
      uid: data?['uid'],
      number: data?['number'],
      location: data?['location'],
      pointOfContact: data?['pointOfContact'],
      imageLink: data?['imageLink'],
      approvalStatus: data?['approvalStatus'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email.isNotEmpty) "email": email,
      if (name != null) "name": name,
      if (uid != null) "uid": uid,
      if (number != null) "number": number,
      if (location != null) "location": location,
      if (pointOfContact != null) "pointOfContact": pointOfContact,
      if (imageLink != null) "imageLink": imageLink,
      if (approvalStatus != null) "approvalStatus": approvalStatus,
    };
  }
}
