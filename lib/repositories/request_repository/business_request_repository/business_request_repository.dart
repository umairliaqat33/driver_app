import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/repositories/firestore_repository.dart';

class BusinessRequestRepository {
  final FirestoreRepository _firestoreRepository = FirestoreRepository();

  Future<void> createRequest(BusinessRequestModel request) async {
    await _firestoreRepository.createRequest(request);
  }

  Stream<QuerySnapshot> getBusinessesRequests(String? riderType) {
    return _firestoreRepository.getBusinessesRequests(riderType);
  }

  Stream<List<BusinessRequestModel?>> getBusinessRequestStream(
      String riderType) {
    return _firestoreRepository.getBusinessesRequestsStream(riderType);
  }

  Future<BusinessRequestModel?> getActiveBusinessRequest(String? businessId) {
    return _firestoreRepository.getActiveBusinessRequest(businessId);
  }

  Future<void> cancelBusinessRequest(String documentId) async {
    return _firestoreRepository.cancelBusinessRequest(documentId);
  }

  Future<void> declineBusinessOffer(String documentId) async {
    return _firestoreRepository.declineBusinessOffer(documentId);
  }

  Stream<QuerySnapshot> getBusinessReqNormalStream() {
    return _firestoreRepository.getBusinessRequestGeneralStream();
  }

  Stream<DocumentSnapshot?> getSpecBusinessReqStream(String businessReqId) {
    return _firestoreRepository.getSpecificBusinessReqStream(businessReqId);
  }
}
