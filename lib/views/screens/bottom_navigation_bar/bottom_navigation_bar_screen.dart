import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_app/utils/global.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/widgets/others/circular_loader_widget.dart';
import 'package:driver_app/repositories/firestore_repository.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/views/screens/home/home_screen.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/views/screens/notification_screen/notification_screen.dart';
import 'package:driver_app/views/screens/profile_screen/profile_screen.dart';
import 'package:driver_app/views/screens/wallet_screen/wallet_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  final int index;
  final VehicleType? vehicleType;
  final GeoPoint? dropOffLocation;
  final GeoPoint? pickUpLocation;
  final String? pickUpAddress;
  final String? dropOffAddress;
  const BottomNavigationBarScreen({
    super.key,
    this.index = 0,
    this.vehicleType,
    this.dropOffAddress,
    this.dropOffLocation,
    this.pickUpAddress,
    this.pickUpLocation,
  });

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  List<Widget> _btmItems = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    _checkUserType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onNavBarButtonTap,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? SvgPicture.asset(Assets.bottomNavBarHomeFilledIcon)
                : SvgPicture.asset(
                    Assets.bottomNavBarHomeUnFilledIcon,
                    color: greyColor.withOpacity(0.5),
                  ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? SvgPicture.asset(Assets.bottomNavBarWalletFilledIcon)
                : SvgPicture.asset(
                    Assets.bottomNavBarWalletUnFilledIcon,
                    color: greyColor.withOpacity(0.5),
                  ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? SvgPicture.asset(Assets.bottomNavBarNotificationFilledIcon)
                : SvgPicture.asset(
                    Assets.bottomNavBarNotificationUnfilledIcon,
                    color: greyColor.withOpacity(0.5),
                  ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? SvgPicture.asset(Assets.bottomNavBarFilledProfileIcon)
                : SvgPicture.asset(
                    Assets.bottomNavBarUnFilledProfileIcon,
                    color: greyColor.withOpacity(0.5),
                  ),
            label: "",
          ),
        ],
      ),
      body: _btmItems.isEmpty
          ? const CircularLoaderWidget()
          : Center(
              child: _btmItems.elementAt(_selectedIndex),
            ),
    );
  }

  void _onNavBarButtonTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setList() {
    _btmItems = <Widget>[
      HomeScreen(
        vehicleType: widget.vehicleType,
        dropOffAddress: widget.dropOffAddress,
        dropOffLocation: widget.dropOffLocation,
        pickUpAddress: widget.pickUpAddress,
        pickUpLocation: widget.pickUpLocation,
      ),
      const WalletScreen(),
      const NotificationScreen(),
      const ProfileScreen(),
    ];
    setState(() {});
  }

  void _checkUserType() async {
    try {
      UserType? userType = await FirestoreRepository.checkUserType();
      setUserType(userType!.name);
      _setList();
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }
}
