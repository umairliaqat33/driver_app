// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison
import 'dart:developer';

import 'package:driver_app/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/services/distance_matrix_api.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/constants.dart';
import 'package:driver_app/controllers/global_controller.dart';
import 'package:driver_app/models/location_model/location.dart';
import 'package:driver_app/models/location_model/location_model.dart';
import 'package:driver_app/controllers/maps_controller/maps_firestore_controller.dart';

class MapScreen extends StatefulWidget {
  final VehicleType? vehicleType;
  final GeoPoint? destination;
  final GeoPoint? pickupLocation;
  final String? driverId;
  const MapScreen({
    super.key,
    required this.vehicleType,
    this.driverId,
    this.destination,
    this.pickupLocation,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  String? _mapStyle;
  final PolylinePoints _polylinePoints = PolylinePoints();
  GoogleMapController? _mapController;

  final Set<LatLng> _polyLineCoordinates = {};
  List<LocationModel?> _locationModelList = [];
  final Set<Polyline> _polyline = {};
  final Set<Marker> _globalMarkers = {};
  final Set<Marker> _currentLocationMarkers = {};
  final Set<Marker> _vehicleMarkers = {};
  Location? _driverLocation;
  LatLng _center = const LatLng(37.421922, -122.084170);
  final _mapsFirestoreController = MapsFirestoreController();
  // bool _isLoading = false;
  Position? businessLocation;
  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map.txt').then((string) {
      _mapStyle = string;
    });
    if (UserType.business.name == getUserType() || widget.driverId != null) {
      _getCurrentCenterCreatePolyline();
    }
  }

  @override
  void dispose() {
    _mapController!.dispose();
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _globalMarkers.clear();
    // _vehicleMarkers.clear();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: backgroundColor,
        onPressed: () => _getCurrentCenterCreatePolyline(),
        child: SvgPicture.asset(
          Assets.currentLocationImage,
          fit: BoxFit.fill,
          width: SizeConfig.width15(context) * 1.5,
          height: SizeConfig.height15(context) * 1.5,
        ),
      ),
      body: StreamBuilder<List<LocationModel?>>(
        stream: _mapsFirestoreController.getAllAvailableDrivers(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<LocationModel?>> locationSnapshot,
        ) {
          if (locationSnapshot.connectionState == ConnectionState.waiting) {}

          if (locationSnapshot.hasData) {
            if (widget.vehicleType == VehicleType.all) {
              _locationModelList = locationSnapshot.requireData;
            } else {
              _locationModelList = locationSnapshot.data!
                  .where((element) =>
                      element?.vehicleType == widget.vehicleType?.name)
                  .toList();
            }
            _createMarkers();
          }

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 16,
                ),
                onMapCreated: _onMapCreated,
                markers: _globalMarkers,
                polylines: _polyline,
                zoomControlsEnabled: false,
                onTap: (value) {
                  _customInfoWindowController.hideInfoWindow!();
                },
                // onCameraMove: (value) {
                //   _customInfoWindowController.onCameraMove!();
                // },
              ),
              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: SizeConfig.height15(context) + 1,
                width: SizeConfig.width15(context) * 6,
                offset: 15,
              )
            ],
          );
        },
      ),
    );
  }

  void _getCurrentCenterCreatePolyline() async {
    if (!mounted) return;
    try {
      Uint8List currentLocMarker = await GlobalController.getImageFromBytes(
        25,
        Assets.currentLocationMarker,
      );
      Uint8List pointAMarker = await GlobalController.getImageFromBytes(
        25,
        Assets.pointALocation,
      );
      Uint8List pointBMarker = await GlobalController.getImageFromBytes(
        25,
        Assets.pointBLocation,
      );
      businessLocation = await GlobalController.getLocation();

      if (businessLocation == null && widget.pickupLocation == null) {
        log("position is null");
        setState(() {});
        return;
      } else {
        setState(() {});
      }

      final pickUpLat =
          widget.pickupLocation?.latitude ?? businessLocation!.latitude;
      final pickUpLon =
          widget.pickupLocation?.longitude ?? businessLocation!.longitude;
      final destLat = widget.destination?.latitude;
      final destLon = widget.destination?.longitude;
      String? distanceFromAToDriver;
      String? duration;
      if (_driverLocation != null) {
        distanceFromAToDriver = await DistanceMatrixAPI.getDistance(
          Location(
            latitude: pickUpLat,
            longitude: pickUpLon,
          ),
          Location(
            latitude: _driverLocation!.latitude,
            longitude: _driverLocation!.longitude,
          ),
        );
        duration = await DistanceMatrixAPI.getTime(
          Location(
            latitude: pickUpLat,
            longitude: pickUpLon,
          ),
          Location(
            latitude: _driverLocation!.latitude,
            longitude: _driverLocation!.longitude,
          ),
        );
      }

      _center = LatLng(pickUpLat, pickUpLon);
      _setMarkers(
        Location(
          latitude: pickUpLat,
          longitude: pickUpLon,
        ),
        widget.destination != null ? pointAMarker : currentLocMarker,
        'Current Location',
        "${distanceFromAToDriver ?? 'Current Location'}, ${duration ?? ''}",
      );

      if (widget.destination != null) {
        String distance = await DistanceMatrixAPI.getDistance(
          Location(
            latitude: pickUpLat,
            longitude: pickUpLon,
          ),
          Location(
            latitude: destLat,
            longitude: destLon,
          ),
        );
        String duration = await DistanceMatrixAPI.getTime(
          Location(
            latitude: pickUpLat,
            longitude: pickUpLon,
          ),
          Location(
            latitude: destLat,
            longitude: destLon,
          ),
        );
        _setMarkers(
          Location(
            latitude: destLat,
            longitude: destLon,
          ),
          pointBMarker,
          'Drop Off Location',
          "$distance, $duration",
        );
        _setPolyLine(
          PointLatLng(
            pickUpLat,
            pickUpLon,
          ),
          PointLatLng(
            getUserType() == UserType.driver.name
                ? _driverLocation!.latitude!
                : destLat!,
            getUserType() == UserType.driver.name
                ? _driverLocation!.longitude!
                : destLon!,
          ),
        );
      }
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(_center),
      );
    } catch (e) {
      log("something went wrong in getCenter function: ${e.toString()}");
    }
  }

  void _setMarkers(
    Location location,
    Uint8List? img,
    String markerId,
    String infoWindowText,
  ) {
    bool isImageEmpty = img == null;

    final marker = Marker(
        icon: isImageEmpty
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.fromBytes(img),
        markerId: MarkerId(markerId),
        position: LatLng(location.latitude!, location.longitude!),
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
              Container(
                decoration: const BoxDecoration(
                  color: blackColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: SizeConfig.height5(context) - 2,
                  bottom: SizeConfig.height5(context) - 2,
                  left: (SizeConfig.width5(context) + 1),
                  right: (SizeConfig.width5(context) + 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      infoWindowText,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig.font10(context) - 1,
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              LatLng(
                location.latitude!,
                location.longitude!,
              ));
        });
    (markerId == 'Current Location') || (markerId == 'Drop Off Location')
        ? _currentLocationMarkers.add(marker)
        : _vehicleMarkers.add(marker);
    if (_currentLocationMarkers.isNotEmpty) {
      _globalMarkers.addAll(_currentLocationMarkers);
    }
  }

  void _setPolyLine(
    PointLatLng from,
    PointLatLng to,
  ) async {
    try {
      PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        googleMapsApiKey,
        from,
        to,
        travelMode: TravelMode.driving,
      );

      if (result.status == 'OK') {
        for (var pointLatLng in result.points) {
          _polyLineCoordinates
              .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
        }
        setState(() {
          _polyline.add(
            Polyline(
              polylineId: const PolylineId('value'),
              visible: true,
              width: 5,
              endCap: Cap.roundCap,
              color: Colors.blue,
              points: _polyLineCoordinates.toList(),
            ),
          );
        });
      }
      log(result.status.toString());
      log("Error message on polyline creation: ${result.errorMessage.toString()}");
    } catch (e) {
      log(e.toString());
      log("something went wrong in building polylines");
    }
  }

  void _createMarkers() {
    if (_vehicleMarkers.isNotEmpty) {
      _globalMarkers.removeAll(_vehicleMarkers);
    }

    for (final model in _locationModelList) {
      if (model == null) return;

      if ((widget.driverId == null || widget.destination == null) &&
          (getUserType() == UserType.business.name)) {
        if (widget.vehicleType?.name == VehicleType.all.name &&
            widget.vehicleType?.name == model.vehicleType) {
          _addCustomUserMarker(
              Location(
                latitude: model.latitude!,
                longitude: model.longitude!,
              ),
              model.userName!,
              model.vehicleType!,
              "I have a ${model.vehicleType!}");
        } else if (widget.vehicleType?.name == VehicleType.bike.name &&
            widget.vehicleType?.name == model.vehicleType) {
          _addCustomUserMarker(
              Location(
                latitude: model.latitude!,
                longitude: model.longitude!,
              ),
              model.userName!,
              model.vehicleType!,
              "I have a ${model.vehicleType!}");
        } else {
          _addCustomUserMarker(
              Location(
                latitude: model.latitude!,
                longitude: model.longitude!,
              ),
              model.userName!,
              model.vehicleType!,
              "I have a ${model.vehicleType!}");
        }
      } else {
        if (widget.driverId == model.userId) {
          _driverLocation =
              Location(latitude: model.latitude, longitude: model.longitude);
          _addCustomUserMarker(
            Location(
              latitude: model.latitude!,
              longitude: model.longitude!,
            ),
            model.userName!,
            model.vehicleType!,
            "I am driver",
          );
        }
        if (model.userId == getUid()) {
          _addCustomUserMarker(
            Location(
              latitude: model.latitude!,
              longitude: model.longitude!,
            ),
            model.userName!,
            model.vehicleType!,
            "Current Location",
          );
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(
                model.latitude!,
                model.longitude!,
              ),
            ),
          );
        }
      }
    }
    _globalMarkers.addAll(_vehicleMarkers);
  }

  void _addCustomUserMarker(
    Location location,
    String markerId,
    String vehicleType,
    String infoWindowText,
  ) async {
    bool isCar = vehicleType.toLowerCase() == VehicleType.car.name;

    Uint8List img = await GlobalController.getImageFromBytes(
      30,
      isCar ? Assets.carMarker : Assets.bikeMarker,
    );

    _setMarkers(
      location,
      img,
      markerId,
      infoWindowText,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _customInfoWindowController.googleMapController = controller;
    _mapController!.setMapStyle(_mapStyle);
  }
}
