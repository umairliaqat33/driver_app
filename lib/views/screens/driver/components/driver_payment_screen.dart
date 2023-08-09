import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_switch/flutter_switch.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/driver/driver_registration_screen.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/others/back_arrow_app_bar.dart';
import 'package:driver_app/views/widgets/others/terms_condition_widget.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';

class DriverPaymentScreen extends StatefulWidget {
  final List<bool> isDataComplete;

  const DriverPaymentScreen({
    Key? key,
    required this.isDataComplete,
  }) : super(key: key);

  @override
  State<DriverPaymentScreen> createState() => _DriverPaymentScreenState();
}

class _DriverPaymentScreenState extends State<DriverPaymentScreen> {
  bool _isBankSwitched = false;
  bool _isCashSwitched = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumbController = TextEditingController();
  final TextEditingController _sortCodeController = TextEditingController();
  final TextEditingController _accountHolderController =
      TextEditingController();
  List<bool>? _isDataComplete = [];

  @override
  void initState() {
    super.initState();
    _isDataComplete = widget.isDataComplete;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          (SizeConfig.height12(context) * 4),
        ),
        child: BackArrowAppbar(
          fontSize: 18,
          textColor: appTextColor,
          text: 'Payment Screen',
          picture: Assets.arrowBack,
          onPressed: () {
            Navigator.of(context).pop();
          },
          appBarColor: backgroundColor,
          elevation: 1,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: (SizeConfig.width8(context) * 2),
          right: (SizeConfig.width8(context) * 2),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: (SizeConfig.height20(context) + 10),
                ),
                child: const Text(
                  "How do you want to",
                  style: TextStyle(
                    color: appTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.height8(context),
              ),
              const Text(
                "Get Paid?",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.height20(context) + 5,
                  bottom: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "BANK ACCOUNT",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appTextColor,
                      ),
                    ),
                    FlutterSwitch(
                      width: (SizeConfig.width8(context) * 4),
                      height: SizeConfig.height18(context),
                      toggleSize: SizeConfig.height10(context),
                      activeColor: primaryColor,
                      inactiveColor: blackColor,
                      value: _isBankSwitched,
                      onToggle: (bool value) => _switchValue(),
                    ),
                  ],
                ),
              ),
              const Text(
                "To get paid through bank attach your bank by adding following details below",
                style: TextStyle(
                  color: greyColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldWidget(
                      enabled: _isBankSwitched,
                      hintText: "Bank Name",
                      textController: _bankNameController,
                      validator: (value) {
                        if (_bankNameController.text.isEmpty) {
                          return "Bank name required";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.height8(context),
                    ),
                    TextFieldWidget(
                      enabled: _isBankSwitched,
                      hintText: "Account Holder Name",
                      textController: _accountHolderController,
                      validator: (value) {
                        if (_accountHolderController.text.isEmpty) {
                          return "Account holder name required";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.height8(context),
                    ),
                    TextFieldWidget(
                      enabled: _isBankSwitched,
                      hintText: "Account Number (14-digit)",
                      textInputType: TextInputType.number,
                      textController: _accountNumbController,
                      validator: (value) {
                        if (_accountHolderController.text.isEmpty) {
                          return "Account holder name required";
                        } else if (_accountNumbController.text.length > 14 ||
                            _accountNumbController.text.length < 14) {
                          return "Some digits are missing or extra in account number";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.height8(context),
                    ),
                    TextFieldWidget(
                      enabled: _isBankSwitched,
                      hintText: "Sort Code (6-digit)",
                      textInputType: TextInputType.number,
                      textController: _sortCodeController,
                      validator: (value) {
                        if (_sortCodeController.text.isEmpty) {
                          return "Sort code required";
                        } else if (_sortCodeController.text.length > 6 ||
                            _sortCodeController.text.length < 6) {
                          return "Some digits are missing or extra in sort code";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.height8(context),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.height20(context) + 5,
                  bottom: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "SPOT CASH",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appTextColor,
                      ),
                    ),
                    FlutterSwitch(
                      width: (SizeConfig.width8(context) * 4),
                      height: SizeConfig.height18(context),
                      toggleSize: SizeConfig.height10(context),
                      activeColor: primaryColor,
                      inactiveColor: blackColor,
                      value: _isCashSwitched,
                      onToggle: (bool value) => _switchValue(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: (SizeConfig.height5(context) * 2),
                ),
                child: CustomButton(
                  color: primaryColor,
                  textColor: whiteColor,
                  text: "DONE",
                  onTap: () {
                    if (_formKey.currentState!.validate() && _isBankSwitched) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      log('done tapped');
                      setState(() {
                        _isDataComplete![1] = true;
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => DriverRegistrationScreen(
                            isDataComplete: _isDataComplete,
                          ),
                        ),
                      );
                    } else {
                      FocusManager.instance.primaryFocus?.unfocus();
                      log('done tapped');
                      setState(() {
                        _isDataComplete![1] = true;
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => DriverRegistrationScreen(
                            isDataComplete: _isDataComplete,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const TermsConditionsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void _switchValue() {
    if (_isBankSwitched) {
      _isBankSwitched = false;
      _isCashSwitched = true;
    } else {
      _isBankSwitched = true;
      _isCashSwitched = false;
    }
    setState(() {});
  }
}
