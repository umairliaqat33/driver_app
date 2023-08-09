// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, body_might_complete_normally_nullable

import 'package:driver_app/views/widgets/others/or_use_divider_widget.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:driver_app/utils/exceptions.dart';
import 'package:driver_app/views/screens/auth/components/user_type_selection_screen.dart';
import 'package:driver_app/views/screens/auth/components/auth_banner_widget.dart';
import 'package:driver_app/views/widgets/alerts/custom_snackbar.dart';
import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/controllers/auth_controller.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:driver_app/views/widgets/others/alternate_auth_widget.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/buttons/img_buttons.dart';
import 'package:driver_app/views/widgets/others/circular_loader_widget.dart';
import 'package:driver_app/views/widgets/text_fields/password_text_field_widget.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';
import 'package:driver_app/repositories/firestore_repository.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:driver_app/views/screens/auth/forgot_password/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSignInLoading = false;
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;
  bool _isAppleLoading = false;
  final AuthController _authController = AuthController();
  final FirestoreRepository firestoreService = FirestoreRepository();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthBannerWidget(
                      title: 'Login',
                      description: 'Please enter the details below to continue',
                    ),
                    TextFieldWidget(
                      textInputType: TextInputType.emailAddress,
                      textController: _emailController,
                      hintText: "johndoe@gmail.com",
                      validator: (value) => Utils.emailValidator(value),
                    ),
                    const SizedBox(height: 4.0),
                    PasswordTextFieldWidget(
                      textController: _passController,
                      hintText: "Enter your password",
                      fieldTitle: "Password",
                      validator: (value) => Utils.passwordValidator(value),
                    ),
                    const _ForgotPasswordWidget(),
                    _isSignInLoading
                        ? const CircularLoaderWidget()
                        : CustomButton(
                            text: "LOGIN",
                            textColor: whiteColor,
                            color: primaryColor,
                            onTap: () async => signIn(
                              _emailController.text,
                              _passController.text,
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
                        screenName: UserTypeSelectionScreen(),
                        text: "Don't have an account?",
                        widgetName: "Signup",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn(String email, String password) async {
    setState(() {
      _isSignInLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      try {
        UserCredential? userCredentials =
            await _authController.signInWithEmailPassword(
          email,
          password,
        );
        if (userCredentials != null) {
          _showSnackBar(
            "Login was successful",
            context,
          );
          if (!await firestoreService.isUserDocumentEmpty(
            userCredentials.user!.uid,
          )) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => UserTypeSelectionScreen(
                  userCredential: userCredentials,
                ),
              ),
            );
          } else {
            setState(() {
              _isSignInLoading = false;
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const BottomNavigationBarScreen(),
                ),
                (Route<dynamic> route) => false);
            clear();
          }
        }
      } on WrongPasswordException catch (e) {
        _showSnackBar(
          e.message,
          context,
        );
      } on UserNotFoundException catch (e) {
        _showSnackBar(
          e.message,
          context,
        );
      } on NoInternetException catch (e) {
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
    setState(() {
      _isSignInLoading = false;
    });
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
    });
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      UserCredential? userCredential = await _authController
          .googleSignIn(null)
          .onError((error, stackTrace) {});
      if (userCredential != null) {
        _showSnackBar(
          "Google Sign in successful",
          context,
        );
        if (!await firestoreService.isUserDocumentEmpty(
          userCredential.user!.uid,
        )) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserTypeSelectionScreen(
                userCredential: userCredential,
              ),
            ),
          );
          return;
        }
        setState(() {
          _isGoogleLoading = false;
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  const BottomNavigationBarScreen(),
            ),
            (Route<dynamic> route) => false);
      } else {
        _showSnackBar(
          "Google Sign failed unknown reason",
          context,
        );
        debugPrint(userCredential?.user.toString());
      }
    } on NoInternetException catch (e) {
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
      final UserCredential? userCredential =
          await _authController.facebookSignUp(null);
      if (userCredential != null) {
        FocusManager.instance.primaryFocus?.unfocus();
        _showSnackBar(
          "Facebook Sign in successful",
          context,
        );
        if (!await firestoreService.isUserDocumentEmpty(
          userCredential.user!.uid,
        )) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserTypeSelectionScreen(
                userCredential: userCredential,
              ),
            ),
          );
          return;
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  const BottomNavigationBarScreen(),
            ),
            (Route<dynamic> route) => false);
      } else {
        _showSnackBar(
          "Facebook Sign in failed unknown reason",
          context,
        );
      }
    } on NoInternetException catch (e) {
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

  void clear() {
    _emailController.clear();
    _passController.clear();
  }

  void _showSnackBar(
    String subTitle,
    BuildContext context,
  ) {
    setState(() {
      _isSignInLoading = false;
      _isFacebookLoading = false;
      _isGoogleLoading = false;
      _isAppleLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar(
        subTitle: subTitle,
      ),
    );
  }
}

class _ForgotPasswordWidget extends StatelessWidget {
  const _ForgotPasswordWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.height8(context),
        bottom: (SizeConfig.height8(context) * 3),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ForgotPasswordScreen(),
            ),
          );
        },
        child: const Text(
          "Forgot password?",
          textAlign: TextAlign.end,
          style: TextStyle(
            color: appTextColor,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
