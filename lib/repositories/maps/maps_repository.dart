import 'package:driver_app/models/location_model/location_model.dart';
import '../firestore_repository.dart';

class MapsRepository {
  final FirestoreRepository _firestoreRepository = FirestoreRepository();

  Stream<List<LocationModel?>> getAllAvailableDrivers() {
    return _firestoreRepository.getAllAvailableDrivers();
  }

  void updateLocationData(LocationModel locationModel) {
    _firestoreRepository.updateLatestLocation(locationModel);
  }

  Future<LocationModel?> getUserLocation(String uid) async {
    return await _firestoreRepository.getUserLocation(uid);
  }
}
