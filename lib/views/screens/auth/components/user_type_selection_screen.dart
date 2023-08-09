// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:driver_app/models/users/user_model.dart';
import 'package:driver_app/repositories/firestore_repository.dart';
import 'package:driver_app/views/screens/business/business_registration_screen.dart';
import 'package:driver_app/views/screens/driver/driver_registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/auth/components/decision_banner.dart';
import 'package:driver_app/views/screens/auth/components/user_options.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/views/screens/auth/register/registration_screen.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  final UserCredential? userCredential;
  const UserTypeSelectionScreen({
    Key? key,
    this.userCredential,
  }) : super(key: key);

  @override
  State<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  bool _box1 = false;
  bool _box2 = false;
  final Border _border = Border.all(
    color: primaryColor,
    width: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: (SizeConfig.width8(context) * 2),
            right: (SizeConfig.width8(context) * 2),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const BannerWidget(
                  heading: "Getting started as a ",
                  logo: Assets.appLogoBlue,
                  description:
                      "Select at least one user below to get started with get driver",
                ),
                SizedBox(
                  height: (SizeConfig.height8(context) * 8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    UserOptions(
                        border: _box1 ? _border : null,
                        description:
                            'By continuing as business you can register a business and book a delivery',
                        heading: 'I’m a Business',
                        image: Assets.shopIcon,
                        function: () {
                          func1();
                          if (widget.userCredential != null) {
                            _checkAndUploadUserData(UserType.business);
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(
                                userType: UserType.business,
                              ),
                            ),
                          );
                        }),
                    UserOptions(
                      border: _box2 ? _border : null,
                      description:
                          'As driver you can register yourself and earn by delivering ',
                      heading: 'I’m a Driver',
                      image: Assets.driverIcon,
                      function: () async {
                        func2();
                        if (widget.userCredential != null) {
                          _checkAndUploadUserData(UserType.driver);
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(
                              userType: UserType.driver,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> func1() async {
    setState(() {
      _box1 = true;
      _box2 = false;
    });
  }

  Future<void> func2() async {
    setState(() {
      _box2 = true;
      _box1 = false;
    });
  }

  void _checkAndUploadUserData(UserType userType) async {
    FirestoreRepository firestoreRepository = FirestoreRepository();
    if (!await firestoreRepository
        .isUserDocumentEmpty(widget.userCredential!.user!.uid)) {
      String? email = widget.userCredential?.user!.email ??
          widget.userCredential!.user!.providerData.first.email!;
      String userName = email.substring(0, email.indexOf('@'));
      log(userName);
      firestoreRepository.uploadUserData(
        UserModel(
          email: widget.userCredential?.user!.email ??
              widget.userCredential!.user!.providerData.first.email!,
          userName: widget.userCredential?.user!.displayName ??
              widget.userCredential!.user!.providerData.first.displayName ??
              userName,
          role: userType.name,
          uid: widget.userCredential!.user!.uid,
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => userType == UserType.driver
              ? const DriverRegistrationScreen()
              : const BusinessRegistrationScreen(),
        ),
        (route) => false,
      );
      return;
    }
  }
}
