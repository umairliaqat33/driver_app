import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:driver_app/services/media_service.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/constants/text_field_decoration.dart';
import 'package:driver_app/utils/colors.dart';

class DatePickerFieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController textController;
  final FormFieldValidator validator;
  final String? icon;

  const DatePickerFieldWidget({
    super.key,
    required this.hintText,
    required this.textController,
    required this.validator,
    this.icon,
  });

  @override
  State<DatePickerFieldWidget> createState() => _DatePickerFieldWidgetState();
}

class _DatePickerFieldWidgetState extends State<DatePickerFieldWidget> {
  DateTime? dateTime = DateTime.now();

  Future<void> getDate() async {
    dateTime = await MediaService.datePicker(
        widget.hintText == "Date of Birth" ? true : false, context);
    if (dateTime != null) {
      setState(() {
        widget.textController.text = DateFormat.yMd().format(dateTime!);
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      onTap: () {
        getDate();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: widget.textController,
      keyboardType: TextInputType.none,
      decoration: TextFieldDecoration.kTextFieldDecoration.copyWith(
        suffixIcon: MaterialButton(
          child: SvgPicture.asset(
            Assets.calenderIcon,
          ),
          onPressed: () {
            getDate();
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
        icon: widget.icon != null
            ? SvgPicture.asset(
                widget.icon!,
                color: appTextColor,
              )
            : null,
        hintText: widget.hintText,
      ),
    );
  }
}
