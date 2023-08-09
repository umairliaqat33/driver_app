import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:driver_app/repositories/firestore_repository.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/repositories/driver_repository/driver_firestore_repository.dart';
import 'package:driver_app/utils/enums.dart';

class DriverFirestoreController {
  final DriverFirestoreRepository _driverFirestoreRepository =
      DriverFirestoreRepository();

  Future<DriverModel?> getData() async {
    User? user = FirestoreRepository.checkUser();

    return _driverFirestoreRepository.getData(
      user!.uid,
      UserType.driver,
    );
  }

  Future<DriverModel?> getSpecificUserData(
    String id,
  ) async {
    return _driverFirestoreRepository.getSpecificUserData(
      id,
    );
  }

  Future<void> uploadData(DriverModel driverModel) async {
    _driverFirestoreRepository.postDetailsToFirebase(
        driverModel, UserType.driver);
  }

  Future<void> updateDriverData(DriverModel driverModel) async {
    try {
      _driverFirestoreRepository.updateData(driverModel);
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<QuerySnapshot> getDrivers(List<String>? documentIds) {
    return _driverFirestoreRepository.getDrivers(documentIds);
  }
}
