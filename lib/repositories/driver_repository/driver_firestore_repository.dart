import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/repositories/firestore_repository.dart';
import 'package:driver_app/utils/collection_names.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverFirestoreRepository {
  final FirestoreRepository _firestoreRepository = FirestoreRepository();

  Future<void> postDetailsToFirebase(
    DriverModel driverModel,
    UserType userType,
  ) async {
    try {
      await _firestoreRepository.postDetailsToFirebase(
        driverModel,
        null,
        userType,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<DriverModel?> getData(String id, UserType userType) async {
    return await _firestoreRepository.getData(id, userType);
  }

  Future<DriverModel?> getSpecificUserData(
    String id,
  ) async {
    return await _firestoreRepository.getSpecificDriverData(
      id,
    );
  }

  Future<void> updateData(DriverModel driverModel) async {
    try {
      User? user = FirestoreRepository.checkUser();
      await CollectionsNames.firestoreCollection
          .collection(CollectionsNames.driverCollection)
          .doc(user!.uid)
          .set(driverModel.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<QuerySnapshot> getDrivers(List<String>? documentIds) {
    return _firestoreRepository.getDrivers(documentIds);
  }
}
