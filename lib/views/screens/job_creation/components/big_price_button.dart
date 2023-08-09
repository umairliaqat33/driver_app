import 'dart:developer';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';
import 'package:flutter/material.dart';

class BigPriceWidget extends StatelessWidget {
  const BigPriceWidget({
    Key? key,
    required this.onTap,
    required this.textEditingController,
    required this.onChange,
  }) : super(key: key);

  final Function onTap;
  final TextEditingController textEditingController;
  final Function(String?) onChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (SizeConfig.height15(context) * 2) + 5,
      child: TextFieldWidget(
        textAlign: TextAlign.center,
        maxLength: 5,
        textInputType: TextInputType.number,
        hintText: "Enter your fare",
        textController: textEditingController,
        isBoxBorder: true,
        validator: (value) => Utils.fareValidator(value),
        onChanged: (value) {
          log("price changed");
          onChange(value);
        },
        onTap: () => onTap(),
      ),
    );
  }
}
