import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/views/widgets/others/divider_widget.dart';
import 'package:driver_app/views/widgets/text/basic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserInfoWidget extends StatelessWidget {
  final String imageLink;
  final String name;
  final String subtitle;
  final UserType userType;
  final String? vehicleNo;
  const UserInfoWidget({
    super.key,
    required this.imageLink,
    required this.name,
    required this.subtitle,
    required this.userType,
    this.vehicleNo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DividerWidget(),
        Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.height20(context),
            bottom: SizeConfig.height20(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageLink,
                      height: (SizeConfig.height20(context) * 2),
                      width: (SizeConfig.height20(context) * 2),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextWidget(
                            title: name,
                            fontSize: 14,
                            fontColor: blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(width: 4),
                          Image.asset(Assets.verified),
                          const SizedBox(width: 4),
                          SvgPicture.asset(Assets.starFilled),
                          const SizedBox(width: 4),
                          TextWidget(
                            title: "12",
                            fontSize: 12,
                            fontColor: greyColor,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(width: 2),
                          TextWidget(
                            title: "(${27})",
                            fontSize: 10,
                            fontColor: greyColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      TextWidget(
                        title: subtitle,
                        fontSize: 12,
                        fontColor: greyColor,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 4),
                      userType == UserType.driver
                          ? Row(
                              children: [
                                TextWidget(
                                  title: vehicleNo!,
                                  fontSize: 12,
                                  fontColor: greyColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
              SvgPicture.asset(Assets.phoneCircleImage),
            ],
          ),
        ),
      ],
    );
  }
}
