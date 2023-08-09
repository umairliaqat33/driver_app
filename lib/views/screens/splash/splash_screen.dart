// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:driver_app/controllers/request_controller/business_request_controller/business_request_controller.dart';
import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/global.dart';
import 'package:driver_app/views/screens/ride_in_progress/ride_in_progress.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/views/screens/auth/components/auth_decision_screen.dart';
import 'package:driver_app/views/screens/bottom_navigation_bar/bottom_navigation_bar_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  BusinessRequestController businessRequestController =
      BusinessRequestController();
  BusinessRequestModel? businessRequestModel;
  @override
  void initState() {
    super.initState();
    _gotoNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [
              Color(0xff1B73EF),
              Color(0xff124B9B),
            ],
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            Assets.appLogoWhite,
          ),
        ),
      ),
    );
  }

  void _gotoNextScreen() {
    Future.delayed(Duration.zero, () async {
      businessRequestModel =
          await businessRequestController.getActiveBusinessRequest(getUid());
      String? doIdExist = businessRequestModel?.acceptorDriverId;
      if (getUid() == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthDecisionScreen(),
          ),
        );
      } else if (getUserType() == UserType.business.name &&
          businessRequestModel != null &&
          doIdExist!.isNotEmpty &&
          businessRequestModel!.isRideCompleted == false) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => RideInProgressScreen(
                businessRequestModel: businessRequestModel!,
              ),
            ),
            (route) => false);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigationBarScreen(),
          ),
        );
      }
    });
  }
}
