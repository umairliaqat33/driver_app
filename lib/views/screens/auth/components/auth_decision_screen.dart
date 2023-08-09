import 'package:flutter/material.dart';

import 'package:driver_app/views/screens/auth/components/user_type_selection_screen.dart';
import 'package:driver_app/views/screens/auth/components/decision_banner.dart';
import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/auth/login/login_screen.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';

class AuthDecisionScreen extends StatefulWidget {
  const AuthDecisionScreen({Key? key}) : super(key: key);

  @override
  State<AuthDecisionScreen> createState() => _AuthDecisionScreenState();
}

class _AuthDecisionScreenState extends State<AuthDecisionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: (SizeConfig.width8(context) * 2),
          right: (SizeConfig.width8(context) * 2),
          top: (SizeConfig.height20(context) * 4),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const BannerWidget(
                  heading: "Getting started with switch drivers",
                  logo: Assets.appLogoBlue,
                ),
                CustomButton(
                  text: "LOGIN",
                  color: primaryColor,
                  textColor: whiteColor,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: (SizeConfig.height8(context) * 3)),
                CustomButton(
                  text: "REGISTER",
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const UserTypeSelectionScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
