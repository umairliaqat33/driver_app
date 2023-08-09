import 'package:flutter/material.dart';

import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:driver_app/views/widgets/buttons/text_button_widget.dart';

class DriverOfferItemLowerBlock extends StatelessWidget {
  const DriverOfferItemLowerBlock(
      {super.key, required this.onRequestAction, required this.requestId});
  final Function(RequestDecision) onRequestAction;
  final String requestId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: TextButtonWidget(
            text: AppStrings.decline,
            onPressed: () {
              onRequestAction(RequestDecision.decline);
            },
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w500,
            backgroundColor: whiteTransparent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextButtonWidget(
            text: AppStrings.accept,
            onPressed: () {
              onRequestAction(RequestDecision.accept);
            },
            fontSize: 14,
            color: whiteColor,
            fontWeight: FontWeight.w500,
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }
}
