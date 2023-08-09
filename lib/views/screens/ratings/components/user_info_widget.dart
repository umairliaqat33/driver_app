import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    super.key,
    required this.userName,
    required this.imageLink,
  });

  final String userName;
  final String imageLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.askExperience,
          style: TextStyle(
            color: blackColor,
            fontSize: SizeConfig.font16(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: SizeConfig.height8(context)),
        Text(
          userName,
          style: TextStyle(
            color: primaryColor,
            fontSize: SizeConfig.font16(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: SizeConfig.height8(context)),
        Image.network(
          imageLink,
          fit: BoxFit.fill,
          height: SizeConfig.height12(context) * 4,
          width: SizeConfig.width12(context) * 4,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
        SizedBox(height: SizeConfig.height12(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.starFilled,
              width: SizeConfig.width15(context) + 1,
              height: SizeConfig.height15(context) + 1,
            ),
            const SizedBox(width: 3),
            SvgPicture.asset(
              Assets.starFilled,
              width: SizeConfig.width15(context) + 1,
              height: SizeConfig.height15(context) + 1,
            ),
            const SizedBox(width: 3),
            SvgPicture.asset(
              Assets.starFilled,
              width: SizeConfig.width15(context) + 1,
              height: SizeConfig.height15(context) + 1,
            ),
            const SizedBox(width: 3),
            SvgPicture.asset(
              Assets.starFilled,
              width: SizeConfig.width15(context) + 1,
              height: SizeConfig.height15(context) + 1,
            ),
            const SizedBox(width: 3),
            SvgPicture.asset(
              Assets.starNotFilled,
              width: SizeConfig.width15(context) + 1,
              height: SizeConfig.height15(context) + 1,
            ),
          ],
        )
      ],
    );
  }
}
