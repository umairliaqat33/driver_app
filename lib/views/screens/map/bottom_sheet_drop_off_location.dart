// ignore_for_file: unused_element, use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_app/services/location_search.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/views/screens/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';

import '../../../config/size_config.dart';
import '../../../utils/assets.dart';
import '../../widgets/others/back_arrow_app_bar.dart';
import '../../widgets/text_fields/text_field_widget.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/map/location_selection_screen.dart';
import 'package:driver_app/utils/strings.dart';

class BottomSheetDropOffLocation extends StatelessWidget {
  final bool isDropOff;
  final VehicleType? vehicleType;
  final String? pickUpAddress;
  final String? dropOffAddress;
  final GeoPoint? dropOffLocation;
  final GeoPoint? pickUpLocation;
  const BottomSheetDropOffLocation({
    super.key,
    required this.isDropOff,
    this.vehicleType,
    this.dropOffAddress,
    this.pickUpAddress,
    this.dropOffLocation,
    this.pickUpLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(
            double.infinity,
            (SizeConfig.height12(context) * 4),
          ),
          child: const _BottomSheetDropOffAppBar(),
        ),
        body: Column(
          children: <Widget>[
            _DropOffLocationContainer(
              isDropOff: isDropOff,
              vehicleType: vehicleType ?? VehicleType.all,
              dropOffAddress: dropOffAddress,
              pickUpAddress: pickUpAddress,
              dropOffLocation: dropOffLocation,
              pickUpLocation: pickUpLocation,
            ),
            Expanded(child: _RecentDeliveriesContainer()),
          ],
        ));
  }
}

class _BottomSheetDropOffAppBar extends StatelessWidget {
  const _BottomSheetDropOffAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BackArrowAppbar(
      fontSize: 16,
      textColor: appTextColor,
      text: AppStrings.dropOffLocation,
      picture: Assets.arrowBack,
      onPressed: () {
        Navigator.of(context).pop();
      },
      appBarColor: backgroundColor,
      elevation: 1,
    );
  }
}

class _DropOffLocationContainer extends StatelessWidget {
  final bool isDropOff;
  final VehicleType vehicleType;
  final String? dropOffAddress;
  final String? pickUpAddress;
  final GeoPoint? dropOffLocation;
  final GeoPoint? pickUpLocation;
  const _DropOffLocationContainer({
    super.key,
    required this.isDropOff,
    required this.vehicleType,
    this.dropOffAddress,
    this.pickUpAddress,
    this.dropOffLocation,
    this.pickUpLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 18,
        right: 18,
      ),
      child: Column(children: <Widget>[
        _TextFieldLocationWidget(
          vehicleType: vehicleType,
          dropOffAddress: dropOffAddress,
          pickUpAddress: pickUpAddress,
          isDropOff: isDropOff,
        ),
        _ChooseOnMapListTile(
          vehicleType: vehicleType,
          isDropOff: isDropOff,
          dropOffLocation: pickUpLocation,
          pickUpLocation: dropOffLocation,
          dropOffAddress: dropOffAddress,
          pickUpAddress: pickUpAddress,
        )
      ]),
    );
  }
}

class _TextFieldLocationWidget extends StatefulWidget {
  final bool isDropOff;
  String? pickUpAddress;
  String? dropOffAddress;
  GeoPoint? dropOffLocation;
  GeoPoint? pickUpLocation;
  final VehicleType vehicleType;
  _TextFieldLocationWidget({
    super.key,
    required this.isDropOff,
    required this.vehicleType,
    this.dropOffAddress,
    this.pickUpAddress,
  });

  @override
  State<_TextFieldLocationWidget> createState() =>
      _TextFieldLocationWidgetState();
}

