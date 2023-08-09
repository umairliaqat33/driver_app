import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'business_request_model.g.dart';

@JsonSerializable()
class BusinessRequestModel {
  String requestId;
  bool isRideCompleted;
  bool isRideCancelled;
  final double pickupLocationLatitude;
  final double pickupLocationLongitude;
  final double dropOffLocationLatitude;
  final double dropOffLocationLongitude;
  final double fare;
  final String riderType;
  String? acceptorDriverId;
  final List<String>? declinedUsersIdList;

  BusinessRequestModel({
    required this.requestId,
    required this.isRideCancelled,
    required this.isRideCompleted,
    required this.pickupLocationLatitude,
    required this.pickupLocationLongitude,
    required this.dropOffLocationLatitude,
    required this.dropOffLocationLongitude,
    required this.fare,
    required this.riderType,
    this.acceptorDriverId,
    this.declinedUsersIdList,
  });

  factory BusinessRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessRequestModelToJson(this);

  factory BusinessRequestModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return BusinessRequestModel(
      requestId: data?['requestId'],
      pickupLocationLatitude: data?['pickupLocationLatitude'],
      pickupLocationLongitude: data?['pickupLocationLongitude'],
      dropOffLocationLatitude: data?['dropOffLocationLatitude'],
      dropOffLocationLongitude: data?['dropOffLocationLongitude'],
      fare: data?['fare'],
      riderType: data?['riderType'],
      acceptorDriverId: data?['acceptorDriverId'],
      declinedUsersIdList: data != null ? <String>['declinedUsersIdList'] : [],
      isRideCompleted: data?['isRideCompleted'],
      isRideCancelled: data?['isRideCancelled'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (requestId.isNotEmpty) 'businessId': requestId,
      if (pickupLocationLatitude.toString().isNotEmpty)
        "pickupLocationLatitude": pickupLocationLatitude,
      if (pickupLocationLongitude.toString().isNotEmpty)
        "pickupLocationLongitude": pickupLocationLongitude,
      if (dropOffLocationLatitude.toString().isNotEmpty)
        "dropOffLocationLatitude": dropOffLocationLatitude,
      if (dropOffLocationLongitude.toString().isNotEmpty)
        "dropOffLocationLongitude": dropOffLocationLongitude,
      if (fare.toString().isNotEmpty) "fare": fare,
      if (riderType.isNotEmpty) "riderType": riderType,
      if (acceptorDriverId != null) "acceptorDriverId": acceptorDriverId,
      if (declinedUsersIdList != null)
        "declinedUsersIdList": declinedUsersIdList,
    };
  }
}
