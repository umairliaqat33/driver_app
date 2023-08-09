import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/models/request_models/driver_request_model/driver_request_model.dart';

class LocalRequestModel<T> {
  final List<BusinessRequestModel>? businessRequestList;
  final List<DriverRequestModel>? driverRequestList;
  final List<T>? roleModelList;

  LocalRequestModel({
    this.businessRequestList,
    this.roleModelList,
    this.driverRequestList,
  });
}
