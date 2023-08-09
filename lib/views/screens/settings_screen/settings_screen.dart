import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/controllers/global_controller.dart';
import 'package:driver_app/models/users/user_model.dart';
import 'package:driver_app/repositories/auth_repository.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/auth/components/auth_decision_screen.dart';
import 'package:driver_app/views/screens/profile_screen/components/tile_widget.dart';
import 'package:driver_app/views/screens/settings_screen/rules_and_terms.dart';
import 'package:driver_app/views/widgets/alerts/delete_account_alert.dart';
import 'package:driver_app/views/widgets/others/back_arrow_app_bar.dart';
import 'package:driver_app/views/widgets/alerts/custom_snackbar.dart';

class SettingsScreen extends StatelessWidget {
  final UserModel? userModel;
  const SettingsScreen({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    log("Height: ${SizeConfig.height(context)}");

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          (SizeConfig.height12(context) * 4),
        ),
        child: BackArrowAppbar(
          fontSize: 18,
          textColor: appTextColor,
          text: 'Settings',
          picture: Assets.arrowBack,
          onPressed: () {
            Navigator.of(context).pop();
          },
          appBarColor: backgroundColor,
          elevation: 1,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TileWidget(
            text: "Rules and terms",
            trailingImg: Assets.arrowForwardHead,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RulesAndTermsScreen(),
                ),
              );
            },
            cardColor: backgroundColor,
            titleTextColor: appTextColor,
            leadingImg: null,
          ),
          TileWidget(
            text: "Delete Account",
            trailingImg: Assets.arrowForwardHead,
            onTap: () {
              deleteAccountAlert(
                context: context,
                description:
                    "If you delete your account it will not retrieve are you sure?",
                image: Assets.deleteAccountAlert,
                heading: "Deleting Account",
                onCancelTap: () {
                  Navigator.of(context).pop();
                },
                onDeleteTap: () {
                  AuthRepository authRepository = AuthRepository();
                  authRepository.deleteUserAccount(
                    userModel!.uid!,
                    userModel!.role,
                  );
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const AuthDecisionScreen()),
                    (route) => false,
                  );
                  _showSnackBar("Account Deleted",
                      "Account and it's data is deleted!", context);
                },
              );
            },
            cardColor: backgroundColor,
            titleTextColor: appTextColor,
            leadingImg: null,
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.height12(context)),
            child: TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  FacebookAuth.instance.logOut();
                  GoogleSignIn().signOut();
                  GlobalController.clearPreferences();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const AuthDecisionScreen(),
                    ),
                    (route) => false,
                  );
                  _showSnackBar(
                    "Logged out",
                    "Log out was successful",
                    context,
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.font14(context),
                      color: alertColor,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(
    String title,
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
