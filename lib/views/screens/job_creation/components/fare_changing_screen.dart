import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/others/divider_widget.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';
import 'package:flutter/material.dart';

class FareChangingScreen extends StatelessWidget {
  final int charges;
  final TextEditingController textEditingController;
  final Function onTap;
  const FareChangingScreen({
    super.key,
    required this.charges,
    required this.onTap,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: whiteColor,
            padding: EdgeInsets.only(
              top: SizeConfig.height20(context) + 4,
              bottom: SizeConfig.height8(context),
              right: SizeConfig.width15(context) + 1,
              left: SizeConfig.width15(context) + 1,
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "$charges",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.font20(context),
                    color: blackColor,
                  ),
                ),
                Text(
                  AppStrings.currentFare,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.font12(context),
                    color: greyColor,
                  ),
                ),
                const DividerWidget(),
                TextFieldWidget(
                  hintText: 'Your fare',
                  textController: textEditingController,
                  textAlign: TextAlign.center,
                  autoFocus: true,
                  validator: (value) => Utils.fareValidator(value),
                  textInputType: TextInputType.number,
                ),
                SizedBox(
                  height: SizeConfig.height8(context),
                ),
                Text(
                  AppStrings.reasonableFare,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.font12(context),
                    color: blackColor,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height8(context),
                ),
                CustomButton(
                  color: primaryColor,
                  text: AppStrings.offerYourFare,
                  textColor: whiteColor,
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
