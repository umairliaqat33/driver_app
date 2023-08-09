import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/repositories/firestore_repository.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/collection_names.dart';

class BusinessFirestoreRepository {
  final FirestoreRepository _firestoreRepository = FirestoreRepository();

  Future<void> postBusinessDetailsToFirebase(
    BusinessModel businessModel,
    UserType userType,
  ) async {
    try {
      await _firestoreRepository.postDetailsToFirebase(
        null,
        businessModel,
        userType,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<BusinessModel?> getBusinessData(String id, UserType userType) async {
    return await _firestoreRepository.getData(id, userType);
  }

  Future<BusinessModel?> getSpecificBusinessData(String id) async {
    return await _firestoreRepository.getSpecificBusinessData(id);
  }

  Future<void> updateData(BusinessModel driverModel) async {
    try {
      User? user = FirestoreRepository.checkUser();
      await CollectionsNames.firestoreCollection
          .collection(CollectionsNames.businessCollection)
          .doc(user!.uid)
          .set(driverModel.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<QuerySnapshot> getBusinesses(List<String>? documentIds) {
    return _firestoreRepository.getBusinesses(documentIds);
  }
}
