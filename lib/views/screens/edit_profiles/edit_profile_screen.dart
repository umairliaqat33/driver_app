// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/widgets/others/back_arrow_app_bar.dart';
import 'package:driver_app/controllers/driver_controller/driver_firestore_controller.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/models/users/user_model.dart';
import 'package:driver_app/repositories/user_repository/user_repository.dart';
import 'package:driver_app/services/media_service.dart';
import 'package:driver_app/utils/collection_names.dart';
import 'package:driver_app/utils/constants.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/image_picker_widgets/image_picker_big_widget.dart';
import 'package:driver_app/views/widgets/others/circular_loader_widget.dart';
import 'package:driver_app/views/widgets/alerts/custom_snackbar.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_label_widget.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/views/screens/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:driver_app/controllers/business_controllers/business_firestore_controller.dart';
import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/utils/global.dart';
import 'package:driver_app/utils/strings.dart';

class EditProfileScreen extends StatefulWidget {
  final userData;
  const EditProfileScreen({
    super.key,
    required this.userData,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  PlatformFile? _profilePlatformFile;
  final _formKey = GlobalKey<FormState>();
  String? _imageLink;
  bool _btnSpinner = false;
  // ignore: unused_field
  UserModel? _userModel;
  DriverModel? _driverModel;
  BusinessModel? _businessModel;

  @override
  void initState() {
    super.initState();
    setDataInFields();
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
          text: 'Edit Profile',
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
          top: SizeConfig.height12(context),
          left: (SizeConfig.width8(context) * 2),
          right: (SizeConfig.width8(context) * 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Visibility(
                        visible: getUserType() == AppStrings.roleDriver
                            ? true
                            : false,
                        child: ImagePickerBigWidget(
                          heading: 'Profile Photo',
                          description:
                              'add a close-up image of yourself max size is 2 MB',
                          onPressed: () async => _selectProfileImage(),
                          platformFile: _profilePlatformFile,
                          imgUrl: _imageLink,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height12(context),
                      ),
                      const TextFieldLabelWidget(
                        label: "Full Name",
                      ),
                      TextFieldWidget(
                        hintText: "Full name",
                        textController: _nameController,
                        validator: (value) {
                          if (_nameController.text.isEmpty) {
                            return "Full name required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.height12(context),
                      ),
                      const TextFieldLabelWidget(
                        label: "Email",
                      ),
                      TextFieldWidget(
                        enabled: false,
                        hintText: "Email",
                        textController: _emailController,
                        validator: (value) {
                          if (_nameController.text.isEmpty) {
                            return "Email required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.height12(context),
                      ),
                      Visibility(
                        visible: _phoneController.text.isEmpty ? false : true,
                        child: const TextFieldLabelWidget(
                          label: "Contact Number",
                        ),
                      ),
                      Visibility(
                        visible: _phoneController.text.isEmpty ? false : true,
                        child: TextFieldWidget(
                          enabled: false,
                          hintText: "+441234567891",
                          textController: _phoneController,
                          validator: (value) {
                            if (_nameController.text.isEmpty) {
                              return "Phone number required";
                            }
                            if (RegExp(phonePattern)
                                .hasMatch(_phoneController.text)) {
                              return "Please enter a correct phone number";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _btnSpinner
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularLoaderWidget(),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                        // top: (SizeConfig.height20(context) * 16),
                        left: (SizeConfig.width8(context) * 2),
                        right: (SizeConfig.width8(context) * 2),
                        bottom: (SizeConfig.width8(context) * 2)),
                    child: CustomButton(
                      color: primaryColor,
                      textColor: whiteColor,
                      text: "SAVE",
                      onTap: () async => _updateData(getUserType()!),
                    ),
                  ),
          ],
        ),
      ),
    );
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
        e.toString(),
        context,
      );
    }
  }

  Future<void> _updateData(String role) async {
    setState(() {
      _btnSpinner = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        FocusManager.instance.primaryFocus?.unfocus();
        String? profilePicture =
            await MediaService.uploadFile(_profilePlatformFile, getUserType()!);
        await _updateBusinessDriverData(role, profilePicture);
        _showSnackBar("Data have been updated in database", context);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavigationBarScreen(
              index: 3,
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      log(e.toString());
      log("something went wrong while updating driver data");
    }
    setState(() {
      _btnSpinner = false;
    });
  }

  void setDataInFields() {
    if (widget.userData is UserModel) {
      _userModel = widget.userData;
      _emailController.text = widget.userData.email;
      _nameController.text = widget.userData.userName;
    } else if (widget.userData.data is BusinessModel) {
      _businessModel = widget.userData.data;
      _imageLink = widget.userData.data.imageLink;
      _emailController.text = widget.userData.data.email;
      _nameController.text = widget.userData.data.name!;
    } else {
      _driverModel = widget.userData.data;
      _phoneController.text = widget.userData.data.number;
      _imageLink = widget.userData.data.profileImageLink;
      _emailController.text = widget.userData.data.email;
      _nameController.text = widget.userData.data.name!;
    }
    setState(() {});
  }

  Future<void> _updateBusinessDriverData(
      String role, String? profilePicture) async {
    UserRepository userRepository = UserRepository();
    UserModel? userModel = await userRepository.getUserInformation();
    String collectionName = "";
    if (role == AppStrings.roleDriver) {
      collectionName = CollectionsNames.driverCollection;
      final DriverFirestoreController driverFirestoreController =
          DriverFirestoreController();
      if (userModel!.reference != null) {
        await driverFirestoreController.updateDriverData(
          DriverModel(
            email: _emailController.text,
            number: _phoneController.text,
            profileImageLink: profilePicture ?? _driverModel!.profileImageLink,
            name: _nameController.text,
            uid: _driverModel!.uid,
            address: _driverModel!.address,
            approvalStatus: _driverModel!.approvalStatus,
            licenseBackLink: _driverModel!.licenseBackLink,
            licenseFrontLink: _driverModel!.licenseFrontLink,
            licenseExpiry: _driverModel!.licenseExpiry,
            drivingLicense: _driverModel!.drivingLicense,
            dateOfBirth: _driverModel!.dateOfBirth,
            vehicleNo: _driverModel!.vehicleNo,
            vehicleType: _driverModel!.vehicleType,
            hasVehicle: _driverModel!.hasVehicle,
          ),
        );
      } else {
        await driverFirestoreController.uploadData(
          DriverModel(
            email: _emailController.text,
            number: _phoneController.text,
            profileImageLink: profilePicture,
            name: _nameController.text,
            uid: widget.userData!.uid,
            approvalStatus: DriverApprovalStatus.pending.name,
          ),
        );
      }
      userRepository.updateUserInformation(
        UserModel(
          email: _driverModel!.email,
          userName: _driverModel!.name!,
          role: AppStrings.roleDriver,
          uid: _driverModel?.uid,
          reference: "$collectionName/${_driverModel?.uid}",
        ),
      );
    } else {
      collectionName = CollectionsNames.businessCollection;
      final BusinessFirestoreController businessFirestoreController =
          BusinessFirestoreController();
      if (userModel!.reference != null) {
        await businessFirestoreController.updateBusinessData(
          BusinessModel(
            email: _emailController.text,
            number: _phoneController.text,
            imageLink: profilePicture ?? _businessModel!.imageLink,
            name: _nameController.text,
            uid: _businessModel!.uid,
            location: _businessModel!.location,
            pointOfContact: _businessModel!.pointOfContact,
          ),
        );
      } else {
        await businessFirestoreController.uploadBusinessData(
          BusinessModel(
            email: _emailController.text,
            number: _phoneController.text,
            imageLink: profilePicture,
            name: _nameController.text,
            uid: widget.userData!.uid,
          ),
        );
      }
      userRepository.updateUserInformation(
        UserModel(
          email: _businessModel!.email,
          userName: _businessModel!.name!,
          role: AppStrings.roleBusiness,
          uid: _businessModel?.uid,
          reference: "$collectionName/${_businessModel?.uid}",
        ),
      );
    }
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
}
