import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:driver_app/views/screens/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:driver_app/views/screens/ratings/components/user_action_widget.dart';
import 'package:driver_app/views/screens/ratings/components/user_info_widget.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';
import 'package:flutter/material.dart';

class GiveRatingsScreen extends StatelessWidget {
  final String userName;
  final String imageLink;
  GiveRatingsScreen({
    super.key,
    required this.userName,
    required this.imageLink,
  });
  final TextEditingController _textController = TextEditingController();
  final int maxLength = 220;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.all(SizeConfig.height15(context) + 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const UserActionWidget(),
          SizedBox(height: SizeConfig.height8(context)),
          UserInfoWidget(userName: userName, imageLink: imageLink),
          SizedBox(
            width: double.infinity,
            height: SizeConfig.height20(context) * 4,
            child: TextFieldWidget(
              expand: true,
              hintText: "How was your experience",
              maxLength: maxLength,
              maxLines: null,
              textController: _textController,
              validator: (value) {
                return null;
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${_textController.text.length}/$maxLength",
              style: TextStyle(
                fontSize: SizeConfig.font10(context),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.height12(context)),
          CustomButton(
            color: primaryColor,
            textColor: whiteColor,
            text: AppStrings.rateUser.toUpperCase(),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const BottomNavigationBarScreen(
                      index: 0,
                    ),
                  ),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
