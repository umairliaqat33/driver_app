import 'package:flutter/material.dart';

import 'package:driver_app/utils/colors.dart';

class TextFieldLabelWidget extends StatelessWidget {
  final String label;
  const TextFieldLabelWidget({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: greyColor,
        fontSize: 10,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
