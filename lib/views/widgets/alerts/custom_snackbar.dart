import 'package:driver_app/main.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

SnackBar snackBar({
  required String subTitle,
}) {
  return SnackBar(
    backgroundColor: snackBarColor,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    content: SizedBox(
      height: 40,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  subTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: whiteColor,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              snackbarKey.currentState?.hideCurrentSnackBar();
            },
            child: SvgPicture.asset(Assets.cancelIcon),
          ),
          const SizedBox(width: 8),
        ],
      ),
    ),
  );
}
