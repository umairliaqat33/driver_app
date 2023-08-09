// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_nullable

import 'dart:developer';

import 'package:driver_app/utils/strings.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:driver_app/models/users/user_model.dart';
import 'package:driver_app/repositories/user_repository/user_auth_repository.dart';
import 'package:driver_app/utils/exceptions.dart';
import 'package:driver_app/repositories/firestore_repository.dart';
import 'package:driver_app/views/screens/driver/driver_registration_screen.dart';
import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/auth/components/auth_banner_widget.dart';
import 'package:driver_app/views/screens/auth/login/login_screen.dart';
import 'package:driver_app/views/widgets/others/alternate_auth_widget.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/buttons/img_buttons.dart';
import 'package:driver_app/views/widgets/others/circular_loader_widget.dart';
import 'package:driver_app/views/widgets/alerts/custom_snackbar.dart';
import 'package:driver_app/views/widgets/others/or_use_divider_widget.dart';
import 'package:driver_app/views/widgets/text_fields/password_text_field_widget.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/views/screens/business/business_registration_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final UserType? userType;
  const RegistrationScreen({
    Key? key,
    this.userType,
  }) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSignUpLoading = false;
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;
  bool _isAppleLoading = false;
  final FirestoreRepository _firestoreService = FirestoreRepository();
  final UserAuthRepository _userAuthRepository = UserAuthRepository();
  late UserType _userType;

  @override
  void initState() {
    super.initState();
    _userType = widget.userType ?? UserType.driver;
    log("${_userType.name} going to be registered");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AuthBannerWidget(
                    title: AppStrings.signUpString,
                    description:
                        'Welcome! to get started end the following details below',
                  ),
                  TextFieldWidget(
                    textInputType: TextInputType.name,
                    textController: _userNameController,
                    hintText: "John Doe",
                    validator: (value) => Utils.userNameValidator(value),
                  ),
                  TextFieldWidget(
                    textInputType: TextInputType.emailAddress,
                    textController: _emailController,
                    hintText: "johndoe@gmail.com",
                    validator: (value) => Utils.emailValidator(value),
                  ),
                  PasswordTextFieldWidget(
                    textController: _passController,
                    hintText: "Enter password",
                    fieldTitle: "Password",
                    validator: (value) => Utils.passwordValidator(value),
                  ),
                  SizedBox(
                    height: (SizeConfig.height8(context) * 3) + 1,
                  ),
                  _isSignUpLoading
                      ? const CircularLoaderWidget()
                      : CustomButton(
                          text: "CREATE",
                          textColor: whiteColor,
                          color: primaryColor,
                          onTap: () async => signUp(
                            _emailController.text,
                            _passController.text,
                            _userNameController.text,
                          ),
                        ),
                  const OrUseDividerWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _isGoogleLoading
                          ? const CircularLoaderWidget()
                          : ImgButton(
                              height: SizeConfig.height10(context),
                              img: Assets.googleLogo,
                              onPressed: () async => _signInWithGoogle(),
                            ),
                      _isFacebookLoading
                          ? const CircularLoaderWidget()
                          : ImgButton(
                              height: SizeConfig.height10(context),
                              img: Assets.facebookLogo,
                              onPressed: () async => _signInWithFacebook(),
                            ),
                      _isAppleLoading
                          ? const CircularLoaderWidget()
                          : ImgButton(
                              height: SizeConfig.height10(context),
                              img: Assets.appleLogo,
                              onPressed: () {},
                            ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: (SizeConfig.height15(context) * 2) + 4,
                      bottom: (SizeConfig.height8(context) * 3),
                    ),
                    child: const AlternateAuthWidget(
                      screenName: LoginScreen(),
                      text: "I already have an account ",
                      widgetName: "Sign-in",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void clear() {
    _emailController.clear();
    _passController.clear();
  }

  Future<void> signUp(String email, String password, String userName) async {
    setState(() {
      _isSignUpLoading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        FocusManager.instance.primaryFocus?.unfocus();
        UserCredential? userCredential;

        userCredential = await _userAuthRepository.signUp(
          email,
          password,
        );
        if (userCredential == null) {
          _showSnackBar(
            "${AppStrings.signUpString} failed",
            context,
          );
          setState(() {
            _isSignUpLoading = false;
          });
          return;
        }
        _uploadData(
          UserModel(
            email: email,
            userName: userName,
            role: _userType.name,
            uid: userCredential.user!.uid,
          ),
          userCredential,
        );

        _showSnackBar(
          "${AppStrings.signUpString} was successful",
          context,
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => _userType == UserType.driver
                ? const DriverRegistrationScreen()
                : const BusinessRegistrationScreen(),
          ),
          (route) => false,
        );
      }
    } on EmailAlreadyExistException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    } on NoInternetException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    } on FormatParsingException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    } on UnknownException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    }
    setState(() {
      _isSignUpLoading = false;
    });
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
    });
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      UserCredential? userCredential;
      userCredential = await _userAuthRepository
          .googleSignIn()
          .onError((error, stackTrace) {});
      if (userCredential == null) {
        _showSnackBar(
            "Google ${AppStrings.signUpString.toLowerCase()} failed unknown reason",
            context);
        log("Google Sign in failed");
        setState(() {
          _isGoogleLoading = false;
        });
        return;
      }
      if (!await _firestoreService.isUserDocumentEmpty(
        userCredential.user!.uid,
      )) {
        _uploadData(
          UserModel(
            email: userCredential.user!.email ??
                userCredential.user!.providerData.first.email!,
            userName: userCredential.user!.displayName ??
                userCredential.user!.providerData.first.displayName!,
            role: _userType.name,
            uid: userCredential.user!.uid,
          ),
          userCredential,
        );
      }
      _showSnackBar(
          "Google ${AppStrings.signUpString.toLowerCase()} was successful",
          context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => _userType == UserType.driver
                ? const DriverRegistrationScreen()
                : const BusinessRegistrationScreen(),
          ),
          (route) => false);
    } on NoInternetException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    } on FormatParsingException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    } on UnknownException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    }
    setState(() {
      _isGoogleLoading = false;
    });
  }

  Future<void> _signInWithFacebook() async {
    setState(() {
      _isFacebookLoading = true;
    });
    try {
      UserCredential? userCredential;
      userCredential = await _userAuthRepository
          .facebookLogin()
          .onError((error, stackTrace) {});
      if (userCredential == null) {
        _showSnackBar(
            "Facebook ${AppStrings.signUpString.toLowerCase()} failed unknown reason",
            context);
        log("Facebook Sign in failed");
        setState(() {
          _isFacebookLoading = false;
        });
        return;
      }
      if (!await _firestoreService.isUserDocumentEmpty(
        userCredential.user!.uid,
      )) {
        _uploadData(
          UserModel(
            email: userCredential.user!.email ??
                userCredential.user!.providerData.first.email!,
            userName: userCredential.user!.displayName ??
                userCredential.user!.providerData.first.displayName!,
            role: _userType.name,
            uid: userCredential.user!.uid,
          ),
          userCredential,
        );
      }
      _showSnackBar(
          "Facebook ${AppStrings.signUpString.toLowerCase()} was successful",
          context);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => _userType == UserType.driver
              ? const DriverRegistrationScreen()
              : const BusinessRegistrationScreen(),
        ),
        (route) => false,
      );
    } on NoInternetException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    } on FormatParsingException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    } on UnknownException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    }
    setState(() {
      _isFacebookLoading = false;
    });
  }

  Future<void> _uploadData(
    UserModel userModel,
    UserCredential? userCredential,
  ) async {
    try {
      if (userCredential == null) return;
      _firestoreService.uploadUserData(userModel);
    } on NoInternetException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    } on FormatParsingException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    } on UnknownException catch (e) {
      _showSnackBar(
        e.message,
        context,
      );
    }
  }

  void _showSnackBar(
    String subTitle,
    BuildContext context,
  ) {
    setState(() {
      _isAppleLoading = false;
      _isGoogleLoading = false;
      _isFacebookLoading = false;
      _isSignUpLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar(
        subTitle: subTitle,
      ),
    );
  }
}
