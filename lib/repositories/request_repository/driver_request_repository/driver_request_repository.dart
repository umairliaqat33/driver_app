import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_app/models/request_models/driver_request_model/driver_request_model.dart';
import 'package:driver_app/repositories/firestore_repository.dart';

class DriverRequestRepository {
  final FirestoreRepository _firestoreRepository = FirestoreRepository();

  Future<void> sendDriverRequest(
      DriverRequestModel requestModel, String businessRequestId) async {
    return _firestoreRepository.sendDriverRequest(
        requestModel, businessRequestId);
  }

  Future<void> declineDriverOffer(String documentId) async {
    _firestoreRepository.declineDriverOffer(documentId);
  }

  Future<void> deleteAllDriverRequests(String businessId) async {
    _firestoreRepository.deleteAllDriverRequest(businessId);
  }

  Stream<List<DriverRequestModel>> getDriverRequests(String businessRequestId) {
    return _firestoreRepository.getDriverRequests(businessRequestId);
  }

  Future<DriverRequestModel?> getAccDriverReq(
      String businessReqId, String driverReqId) {
    return _firestoreRepository.getAcceptedDriverRequest(
        businessReqId, driverReqId);
  }

  Stream<DocumentSnapshot?> getSpecDriverReqStream(
      String driverReqId, String businessReqId) {
    return _firestoreRepository.getSpecificDriverReqStream(
        driverReqId, businessReqId);
  }
}
