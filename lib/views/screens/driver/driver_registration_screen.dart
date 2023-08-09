// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:driver_app/views/screens/driver/components/driver_about_you_screen.dart';
import 'package:driver_app/views/screens/driver/components/driver_payment_screen.dart';
import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/controllers/driver_controller/driver_firestore_controller.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/others/list_tile_widget.dart';
import 'package:driver_app/views/screens/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:flutter_svg/svg.dart';

class DriverRegistrationScreen extends StatefulWidget {
  final List<bool>? isDataComplete;

  const DriverRegistrationScreen({Key? key, this.isDataComplete})
      : super(key: key);

  @override
  State<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final DriverFirestoreController _driverFirestoreController =
      DriverFirestoreController();
  List<bool> _isDataComplete = [
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isDataComplete != null) {
      _isDataComplete = widget.isDataComplete!;
    }
    log(_isDataComplete[0].toString());
    log(_isDataComplete[1].toString());
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
                  text: "About you",
                  img: _isDataComplete[0]
                      ? Assets.tickFilled
                      : Assets.tickNotFilled,
                  onTap: () async {
                    DriverModel? driverModel =
                        await _driverFirestoreController.getData();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DriverAboutYouScreen(
                          driverModel: driverModel,
                          dataCompleted: _isDataComplete,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.width8(context) + 2,
                    right: (SizeConfig.width8(context) * 2) + 5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DriverPaymentScreen(
                                  isDataComplete: _isDataComplete,
                                ),
                              ),
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Payment Method',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: SizeConfig.font16(context),
                                color: blackColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        _isDataComplete[1]
                            ? Assets.tickFilled
                            : Assets.tickNotFilled,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: (SizeConfig.height15(context) * 2) + 2,
                left: (SizeConfig.width8(context) * 2),
                right: (SizeConfig.width8(context) * 2),
              ),
              child: CustomButton(
                color: primaryColor,
                textColor: whiteColor,
                text: "DONE",
                onTap: () {
                  log('done tapped');
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const BottomNavigationBarScreen(),
                      ),
                      (Route<dynamic> route) => false);
                },
                isEnabled:
                    _isDataComplete[0] && _isDataComplete[1] ? true : false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
