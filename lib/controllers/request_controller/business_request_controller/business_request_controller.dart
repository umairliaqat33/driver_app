import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/repositories/request_repository/business_request_repository/business_request_repository.dart';

class BusinessRequestController {
  final BusinessRequestRepository _requestRepository =
      BusinessRequestRepository();

  void uploadBusinessRequest(BusinessRequestModel request) async {
    await _requestRepository.createRequest(request);
  }

  Stream<List<BusinessRequestModel?>> getBusinessRequestsStream(
      String riderType) {
    return _requestRepository.getBusinessRequestStream(riderType);
  }

  Stream<QuerySnapshot> getBusinessesRequests(String? riderType) {
    return _requestRepository.getBusinessesRequests(riderType);
  }

  Future<BusinessRequestModel?> getActiveBusinessRequest(String? businessId) {
    return _requestRepository.getActiveBusinessRequest(businessId);
  }

  Future<void> cancelBusinessRequest(String documentId) async {
    return _requestRepository.cancelBusinessRequest(documentId);
  }

  Future<void> declineBusinessOffer(String documentId) async {
    return _requestRepository.declineBusinessOffer(documentId);
  }

  Stream<QuerySnapshot> getStreamOfNormalReq() {
    return _requestRepository.getBusinessReqNormalStream();
  }

  Stream<DocumentSnapshot?> getSpecBusinessReqStream(String businessReqId) {
    return _requestRepository.getSpecBusinessReqStream(businessReqId);
  }
}
