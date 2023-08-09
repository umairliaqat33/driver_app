import 'dart:developer';

import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/models/users/user_model.dart';
import 'package:driver_app/repositories/user_repository/user_repository.dart';
import 'package:driver_app/controllers/business_controllers/business_firestore_controller.dart';
import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/services/media_service.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/views/screens/otp/otp_screen.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/image_picker_widgets/image_picker_big_widget.dart';
import 'package:driver_app/views/widgets/others/back_arrow_app_bar.dart';
import 'package:driver_app/views/widgets/alerts/custom_snackbar.dart';
import 'package:driver_app/views/widgets/others/terms_condition_widget.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';

// ignore_for_file: use_build_context_synchronously, must_be_immutable

class BusinessInfoScreen extends StatefulWidget {
  final BusinessModel? businessModel;
  List<bool> isDataCompleted;

  BusinessInfoScreen({
    Key? key,
    this.businessModel,
    required this.isDataCompleted,
  }) : super(key: key);

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _pointOfContactController =
      TextEditingController();
  final TextEditingController _businessLocationController =
      TextEditingController();
  final TextEditingController _businessEmailController =
      TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final BusinessFirestoreController _businessFirestoreController =
      BusinessFirestoreController();
  final UserRepository _userRepository = UserRepository();
  PlatformFile? _businessPlatformFile;
  String? _businessImgUrl;
  bool _registerSpinner = false;

  @override
  void initState() {
    super.initState();
    BusinessModel? businessModel = widget.businessModel;
    if (businessModel?.number != null) {
      _businessNameController.text = businessModel!.name!;
      _pointOfContactController.text = businessModel.pointOfContact!;
      _businessLocationController.text = businessModel.location!;
      _businessEmailController.text = businessModel.email;
      _contactNumberController.text = businessModel.number!;
      _businessImgUrl = businessModel.imageLink;
    } else {
      _setName();
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
          text: 'Business Info',
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
          right: (SizeConfig.width15(context) + 1),
          left: (SizeConfig.width15(context) + 1),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.height15(context) + 1),
                child: ImagePickerBigWidget(
                  heading: 'Profile Photo',
                  description:
                      'add a close-up image of yourself max size is 2 MB',
                  onPressed: () async => _selectBusinessImage(),
                  imgUrl: _businessImgUrl,
                  platformFile: _businessPlatformFile,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.height8(context)),
                    TextFieldWidget(
                      textInputType: TextInputType.name,
                      hintText: "Business Name",
                      textController: _businessNameController,
                      validator: (value) => Utils.businessNameValidator(value),
                    ),
                    SizedBox(height: SizeConfig.height8(context)),
                    TextFieldWidget(
                      textInputType: TextInputType.name,
                      hintText: "Point of Contact",
                      textController: _pointOfContactController,
                      validator: (value) =>
                          Utils.pointOfContactValidator(value),
                    ),
                    SizedBox(height: SizeConfig.height8(context)),
                    TextFieldWidget(
                      textInputType: TextInputType.streetAddress,
                      hintText: "Business Location",
                      textController: _businessLocationController,
                      validator: (value) =>
                          Utils.businessLocationValidator(value),
                    ),
                    SizedBox(height: SizeConfig.height8(context)),
                    TextFieldWidget(
                      textInputType: TextInputType.emailAddress,
                      hintText: "Business Email",
                      textController: _businessEmailController,
                      validator: (value) => Utils.emailValidator(value),
                    ),
                    SizedBox(height: SizeConfig.height8(context)),
                    TextFieldWidget(
                      textInputType: TextInputType.phone,
                      hintText: "Contact Number",
                      textController: _contactNumberController,
                      validator: (value) => Utils.phoneValidator(value),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        // bottom: SizeConfig.height5(context),
                        top: (SizeConfig.height8(context) * 2),
                      ),
                      child: _registerSpinner
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              color: primaryColor,
                              textColor: whiteColor,
                              text: "REGISTER BUSINESS",
                              onTap: () => _submitData(),
                            ),
                    ),
                    const TermsConditionsWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    setState(() {
      _registerSpinner = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        UserModel userModel = await _getUserModel();
        if (_businessPlatformFile == null && _businessImgUrl == null) {
          _showSnackBar(
            "Please add profile picture",
            context,
          );
          setState(() {
            _registerSpinner = false;
          });
          return;
        }

        log('Uploading big image');
        String? imageLink = await MediaService.uploadFile(
            _businessPlatformFile, UserType.business.name);

        await _businessFirestoreController.uploadBusinessData(
          BusinessModel(
            email: userModel.email,
            uid: userModel.uid,
            name: _businessNameController.text,
            number: _contactNumberController.text,
            location: _businessLocationController.text,
            pointOfContact: _pointOfContactController.text,
            imageLink: imageLink ?? _businessImgUrl,
            approvalStatus: BusinessApprovalStatus.pending.name,
          ),
        );
        await _userRepository.updateUserInformation(
          UserModel(
              email: userModel.email,
              userName: userModel.userName,
              role: userModel.role,
              uid: userModel.uid,
              reference: "businesses/${userModel.uid}"),
        );
        _showSnackBar(
          "Data uploaded to database!",
          context,
        );
        setState(() {
          widget.isDataCompleted[0] = true;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              phoneNumber: _contactNumberController.text,
              userType: UserType.business,
              dataCompleted: widget.isDataCompleted,
            ),
          ),
        );
      } else {
        log("data uploading failed");
      }
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      _registerSpinner = false;
    });
  }

  Future<UserModel> _getUserModel() async {
    UserModel? userModel = await _userRepository.getUserInformation();
    return userModel!;
  }

  Future<void> _setName() async {
    UserModel userModel = await _getUserModel();
    _pointOfContactController.text = userModel.userName;
    _businessEmailController.text = userModel.email;
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

  Future<void> _selectBusinessImage() async {
    try {
      _businessPlatformFile = await MediaService.selectFile();
      if (_businessPlatformFile != null) {
        log("Big Image Clicked");
        log(_businessPlatformFile!.name);
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
}
