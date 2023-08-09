import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:driver_app/controllers/business_controllers/business_firestore_controller.dart';
import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/business/components/business_info_screen.dart';
import 'package:driver_app/views/screens/business/components/business_subscription_screen.dart';
import 'package:driver_app/views/screens/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:driver_app/views/widgets/others/list_tile_widget.dart';

class BusinessRegistrationScreen extends StatefulWidget {
  final List<bool>? isDataCompleted;

  const BusinessRegistrationScreen({
    Key? key,
    this.isDataCompleted,
  }) : super(key: key);

  @override
  State<BusinessRegistrationScreen> createState() =>
      _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState
    extends State<BusinessRegistrationScreen> {
  final BusinessFirestoreController _businessFirestoreController =
      BusinessFirestoreController();
  List<bool> _isDataCompleted = [false, false];

  @override
  void initState() {
    super.initState();
    _gotoHomeScreen();
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
          "Registration",
          style: TextStyle(
            color: appTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const BottomNavigationBarScreen(),
                ),
              );
              log("Registration Skipped");
            },
            child: const Text(
              "Skip",
              style: TextStyle(
                color: appTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTileWidget(
                  cardColor: backgroundColor,
                  text: "Business Info",
                  img: _isDataCompleted[0]
                      ? Assets.tickFilled
                      : Assets.tickNotFilled,
                  onTap: () async {
                    BusinessModel? businessModel =
                        await _businessFirestoreController.getBusinessData();
                    if (!mounted) return;

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BusinessInfoScreen(
                          businessModel: businessModel,
                          isDataCompleted: _isDataCompleted,
                        ),
                      ),
                    );
                  },
                ),
                ListTileWidget(
                  cardColor: backgroundColor,
                  text: "Subscription",
                  img: _isDataCompleted[1]
                      ? Assets.tickFilled
                      : Assets.tickNotFilled,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BusinessSubscriptionScreen(
                          isDataCompleted: _isDataCompleted,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _gotoHomeScreen() {
    Future.delayed(Duration.zero, () {
      if (_isDataCompleted[0] && _isDataCompleted[1]) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  const BottomNavigationBarScreen(),
            ),
            (Route<dynamic> route) => false);
      }
    });
    if (widget.isDataCompleted != null) {
      _isDataCompleted = widget.isDataCompleted!;
    }
  }
}
