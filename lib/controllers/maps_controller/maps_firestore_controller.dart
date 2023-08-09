import 'package:driver_app/models/location_model/location_model.dart';
import 'package:driver_app/repositories/maps/maps_repository.dart';

class MapsFirestoreController {
  final MapsRepository _mapsFirestoreRepository = MapsRepository();

  Stream<List<LocationModel?>> getAllAvailableDrivers() {
    return _mapsFirestoreRepository.getAllAvailableDrivers();
  }

  void updateLocationData(LocationModel locationModel) {
    _mapsFirestoreRepository.updateLocationData(locationModel);
  }

  Future<LocationModel?> getUserLocation(String uid) async {
    return await _mapsFirestoreRepository.getUserLocation(uid);
  }
}
