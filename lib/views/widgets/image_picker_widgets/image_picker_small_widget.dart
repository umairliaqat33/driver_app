// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';

class ImagePickerSmallWidget extends StatelessWidget {
  final Function selectImage;
  final String sideText;
  final String? imgUrl;
  final PlatformFile? platformFile;

  const ImagePickerSmallWidget({
    Key? key,
    required this.sideText,
    required this.imgUrl,
    required this.platformFile,
    required this.selectImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imgUrl != null && platformFile == null
        ? MaterialButton(
            onPressed: () async => selectImage(),
            child: SizedBox(
              width: (SizeConfig.width20(context) * 6),
              height: (SizeConfig.height20(context) * 6),
              child: Image.network(
                imgUrl!,
                fit: BoxFit.contain,
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
            ),
          )
        : platformFile != null
            ? SizedBox(
                width: (SizeConfig.width20(context) * 8),
                height: (SizeConfig.height20(context) * 6),
                child: MaterialButton(
                  onPressed: () async => selectImage(),
                  child: Image.file(
                    File(platformFile!.path!),
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            : SizedBox(
                width: (SizeConfig.width20(context) * 8),
                height: (SizeConfig.height20(context) * 6),
                child: MaterialButton(
                  onPressed: () async => selectImage(),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SvgPicture.asset(
                        Assets.selectImgSmallRectangle,
                        fit: BoxFit.contain,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: (SizeConfig.height20(context) * 3),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: (SizeConfig.height20(context) * 9) + 3,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Click to upload ',
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: sideText,
                                      style: const TextStyle(
                                        color: blackColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: 'of driving license',
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}
