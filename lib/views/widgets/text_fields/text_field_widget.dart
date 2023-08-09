import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:driver_app/constants/text_field_decoration.dart';
import 'package:driver_app/utils/colors.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  final String? Function(dynamic) validator;
  final String? icon;
  final TextInputType? textInputType;
  final bool enabled;
  final bool readOnlyEnabled;
  final int? maxLength;
  final GestureTapCallback? onTap;
  final Function(String)? onChanged;
  final TextAlign textAlign;
  final bool autoFocus;
  final bool isBoxBorder;
  final Widget? suffixIcon;
  final Function? suffixIconOnPressed;
  final bool expand;
  final int? maxLines;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.textController,
    required this.validator,
    this.icon,
    this.textInputType,
    this.enabled = true,
    this.maxLength = 100,
    this.readOnlyEnabled = false,
    this.onTap,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.autoFocus = false,
    this.isBoxBorder = false,
    this.suffixIcon,
    this.suffixIconOnPressed,
    this.expand = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
      enabled: enabled,
      keyboardType: textInputType ?? TextInputType.text,
      textAlign: textAlign,
      validator: validator,
      controller: textController,
      cursorColor: blackColor,
      autofocus: autoFocus,
      expands: expand,
      maxLines: maxLines,
      decoration: TextFieldDecoration.kTextFieldDecoration.copyWith(
        contentPadding: isBoxBorder ? EdgeInsets.zero : null,
        enabledBorder: isBoxBorder
            ? const OutlineInputBorder(
                borderSide: BorderSide(
                  color: textFieldEnabledColor,
                ),
              )
            : const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: textFieldEnabledColor,
                ),
              ),
        focusedBorder: isBoxBorder
            ? const OutlineInputBorder(
                borderSide: BorderSide(
                  color: blackColor,
                ),
              )
            : const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: blackColor,
                ),
              ),
        suffixIcon: suffixIcon != null && suffixIconOnPressed != null
            ? IconButton(
                onPressed: () => suffixIconOnPressed!(),
                icon: suffixIcon!,
              )
            : null,
        icon: icon != null
            ? SvgPicture.asset(
                icon!,
                color: appTextColor,
              )
            : null,
        hintText: hintText,
      ),
      onTap: onTap,
      onChanged: (value) => onChanged == null ? null : onChanged!(value),
      readOnly: readOnlyEnabled,
    );
  }
}
