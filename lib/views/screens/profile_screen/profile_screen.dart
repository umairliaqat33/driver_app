// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/models/user_data.dart';
import 'package:driver_app/models/users/user_model.dart';
import 'package:driver_app/repositories/user_repository/user_repository.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/global.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:driver_app/views/screens/settings_screen/settings_screen.dart';
import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/profile_screen/components/info_card.dart';
import 'package:driver_app/views/screens/profile_screen/components/progress_card.dart';
import 'package:driver_app/views/screens/profile_screen/components/tile_widget.dart';
import 'package:driver_app/views/screens/edit_profiles/edit_profile_screen.dart';
import 'package:driver_app/controllers/driver_controller/driver_firestore_controller.dart';
import 'package:driver_app/controllers/business_controllers/business_firestore_controller.dart';
import 'package:driver_app/views/screens/edit_profiles/edit_business.dart';
import 'package:driver_app/views/widgets/others/circular_loader_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData;
  UserModel? _userModel;
  BusinessModel? _businessModel;
  DriverModel? _driverModel;
  String? imageLink;
  String name = "";
  String email = "";
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: backgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: appTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          _EditProfileButton(userData: userData),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.height12(context),
            ),
            child: Center(
              child: userData == null
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularLoaderWidget(),
                    )
                  : InfoCard(
                      name: name,
                      email: email,
                      imageLink: imageLink,
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => (getUserType() == UserType.business.name
                    ? onBusinessTap()
                    : null),
                child: _createProgressCard(getUserType()!, 0),
              ),
              SizedBox(
                width: SizeConfig.width8(context) * 2,
              ),
              _createProgressCard(getUserType()!, 1),
            ],
          ),
          SizedBox(
            height: SizeConfig.height8(context) * 2,
          ),
          TileWidget(
            text: "Settings",
            trailingImg: Assets.arrowForwardHead,
            onTap: () async => _settingsScreen(),
            cardColor: backgroundColor,
            leadingImg: Assets.settingsIcon,
            titleTextColor: appTextColor,
          ),
          TileWidget(
            text: getUserType() == UserType.driver.name
                ? AppStrings.favoriteBusinesses
                : AppStrings.favoriteDrivers,
            trailingImg: Assets.arrowForwardHead,
            onTap: null,
            cardColor: backgroundColor,
            leadingImg: Assets.favoriteIcon,
            titleTextColor: appTextColor,
          ),
          const TileWidget(
            text: "Help",
            trailingImg: Assets.arrowForwardHead,
            onTap: null,
            cardColor: backgroundColor,
            leadingImg: Assets.helpIcon,
            titleTextColor: appTextColor,
          ),
        ],
      ),
    );
  }

  void onBusinessTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditBusinessScreen(userData: userData),
      ),
    );
  }

  Future<void> _getDriverData() async {
    final DriverFirestoreController driverFirestoreController =
        DriverFirestoreController();
    userData = UserData<DriverModel>();
    try {
      _userModel = await _userRepository.getUserInformation();
      final value = await driverFirestoreController.getData();
      _driverModel = value;
      if (value == null) {
        userData = UserData<UserModel>;
        userData = _userModel;
        name = _userModel!.userName;
        email = _userModel!.email;
        setState(() {});
        return;
      }
      userData.data = value;
      imageLink = _driverModel!.profileImageLink;
      email = _driverModel!.email;
      name = _driverModel!.name!;
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _getBusinessData() async {
    final BusinessFirestoreController businessFirestoreController =
        BusinessFirestoreController();
    userData = UserData<BusinessModel>();
    try {
      _userModel = await _userRepository.getUserInformation();
      final value = await businessFirestoreController.getBusinessData();
      _businessModel = value;
      if (value == null) {
        userData = UserData<UserModel>;
        userData = _userModel;
        name = _userModel!.userName;
        email = _userModel!.email;
        setState(() {});
        return;
      }
      userData.data = value;
      imageLink = _businessModel!.imageLink;
      email = _businessModel!.email;
      name = _businessModel!.name!;
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  void _getData() {
    if (getUserType() == UserType.driver.name) {
      _getDriverData();
    } else {
      _getBusinessData();
    }
  }

  Future<void> _settingsScreen() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          userModel: _userModel,
        ),
      ),
    );
  }

  ProgressCard _createProgressCard(String userRole, int position) {
    String image;
    String data;
    if (userRole == AppStrings.roleBusiness) {
      if (position == 0) {
        image = Assets.iconParkSolid;
        data = AppStrings.roleBusiness;
      } else {
        image = Assets.iconBoldTruck;
        data = AppStrings.subscription;
      }
    } else {
      if (position == 0) {
        image = Assets.smallTickMark;
        data =
            //  userData.data == null ? "0 Jobs done" :
            "83 jobs";
      } else {
        image = Assets.smallStar;
        data =
            //  userData.data == null ? "0/0" :
            "4.5/5";
      }
    }
    return ProgressCard(
      imageLink: image,
      text: data,
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({
    required this.userData,
  });

  final userData;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(
              userData: userData,
            ),
          ),
        );
      },
      child: const Text(
        "Edit Profile",
        style: TextStyle(
          color: primaryColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
