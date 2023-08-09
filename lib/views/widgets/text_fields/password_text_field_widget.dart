import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:driver_app/constants/text_field_decoration.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';

class PasswordTextFieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController textController;
  final FormFieldValidator validator;
  final String fieldTitle;

  const PasswordTextFieldWidget({
    super.key,
    required this.hintText,
    required this.textController,
    required this.validator,
    required this.fieldTitle,
  });

  @override
  State<PasswordTextFieldWidget> createState() =>
      _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  bool _textVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: widget.validator,
        controller: widget.textController,
        cursorColor: blackColor,
        obscureText: _textVisible,
        decoration: TextFieldDecoration.kPasswordFieldDecoration.copyWith(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _textVisible = !_textVisible;
              });
            },
            icon: _textVisible
                ? SvgPicture.asset(Assets.passwordVisibilityOff)
                : SvgPicture.asset(Assets.passwordVisibilityOn),
          ),
          hintText: widget.hintText,
        ));
  }
}
