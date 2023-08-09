import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_model.g.dart';

@JsonSerializable()
class DriverModel {
  final String email;
  final String? uid;
  final String? name;
  final String? number;
  final String? address;
  final String? drivingLicense;
  final String? licenseExpiry;
  final String? dateOfBirth;
  final String? profileImageLink;
  final String? licenseFrontLink;
  final String? licenseBackLink;
  final String? vehicleNo;
  final String? vehicleType;
  final String? approvalStatus;
  final bool? hasVehicle;
  final bool? isVerified;
  final double? rating;
  final int? totalRatings;

  const DriverModel({
    required this.email,
    this.uid,
    this.name,
    this.number,
    this.address,
    this.dateOfBirth,
    this.drivingLicense,
    this.licenseExpiry,
    this.licenseBackLink,
    this.licenseFrontLink,
    this.profileImageLink,
    this.vehicleNo,
    this.vehicleType,
    this.approvalStatus,
    this.hasVehicle,
    this.isVerified,
    this.rating,
    this.totalRatings,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) =>
      _$DriverModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverModelToJson(this);

  factory DriverModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return DriverModel(
      email: data?['email'],
      uid: data?['uid'],
      name: data?['name'],
      number: data?['number'],
      address: data?['address'],
      dateOfBirth: data?['dateOfBirth'],
      drivingLicense: data?['drivingLicense'],
      licenseExpiry: data?['licenseExpiry'],
      licenseBackLink: data?['licenseBackLink'],
      licenseFrontLink: data?['licenseFrontLink'],
      profileImageLink: data?['profileImageLink'],
      vehicleNo: data?['vehicleNo'],
      vehicleType: data?['vehicleType'],
      approvalStatus: data?['approvalStatus'],
      hasVehicle: data?['hasVehicle'],
      isVerified: data?['isVerified'],
      rating: data?['rating'],
      totalRatings: data?['totalRatings'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email.isNotEmpty) "email": email,
      if (name != null) "name": name,
      if (uid != null) "uid": uid,
      if (number != null) "number": number,
      if (address != null) "address": address,
      if (dateOfBirth != null) "dateOfBirth": dateOfBirth,
      if (drivingLicense != null) "drivingLicense": drivingLicense,
      if (licenseExpiry != null) "licenseExpiry": licenseExpiry,
      if (licenseBackLink != null) "licenseBackLink": licenseBackLink,
      if (licenseFrontLink != null) "licenseFrontLink": licenseFrontLink,
      if (profileImageLink != null) "profileImageLink": profileImageLink,
      if (vehicleNo != null) "vehicleNo": vehicleNo,
      if (vehicleType != null) "vehicleType": vehicleType,
      if (approvalStatus != null) "approvalStatus": approvalStatus,
      if (hasVehicle != null) "hasVehicle": hasVehicle,
      if (isVerified != null) "isVerified": isVerified,
      if (rating != null) "rating": rating,
      if (totalRatings != null) "totalRatings": totalRatings,
    };
  }
}
