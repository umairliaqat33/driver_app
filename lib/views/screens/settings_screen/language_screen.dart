import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/widgets/others/back_arrow_app_bar.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

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
          text: 'Language',
          picture: Assets.arrowBack,
          onPressed: () {
            Navigator.of(context).pop();
          },
          appBarColor: backgroundColor,
          elevation: 1,
        ),
      ),
      body: const Center(
        child: Text(
          "Language screen",
        ),
      ),
    );
  }
}
