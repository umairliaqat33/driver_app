// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

import 'package:driver_app/utils/utils.dart';
import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/widgets/others/back_arrow_app_bar.dart';
import 'package:driver_app/models/users/user_model.dart';
import 'package:driver_app/repositories/user_repository/user_repository.dart';
import 'package:driver_app/services/media_service.dart';
import 'package:driver_app/utils/collection_names.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/image_picker_widgets/image_picker_big_widget.dart';
import 'package:driver_app/views/widgets/others/circular_loader_widget.dart';
import 'package:driver_app/views/widgets/alerts/custom_snackbar.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_label_widget.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';
import 'package:driver_app/views/screens/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:driver_app/controllers/business_controllers/business_firestore_controller.dart';
import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/utils/global.dart';
import 'package:driver_app/utils/strings.dart';

class EditBusinessScreen extends StatefulWidget {
  final userData;
  const EditBusinessScreen({
    super.key,
    required this.userData,
  });

  @override
  State<EditBusinessScreen> createState() => _EditBusinessScreenState();
}

class _EditBusinessScreenState extends State<EditBusinessScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pointOfContactController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  PlatformFile? _profilePlatformFile;
  final _formKey = GlobalKey<FormState>();
  String? _imageLink;
  bool _btnSpinner = false;
  BusinessModel? _businessModel;
  String _email = "";

  @override
  void initState() {
    super.initState();
    _setDataInFields();
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
          text: 'Edit Business',
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ImagePickerBigWidget(
                        heading: 'Profile Photo',
                        description:
                            'add a close-up image of yourself max size is 2 MB',
                        onPressed: () async => _selectProfileImage(),
                        platformFile: _profilePlatformFile,
                        imgUrl: _imageLink,
                      ),
                      SizedBox(
                        height: SizeConfig.height12(context),
                      ),
                      const TextFieldLabelWidget(
                        label: "Business Name",
                      ),
                      TextFieldWidget(
                        hintText: "Business name",
                        textController: _nameController,
                        validator: (value) =>
                            Utils.businessNameValidator(value),
                      ),
                      SizedBox(
                        height: SizeConfig.height12(context),
                      ),
                      const TextFieldLabelWidget(
                        label: "Point of contact",
                      ),
                      TextFieldWidget(
                        hintText: "Point of contact",
                        textController: _pointOfContactController,
                        validator: (value) =>
                            Utils.pointOfContactValidator(value),
                      ),
                      SizedBox(
                        height: SizeConfig.height12(context),
                      ),
                      const TextFieldLabelWidget(
                        label: "Business Address",
                      ),
                      TextFieldWidget(
                        hintText: "Business Address",
                        textController: _addressController,
                        validator: (value) =>
                            Utils.businessLocationValidator(value),
                      ),
                      SizedBox(
                        height: SizeConfig.height12(context),
                      ),
                      const TextFieldLabelWidget(
                        label: "Business Number",
                      ),
                      TextFieldWidget(
                        enabled: false,
                        hintText: "+441234567891",
                        textController: _phoneController,
                        validator: (value) => Utils.phoneValidator(value),
                      ),
                    ],
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
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _btnSpinner = true;
        });
        FocusManager.instance.primaryFocus?.unfocus();
        String? profilePicture =
            await MediaService.uploadFile(_profilePlatformFile, getUserType()!);
        await _updateBusinessData(role, profilePicture);
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

  void _setDataInFields() {
    if (widget.userData is UserModel) {
      _nameController.text = widget.userData.userName;
      _email = widget.userData.email;
    } else {
      _businessModel = widget.userData.data;
      _email = widget.userData.data.email;
      _imageLink = widget.userData.data.imageLink;
      _pointOfContactController.text = widget.userData.data.pointOfContact;
      _nameController.text = widget.userData.data.name!;
      _phoneController.text = widget.userData.data.number;
      _addressController.text = widget.userData.data.location;
    }
    setState(() {});
  }

  Future<void> _updateBusinessData(String role, String? profilePicture) async {
    UserRepository userRepository = UserRepository();
    UserModel? userModel = await userRepository.getUserInformation();
    String collectionName = "";

    collectionName = CollectionsNames.businessCollection;
    final BusinessFirestoreController businessFirestoreController =
        BusinessFirestoreController();
    try {
      if (userModel!.reference != null) {
        await businessFirestoreController.updateBusinessData(
          BusinessModel(
            email: _email,
            number: _phoneController.text,
            imageLink: profilePicture ?? _businessModel!.imageLink,
            name: _nameController.text,
            uid: _businessModel!.uid,
            location: _businessModel!.location,
            pointOfContact: _pointOfContactController.text,
          ),
        );
      } else {
        await businessFirestoreController.uploadBusinessData(
          BusinessModel(
            email: _email,
            number: _phoneController.text,
            imageLink: profilePicture,
            name: _nameController.text,
            pointOfContact: _pointOfContactController.text,
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
    } catch (e) {
      log(e.toString());
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
