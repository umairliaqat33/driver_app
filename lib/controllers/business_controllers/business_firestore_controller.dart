import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:driver_app/repositories/firestore_repository.dart';
import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/repositories/business_repository/business_firestore_repository.dart';
import 'package:driver_app/utils/enums.dart';

class BusinessFirestoreController {
  final BusinessFirestoreRepository _businessFirestoreRepository =
      BusinessFirestoreRepository();

  Future<BusinessModel?> getBusinessData() async {
    User? user = FirestoreRepository.checkUser();
    return _businessFirestoreRepository.getBusinessData(
      user!.uid,
      UserType.business,
    );
  }

  Future<BusinessModel?> getSpecificBusinessData(String id) async {
    return _businessFirestoreRepository.getSpecificBusinessData(id);
  }

  Future<void> uploadBusinessData(BusinessModel businessModel) async {
    _businessFirestoreRepository.postBusinessDetailsToFirebase(
      businessModel,
      UserType.business,
    );
  }

  Future<void> updateBusinessData(BusinessModel businessModel) async {
    try {
      _businessFirestoreRepository.updateData(businessModel);
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<QuerySnapshot> getBusinesses(List<String>? documentIds) {
    return _businessFirestoreRepository.getBusinesses(documentIds);
  }
}
