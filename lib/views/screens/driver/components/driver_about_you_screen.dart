// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'dart:developer';

import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';

import 'package:driver_app/models/users/user_model.dart';
import 'package:driver_app/repositories/firestore_repository.dart';
import 'package:driver_app/repositories/user_repository/user_repository.dart';
import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/others/back_arrow_app_bar.dart';
import 'package:driver_app/views/widgets/image_picker_widgets/image_picker_big_widget.dart';
import 'package:driver_app/views/widgets/others/terms_condition_widget.dart';
import 'package:driver_app/views/widgets/text_fields/date_picker_field_widget.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';
import 'package:driver_app/controllers/driver_controller/driver_firestore_controller.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/services/media_service.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/views/screens/otp/otp_screen.dart';
import 'package:driver_app/views/widgets/image_picker_widgets/image_picker_small_widget.dart';
import 'package:driver_app/views/widgets/alerts/custom_snackbar.dart';
import 'package:driver_app/extension/extensions.dart';
import 'package:driver_app/utils/strings.dart';

enum Choice { yes, no }

class DriverAboutYouScreen extends StatefulWidget {
  final DriverModel? driverModel;
  List<bool> dataCompleted;

  DriverAboutYouScreen({
    Key? key,
    this.driverModel,
    required this.dataCompleted,
  }) : super(key: key);

  @override
  State<DriverAboutYouScreen> createState() => _DriverAboutYouScreenState();
}

