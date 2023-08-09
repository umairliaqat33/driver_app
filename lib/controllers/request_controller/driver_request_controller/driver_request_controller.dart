import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_app/models/request_models/driver_request_model/driver_request_model.dart';
import 'package:driver_app/repositories/request_repository/driver_request_repository/driver_request_repository.dart';

class DriverRequestController {
  final DriverRequestRepository _driverRequestRepository =
      DriverRequestRepository();

  Future<void> sendDriverRequest(
      DriverRequestModel requestModel, String businessRequestId) async {
    return _driverRequestRepository.sendDriverRequest(
      requestModel,
      businessRequestId,
    );
  }

  Future<void> declineDriverOffer(String documentId) async {
    return _driverRequestRepository.declineDriverOffer(documentId);
  }

  Stream<List<DriverRequestModel>> getDriverRequests(
    String businessRequestId,
  ) {
    return _driverRequestRepository.getDriverRequests(businessRequestId);
  }

  Future<DriverRequestModel?> getAccDriverRequest(
    String businessReqId,
    String driverReqId,
  ) {
    return _driverRequestRepository.getAccDriverReq(
      businessReqId,
      driverReqId,
    );
  }

  Stream<DocumentSnapshot?> getSpecDriverReqStream(
      String driverReqId, String businessReqId) {
    return _driverRequestRepository.getSpecDriverReqStream(
      driverReqId,
      businessReqId,
    );
  }

  Future<void> deleteAllDriverReq(String businessId) async {
    _driverRequestRepository.deleteAllDriverRequests(businessId);
  }
}
