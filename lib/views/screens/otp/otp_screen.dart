// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/buttons/text_button_widget.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/views/screens/business/business_registration_screen.dart';
import 'package:driver_app/views/screens/driver/driver_registration_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final UserType userType;
  List<bool> dataCompleted;

  OTPScreen({
    Key? key,
    required this.phoneNumber,
    required this.userType,
    required this.dataCompleted,
  }) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _digit1Controller = TextEditingController();
  final TextEditingController _digit2Controller = TextEditingController();
  final TextEditingController _digit3Controller = TextEditingController();
  final TextEditingController _digit4Controller = TextEditingController();
  final TextEditingController _digit5Controller = TextEditingController();
  final TextEditingController _digit6Controller = TextEditingController();
  String verificationId = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getData(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    log("verification id");
    log(verificationId);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: (SizeConfig.width8(context) * 2),
            right: (SizeConfig.width8(context) * 2),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: (SizeConfig.height18(context) * 3.5),
                  ),
                  child: const Text(
                    "Verification",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: blackColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: (SizeConfig.height18(context) * 3.5),
                  ),
                  child: const Text(
                    "Verify your phone number",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: (SizeConfig.height5(context) - 1),
                  ),
                  child: Text(
                    "verification code send to ${widget.phoneNumber}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: greyColor,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: (SizeConfig.height20(context) * 5.5),
                  ),
                  width: (SizeConfig.width20(context) * 14.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: (SizeConfig.width8(context) * 4),
                        child: TextFieldWidget(
                          textInputType: TextInputType.number,
                          maxLength: 1,
                          hintText: "",
                          textController: _digit1Controller,
                          validator: (value) {
                            if (_digit1Controller.text.isEmpty) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: (SizeConfig.width8(context) * 4),
                        child: TextFieldWidget(
                          textInputType: TextInputType.number,
                          maxLength: 1,
                          hintText: "",
                          textController: _digit2Controller,
                          validator: (value) {
                            if (_digit2Controller.text.isEmpty) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: (SizeConfig.width8(context) * 4),
                        child: TextFieldWidget(
                          textInputType: TextInputType.number,
                          maxLength: 1,
                          hintText: "",
                          textController: _digit3Controller,
                          validator: (value) {
                            if (_digit3Controller.text.isEmpty) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: (SizeConfig.width8(context) * 4),
                        child: TextFieldWidget(
                          textInputType: TextInputType.number,
                          maxLength: 1,
                          hintText: "",
                          textController: _digit4Controller,
                          validator: (value) {
                            if (_digit4Controller.text.isEmpty) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: (SizeConfig.width8(context) * 4),
                        child: TextFieldWidget(
                          textInputType: TextInputType.number,
                          maxLength: 1,
                          hintText: "",
                          textController: _digit5Controller,
                          validator: (value) {
                            if (_digit5Controller.text.isEmpty) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: (SizeConfig.width8(context) * 4),
                        child: TextFieldWidget(
                          textInputType: TextInputType.number,
                          maxLength: 1,
                          hintText: "",
                          textController: _digit6Controller,
                          validator: (value) {
                            if (_digit6Controller.text.isEmpty) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: (SizeConfig.height12(context) * 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn’t get the code",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: greyColor,
                        ),
                      ),
                      TextButtonWidget(
                          text: "send it again",
                          onPressed: () async => _getData(widget.phoneNumber),
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.w400)
                    ],
                  ),
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
                    text: "VERIFY",
                    onTap: () async {
                      PhoneAuthCredential phoneAuthController =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode:
                                  "${_digit1Controller.text}${_digit2Controller.text}${_digit3Controller.text}${_digit4Controller.text}${_digit5Controller.text}${_digit6Controller.text}");
                      if (phoneAuthController.verificationId != null) {
                        setState(() {
                          widget.dataCompleted[0] = true;
                        });
                        log('phone verified');
                        log(widget.userType.name);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                widget.userType == UserType.driver
                                    ? DriverRegistrationScreen(
                                        isDataComplete: widget.dataCompleted)
                                    : BusinessRegistrationScreen(
                                        isDataCompleted: widget.dataCompleted,
                                      ),
                          ),
                        );
                      } else {
                        log("phone not verified");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getData(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          log("Number verified");
          log("Number verified");
          log(phoneAuthCredential.toString());
        },
        verificationFailed: (verificationFailed) async {
          log("Verification Failed${verificationFailed.message}");
          log(verificationFailed.message.toString());
        },
        codeSent: (verificationID, resendingToken) async {
          setState(() {
            verificationId = verificationID;
          });
          log("Code sent");
          log(verificationID.toString());
          log(resendingToken.toString());
        },
        codeAutoRetrievalTimeout: (verificationId) async {},
        timeout: const Duration(seconds: 90),
      );
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (e) {
      log(e.toString());
    }
  }
}