class _DriverAboutYouScreenState extends State<DriverAboutYouScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _plateNoController = TextEditingController();
  final TextEditingController _licenseExpiryDateController =
      TextEditingController();
  final DriverFirestoreController _driverFirestoreController =
      DriverFirestoreController();
  final UserRepository _userRepository = UserRepository();
  List<String> vehicles = ["Bike", "Car"];
  String selectedVehicle = "Bike";
  Choice? _choice = Choice.yes;

  final _formKey = GlobalKey<FormState>();
  PlatformFile? _profilePlatformFile;
  PlatformFile? _licenseFrontPlatformFile;
  PlatformFile? _licenseBackPlatformFile;
  String? _profileUrl;
  String? _licenseFrontUrl;
  String? _licenseBackUrl;
  bool _doneSpinner = false;
  @override
  void initState() {
    super.initState();
    DriverModel? driverModel = widget.driverModel;
    if (driverModel != null && driverModel.number != null) {
      _fullNameController.text = driverModel.name!;
      _phoneController.text = driverModel.number!;
      _addressController.text = driverModel.address!;
      _licenseController.text = driverModel.drivingLicense!;
      _dateOfBirthController.text = driverModel.dateOfBirth!;
      _plateNoController.text = driverModel.vehicleNo!;
      _licenseExpiryDateController.text = driverModel.licenseExpiry!;
      _profileUrl = driverModel.profileImageLink!;
      _licenseFrontUrl = driverModel.licenseFrontLink!;
      _licenseBackUrl = driverModel.licenseBackLink!;
    } else {
      _setUserName();
    }
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
          text: 'About You',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImagePickerBigWidget(
                heading: 'Profile Photo',
                description:
                    'add a close-up image of yourself max size is 2 MB',
                onPressed: () async => _selectProfileImage(),
                imgUrl: _profileUrl,
                platformFile: _profilePlatformFile,
              ),
              SizedBox(height: SizeConfig.height8(context)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldWidget(
                      hintText: "User Name",
                      textController: _fullNameController,
                      validator: (value) => Utils.userNameValidator(value),
                    ),
                    SizedBox(height: SizeConfig.height8(context)),
                    TextFieldWidget(
                      textInputType: TextInputType.phone,
                      hintText: "Phone Number(+447807123456)",
                      textController: _phoneController,
                      validator: (value) => Utils.phoneValidator(value),
                    ),
                    SizedBox(height: SizeConfig.height8(context)),
                    TextFieldWidget(
                      hintText: "Address",
                      textController: _addressController,
                      validator: (value) => Utils.addressValidator(value),
                    ),
                    SizedBox(height: SizeConfig.height8(context)),
                    DatePickerFieldWidget(
                      hintText: "Date of Birth",
                      textController: _dateOfBirthController,
                      validator: (value) => Utils.dateOfBirthValidator(value),
                    ),
                    SizedBox(
                      height: 34,
                      width: SizeConfig.width(context),
                      child: const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Vehicle Info",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: greyColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                      width: SizeConfig.width(context),
                      child: const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Vehicle Type",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: blackColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        _rideImageBox(0),
                        const SizedBox(width: 20),
                        _rideImageBox(1),
                      ],
                    ),
                    SizedBox(
                      height: 32,
                      width: SizeConfig.width(context),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          AppStrings.usingYourOwnVehicle,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: blackColor),
                        ),
                      ),
                    ),
                    _vehicleChoiceBlock(),
                    TextFieldWidget(
                      textInputType: TextInputType.text,
                      hintText: "Vehicle Plate No.",
                      textController: _plateNoController,
                      validator: (value) =>
                          Utils.vehiclePlateNumberValidator(value),
                    ),
                    SizedBox(height: SizeConfig.height8(context)),
                    TextFieldWidget(
                      textInputType: TextInputType.text,
                      hintText: "Driving License Number",
                      textController: _licenseController,
                      validator: (value) => Utils.licenseNumberValidator(value),
                    ),
                    SizedBox(height: SizeConfig.height8(context)),
                    DatePickerFieldWidget(
                      hintText: "License expiry date",
                      textController: _licenseExpiryDateController,
                      validator: (value) => Utils.licenseExpiryValidator(value),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.height8(context) * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ImagePickerSmallWidget(
                    platformFile: _licenseFrontPlatformFile,
                    sideText: 'front side',
                    imgUrl: _licenseFrontUrl,
                    selectImage: _selectFrontImage,
                  ),
                  ImagePickerSmallWidget(
                    sideText: 'back side',
                    imgUrl: _licenseBackUrl,
                    platformFile: _licenseBackPlatformFile,
                    selectImage: _selectBackImage,
                  ),
                ],
              ),
              _doneSpinner
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    )
                  : CustomButton(
                      color: primaryColor,
                      textColor: whiteColor,
                      text: "DONE",
                      onTap: () async => _submitInfo(),
                    ),
              Padding(
                padding: EdgeInsets.only(
                  right: SizeConfig.width8(context),
                  left: SizeConfig.width8(context),
                ),
                child: const TermsConditionsWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitInfo() async {
    setState(() {
      _doneSpinner = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        if (_profilePlatformFile == null && _profileUrl == null) {
          _showSnackBar(
            "Please add profile picture",
            context,
          );
          setState(() {
            _doneSpinner = false;
          });
          return;
        }
        if (_licenseFrontPlatformFile == null && _licenseFrontUrl == null) {
          _showSnackBar(
            "Please add driving license front picture",
            context,
          );
          setState(() {
            _doneSpinner = false;
          });
          return;
        }
        if (_licenseBackPlatformFile == null && _licenseBackUrl == null) {
          _showSnackBar(
            "Please add driving license back picture",
            context,
          );
          setState(() {
            _doneSpinner = false;
          });
          return;
        }
        User? user = FirestoreRepository.checkUser();

        log('Uploading big image');
        String? profilePicture = await MediaService.uploadFile(
            _profilePlatformFile, UserType.driver.name);
        log('Uploading small image2');
        String? licenseFront = await MediaService.uploadFile(
            _licenseFrontPlatformFile, UserType.driver.name);
        UserModel userModel = await _getUserName();
        String? licenseBack = await MediaService.uploadFile(
            _licenseBackPlatformFile, UserType.driver.name);
        _driverFirestoreController.uploadData(
          DriverModel(
            email: userModel.email,
            uid: user!.uid,
            name: _fullNameController.text,
            number: _phoneController.text,
            address: _addressController.text,
            dateOfBirth: _dateOfBirthController.text,
            drivingLicense: _licenseController.text,
            licenseExpiry: _licenseExpiryDateController.text,
            licenseBackLink: licenseBack ?? _licenseBackUrl,
            licenseFrontLink: licenseFront ?? _licenseFrontUrl,
            profileImageLink: profilePicture ?? _profileUrl,
            vehicleNo: _plateNoController.text,
            vehicleType: selectedVehicle.toLowerCase(),
            hasVehicle: _choice == Choice.yes ? true : false,
            approvalStatus: DriverApprovalStatus.pending.name,
          ),
        );
        await _userRepository.updateUserInformation(
          UserModel(
              email: userModel.email,
              userName: userModel.userName,
              role: userModel.role,
              uid: userModel.uid,
              reference: "drivers/${userModel.uid}"),
        );
        log('done tapped');
        _showSnackBar(
          "Data uploaded to database!",
          context,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              phoneNumber: _phoneController.text,
              userType: UserType.driver,
              dataCompleted: widget.dataCompleted,
            ),
          ),
        );
        setState(() {
          _doneSpinner = false;
        });
      }
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      _doneSpinner = false;
    });
  }

  Future<UserModel> _getUserName() async {
    UserModel? userModel = await _userRepository.getUserInformation();
    return userModel!;
  }

  Future<void> _setUserName() async {
    UserModel userModel = await _getUserName();
    _fullNameController.text = userModel.userName;
  }

  void _showSnackBar(
    String subTitle,
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar(
        subTitle: subTitle,
      ),
    );
  }

  Future<void> _selectFrontImage() async {
    try {
      _licenseFrontPlatformFile = await MediaService.selectFile();
      if (_licenseFrontPlatformFile != null) {
        log("Big Image Clicked");
        log(_licenseFrontPlatformFile!.name);
      } else {
        log("no file selected");
        return;
      }
      setState(() {});
    } catch (e) {
      _showSnackBar(
        "Please pick an image",
        context,
      );
    }
  }

  Future<void> _selectProfileImage() async {
    try {
      _profilePlatformFile = await MediaService.selectFile();
      if (_profilePlatformFile != null) {
        log("Big Image Clicked");
        log(_profilePlatformFile!.name);
      } else {
        log("no file selected");
        return;
      }
      setState(() {});
    } catch (e) {
      _showSnackBar(
        "Please pick an image",
        context,
      );
    }
  }

  Future<void> _selectBackImage() async {
    try {
      _licenseBackPlatformFile = await MediaService.selectFile();
      if (_licenseBackPlatformFile != null) {
        log("Big Image Clicked");
        log(_licenseBackPlatformFile!.name);
      } else {
        log("no file selected");
        return;
      }
      setState(() {});
    } catch (e) {
      _showSnackBar(
        "Please pick an image",
        context,
      );
    }
  }

  GestureDetector _rideImageBox(int position) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedVehicle = vehicles.elementAt(position);
        });
      },
      child: Container(
        height: 32,
        width: 87,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: selectedVehicle == vehicles.elementAt(position)
                ? primaryColor
                : whiteColor,
            border: Border.all(
              color: primaryColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(3))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
                vehicles.elementAt(position) == "Bike"
                    ? Assets.iconBike
                    : Assets.iconCar,
                color: selectedVehicle == vehicles.elementAt(position)
                    ? whiteColor
                    : primaryColor),
            Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(vehicles.elementAt(position),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: selectedVehicle == vehicles.elementAt(position)
                            ? whiteColor
                            : primaryColor)))
          ],
        ),
      ),
    );
  }

  Center _vehicleChoiceBlock() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _radioTile(Choice.yes),
          _radioTile(Choice.no),
        ],
      ),
    );
  }

  Expanded _radioTile(Choice choice) {
    return Expanded(
        child: ListTile(
      title: Text(
        choice.name.capitalize(),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: blackColor,
        ),
      ),
      leading: Radio<Choice>(
          value: choice,
          groupValue: _choice,
          onChanged: (Choice? value) {
            setState(() {
              _choice = value;
            });
          }),
    ));
  }
}