class _TextFieldLocationWidgetState extends State<_TextFieldLocationWidget> {
  final TextEditingController textController = TextEditingController();
  String _sessionToken = "";
  List<dynamic> locationsList = [];
  @override
  void initState() {
    super.initState();
    if (widget.isDropOff) {
      textController.text = widget.dropOffAddress ?? "";
    } else {
      textController.text = widget.pickUpAddress ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFieldWidget(
          icon: Assets.dropOffLocationIcon,
          hintText: "Drop off location",
          textController: textController,
          validator: (value) {
            if (textController.text.isEmpty) {
              return AppStrings.dropOffLocation;
            }
            return null;
          },
          enabled: true,
          onChanged: (value) async {
            await getSuggestions(value);
            log(locationsList.toString());
          },
        ),
        Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.height20(context) * 2,
          ),
          child: _locationsListViewBuilder(
            widget.vehicleType,
          ),
        ),
      ],
    );
  }

  SizedBox _locationsListViewBuilder(VehicleType vehicleType) {
    return SizedBox(
      height: locationsList.length * 20,
      child: ListView.builder(
        itemCount: locationsList.length,
        itemBuilder: (context, int index) {
          return Container(
            color: backgroundColor,
            child: Card(
              child: ListTile(
                onTap: (() {
                  textController.text = locationsList[index]['description'];
                  _onTileTap(locationsList[index]['description'], vehicleType);
                }),
                title: Text(
                  locationsList[index]['description'],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onTileTap(String address, VehicleType vehicleType) async {
    var locations = await locationFromAddress(address);
    if (widget.isDropOff) {
      widget.dropOffAddress = address;
    } else {
      widget.pickUpAddress = address;
    }
    textController.text = address;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarScreen(
            index: 0,
            dropOffLocation: widget.isDropOff
                ? GeoPoint(
                    locations.last.latitude,
                    locations.last.longitude,
                  )
                : widget.dropOffLocation,
            vehicleType: vehicleType,
            dropOffAddress: widget.isDropOff ? address : widget.dropOffAddress,
            pickUpLocation: widget.isDropOff
                ? GeoPoint(
                    locations.last.latitude,
                    locations.last.longitude,
                  )
                : widget.pickUpLocation,
            pickUpAddress: widget.isDropOff ? widget.pickUpAddress : address,
          ),
        ),
        (route) => false);
  }

  Future<void> getSuggestions(String input) async {
    var uuid = const Uuid();
    if (_sessionToken.isEmpty) {
      _sessionToken = uuid.v4();
    }
    locationsList = await LocationSearch.getSuggestions(input, _sessionToken);
    if (!mounted) return;
    setState(() {});
  }
}

class _ChooseOnMapListTile extends StatelessWidget {
  final bool isDropOff;
  final GeoPoint? dropOffLocation;
  final GeoPoint? pickUpLocation;
  final String? dropOffAddress;
  final String? pickUpAddress;
  final VehicleType vehicleType;
  const _ChooseOnMapListTile({
    required this.vehicleType,
    required this.isDropOff,
    this.dropOffLocation,
    this.pickUpLocation,
    this.dropOffAddress,
    this.pickUpAddress,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LocationSelectionScreen(
              vehicleType: vehicleType,
              isDropOff: isDropOff,
              dropOffLocation: pickUpLocation,
              pickUpLocation: dropOffLocation,
              dropOffAddress: dropOffAddress,
              pickUpAddress: pickUpAddress,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 4, top: 8),
        child: Row(children: <Widget>[
          SvgPicture.asset(Assets.chooseOnMapBlue),
          const SizedBox(width: 22),
          Text(
            AppStrings.chooseOnMap,
            style: const TextStyle(
              fontSize: 14,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          )
        ]),
      ),
    );
  }
}

class _RecentDeliveriesContainer extends StatelessWidget {
  final List<String> recentDeliveries = ["Sample", "Sample", "Sample"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, left: 18, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Text(
              AppStrings.recentDeliveries,
              style: const TextStyle(
                  color: greyColor, fontWeight: FontWeight.w400, fontSize: 12),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: recentDeliveries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      recentDeliveries[index],
                      style: const TextStyle(
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
