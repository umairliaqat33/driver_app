import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_app/views/widgets/others/circular_loader_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/controllers/global_controller.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/views/screens/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/others/back_arrow_app_bar.dart';

class LocationSelectionScreen extends StatefulWidget {
  final VehicleType? vehicleType;
  final bool isDropOff;
  final String? dropOffAddress;
  final String? pickUpAddress;
  final GeoPoint? dropOffLocation;
  final GeoPoint? pickUpLocation;
  const LocationSelectionScreen({
    super.key,
    required this.isDropOff,
    this.vehicleType,
    this.dropOffAddress,
    this.pickUpAddress,
    this.dropOffLocation,
    this.pickUpLocation,
  });

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  LatLng _center = const LatLng(37.421922, -122.084170);
  late GoogleMapController _mapController;
  late String _mapStyle;
  String _newAddress = "";
  LatLng _newLocation = const LatLng(37.421922, -122.084170);
  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBarWidget(
          context,
          widget.vehicleType ?? VehicleType.all,
          _newAddress,
          widget.isDropOff,
          GeoPoint(_newLocation.latitude, _newLocation.longitude),
          widget.dropOffLocation,
          widget.pickUpLocation,
          widget.dropOffAddress,
          widget.pickUpAddress,
        ),
        body: _locationStackWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.height20(context) * 4),
          child: FloatingActionButton.small(
            backgroundColor: backgroundColor,
            onPressed: () => _getCenter(),
            child: _newAddress.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularLoaderWidget(),
                  )
                : SvgPicture.asset(
                    Assets.currentLocationImage,
                    fit: BoxFit.fill,
                    width: SizeConfig.width15(context) * 1.5,
                    height: SizeConfig.height15(context) * 1.5,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _googleMapWidget() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 18,
      ),
      onCameraIdle: () {
        _getAddress(_newLocation);
      },
      onMapCreated: _onMapCreated,
      rotateGesturesEnabled: false,
      zoomControlsEnabled: false,
      onCameraMove: (position) {
        _newLocation = position.target;
      },
    );
  }

  Stack _locationStackWidget() {
    return Stack(
      children: [
        _googleMapWidget(),
        const _PinMarkerWidget(),
        _DoneButton(
          context: context,
          vehicleType: widget.vehicleType,
          pickUpAddress: widget.pickUpAddress,
          pickUpLocation: widget.pickUpLocation,
          dropOffAddress: widget.dropOffAddress,
          dropOffLocation: widget.dropOffLocation,
          isDropOff: widget.isDropOff,
          address: _newAddress,
          location: GeoPoint(_newLocation.latitude, _newLocation.longitude),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    log('came in mapCreated');
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
    _getCenter();
  }

  void _getCenter() {
    Future.delayed(Duration.zero, () async {
      try {
        log('came in getCenter');
        Position? position = await GlobalController.getLocation();

        if (position == null) {
          log("position is null");
          return;
        }
        setState(() {
          _center = LatLng(
            position.latitude,
            position.longitude,
          );
          _newLocation = LatLng(position.latitude, position.longitude);
          _mapController.animateCamera(
            CameraUpdate.newLatLng(_center),
          );
        });
      } catch (e) {
        log(e.toString());
        log("something went wrong in get center function");
      }
    });
  }

  Future<void> _getAddress(LatLng position) async {
    List<Placemark> placeMark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark address = placeMark[0];
    _newAddress =
        "${address.street}, ${address.subLocality},${address.locality},${address.administrativeArea}";
    if (!mounted) return;
    setState(() {});
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton({
    Key? key,
    required this.location,
    required this.context,
    required this.vehicleType,
    required this.address,
    required this.isDropOff,
    this.dropOffLocation,
    this.pickUpLocation,
    this.dropOffAddress,
    this.pickUpAddress,
  }) : super(key: key);

  final BuildContext context;
  final VehicleType? vehicleType;
  final bool isDropOff;
  final GeoPoint? dropOffLocation;
  final GeoPoint? pickUpLocation;
  final String? dropOffAddress;
  final String? pickUpAddress;
  final String address;
  final GeoPoint location;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
            left: (SizeConfig.width15(context) + 1),
            right: (SizeConfig.width15(context) + 1),
            bottom: SizeConfig.height15(context) * 2),
        child: CustomButton(
            color: primaryColor,
            textColor: whiteColor,
            text: "DONE",
            onTap: () => onTap()),
      ),
    );
  }

  void onTap() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => BottomNavigationBarScreen(
          index: 0,
          vehicleType: vehicleType,
          dropOffLocation: isDropOff ? location : dropOffLocation,
          pickUpLocation: isDropOff ? pickUpLocation : location,
          dropOffAddress: isDropOff ? address : dropOffAddress,
          pickUpAddress: isDropOff ? pickUpAddress : address,
        ),
      ),
      (route) => false,
    );
  }
}

class _PinMarkerWidget extends StatelessWidget {
  const _PinMarkerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        Assets.pickupLocationPinIcon,
        width: 40,
      ),
    );
  }
}

PreferredSize _appBarWidget(
  BuildContext context,
  VehicleType vehicleType,
  String address,
  bool isDropOff,
  GeoPoint location,
  GeoPoint? dropOffLocation,
  GeoPoint? pickUpLocation,
  String? dropOffAddress,
  String? pickUpAddress,
) {
  return PreferredSize(
    preferredSize: Size(
      double.infinity,
      (SizeConfig.height12(context) * 4),
    ),
    child: address.isEmpty
        ? const CircularLoaderWidget()
        : BackArrowAppbar(
            picture: Assets.arrowBack,
            fontSize: SizeConfig.font16(context),
            textColor: appTextColor,
            text: address,
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationBarScreen(
                      index: 0,
                      vehicleType: vehicleType,
                      dropOffLocation: dropOffLocation,
                      pickUpLocation: pickUpLocation,
                      dropOffAddress: isDropOff ? address : dropOffAddress,
                      pickUpAddress: isDropOff ? pickUpAddress : address,
                    ),
                  ),
                  (route) => false);
            },
            appBarColor: backgroundColor,
            elevation: 1,
          ),
  );
}

class LocationScreenFloatingActionButton extends StatelessWidget {
  final Function getCenter;
  final String address;

  const LocationScreenFloatingActionButton({
    super.key,
    required this.getCenter,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      backgroundColor: backgroundColor,
      onPressed: () => getCenter(),
      child: address.isEmpty
          ? const CircularLoaderWidget()
          : SvgPicture.asset(
              Assets.currentLocationImage,
              fit: BoxFit.fill,
              width: SizeConfig.width15(context) * 1.5,
              height: SizeConfig.height15(context) * 1.5,
            ),
    );
  }
}
