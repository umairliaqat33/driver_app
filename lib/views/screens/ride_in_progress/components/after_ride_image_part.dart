import 'dart:developer';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/global.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:driver_app/views/screens/ride_in_progress/components/after_image_upper_part.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/image_picker_widgets/image_picker_big_widget.dart';
import 'package:driver_app/views/widgets/others/circular_loader_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AfterRideImagePart extends StatefulWidget {
  final String? pickupAddress;
  final String? dropOffAddress;
  final String? image;
  final Function? selectImage;
  final PlatformFile? parcelPlatformFile;
  final Function onTap;

  const AfterRideImagePart({
    super.key,
    required this.onTap,
    this.image,
    this.dropOffAddress,
    this.pickupAddress,
    this.selectImage,
    this.parcelPlatformFile,
  });

  @override
  State<AfterRideImagePart> createState() => _AfterRideImagePartState();
}

class _AfterRideImagePartState extends State<AfterRideImagePart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        SizeConfig.height18(context) - 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: getUserType() == UserType.driver.name,
            child: Text(
              "Take Photo",
              style: TextStyle(
                color: blackColor,
                fontSize: SizeConfig.font18(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Visibility(
            visible: getUserType() == UserType.driver.name,
            child: Text(
              "Take a photo of showing where you left the order, we will share it with restaurant.",
              style: TextStyle(
                color: greyColor,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.font14(context),
              ),
            ),
          ),
          getUserType() == UserType.business.name
              ? AfterImageUpperPart(
                  dropOffAddress: widget.dropOffAddress!,
                  pickupAddress: widget.pickupAddress!,
                )
              : const SizedBox(),
          SizedBox(height: SizeConfig.height10(context) - 2),
          getUserType() == UserType.business.name
              ? Text(
                  AppStrings.dropOffParcelImage,
                  style: TextStyle(
                    fontSize: SizeConfig.font14(context),
                    fontWeight: FontWeight.w400,
                  ),
                )
              : const SizedBox(),
          SizedBox(height: SizeConfig.height10(context) - 2),
          Container(
            height: SizeConfig.height20(context) * 8,
            width: SizeConfig.width20(context) * 16.4,
            decoration: const BoxDecoration(
              color: lightSeaGreenColor,
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: getUserType() == UserType.business.name
                ? widget.image == null
                    ? const CircularLoaderWidget()
                    : Image.network(
                        widget.image!,
                        fit: BoxFit.contain,
                      )
                : ImagePickerBigWidget(
                    heading: AppStrings.parcelPaidOffImage,
                    description: 'add a drop-off image of parcel max size is ',
                    onPressed: () async => widget.selectImage!(),
                    imgUrl: null,
                    platformFile: widget.parcelPlatformFile,
                  ),
          ),
          SizedBox(height: SizeConfig.height10(context) - 2),
          getUserType() == UserType.business.name
              ? Container(
                  height: SizeConfig.height20(context) * 3.4,
                  width: SizeConfig.width20(context) * 16.4,
                  padding: EdgeInsets.all(SizeConfig.height12(context)),
                  decoration: const BoxDecoration(
                    color: lightSeaGreenColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.driverCompletedRide,
                        style: TextStyle(
                          fontSize: SizeConfig.font12(context),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            log("view invoice clicked");
                          },
                          child: Text(
                            "View Invoice",
                            style: TextStyle(
                              fontSize: SizeConfig.font12(context) + 1,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : const SizedBox(),
          SizedBox(height: SizeConfig.height15(context) + 1),
          CustomButton(
            isEnabled: getUserType() == UserType.driver.name
                ? widget.parcelPlatformFile != null
                : true,
            color: primaryColor,
            text: getUserType() == UserType.business.name
                ? AppStrings.iHavePaid.toUpperCase()
                : AppStrings.endRide.toUpperCase(),
            textColor: whiteColor,
            onTap: () async => widget.onTap(),
          ),
        ],
      ),
    );
  }
}
