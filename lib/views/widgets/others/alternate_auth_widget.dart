import 'package:flutter/material.dart';

import 'package:driver_app/utils/colors.dart';

class AlternateAuthWidget extends StatelessWidget {
  final Widget screenName;
  final String text;
  final String widgetName;

  const AlternateAuthWidget({
    Key? key,
    required this.screenName,
    required this.text,
    required this.widgetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: appTextColor,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => screenName,
              ),
            );
          },
          child: Text(
            widgetName,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
