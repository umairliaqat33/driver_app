import 'package:flutter/material.dart';

import 'package:driver_app/utils/colors.dart';

class TextFieldDecoration {
  static const kMessageContainerDecoration = BoxDecoration(
    border: Border(
      top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    ),
  );

  static const kTextFieldDecoration = InputDecoration(
    hintText: 'Enter a value',
  );
  static const kPasswordFieldDecoration = InputDecoration(
    hintText: 'Enter a value',
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: blackColor,
        width: 1,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: textFieldEnabledColor,
      ),
    ),
  );
}
