// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/controllers/auth_controller.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/exceptions.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:driver_app/views/screens/auth/components/decision_banner.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/others/circular_loader_widget.dart';
import 'package:driver_app/views/widgets/alerts/custom_snackbar.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: (SizeConfig.width8(context) * 2),
              right: (SizeConfig.width8(context) * 2),
            ),
            child: SizedBox(
              height: SizeConfig.height(context) - 30,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: SizeConfig.height20(context) * 2,
                    ),
                    const BannerWidget(
                      heading: "Forgot your password?",
                      description:
                          "We all have forgotten our password before. But don’t worry we have got your back!",
                      logo: Assets.forgotPasswordImage,
                    ),
                    TextFieldWidget(
                      hintText: "johndoe@gmail.com",
                      textController: _emailController,
                      validator: (value) => Utils.emailValidator(value),
                    ),
                    SizedBox(
                      height: SizeConfig.height12(context),
                    ),
                    Text(
                      "Sending link to email above. Click on the button below to reset your password",
                      style: TextStyle(
                        fontSize: SizeConfig.font12(context),
                        fontWeight: FontWeight.w400,
                        color: greyColor,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: (SizeConfig.height15(context) * 2),
                      ),
                      child: _isLoading
                          ? const CircularLoaderWidget()
                          : CustomButton(
                              color: primaryColor,
                              textColor: whiteColor,
                              text: "RESET PASSWORD",
                              onTap: () => _forgotPassword(),
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

  Future<void> _forgotPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        AuthController authController = AuthController();
        List<String> result =
            await authController.checkAccountAuthType(_emailController.text);
        if (result.isEmpty) {
          _showSnackBar(
            "No account found for this email",
            context,
          );
        } else {
          authController.resetPassword(_emailController.text);
          _showSnackBar(
            "Please check your email inbox.",
            context,
          );
        }
      }
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
    setState(() {
      _isLoading = false;
    });
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
