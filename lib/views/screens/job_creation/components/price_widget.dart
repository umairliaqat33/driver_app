import 'package:driver_app/config/size_config.dart';
import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.charges,
    required this.paymentMethod,
  }) : super(key: key);

  final String charges;
  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "£$charges",
          style: TextStyle(
            fontSize: SizeConfig.font20(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "CASH",
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: SizeConfig.font12(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
