import 'package:flutter/material.dart';

class SubscriptionListTileWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailingText;
  final double titleSize;
  final double? subtitleSize;
  final double? trailingSize;
  final Color titleColor;
  final Color? subtitleColor;
  final FontWeight? subtitleWeight;
  final FontWeight titleWeight;
  final FontWeight? trailingWeight;
  final EdgeInsets padding;

  const SubscriptionListTileWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.subtitleSize,
    this.subtitleColor,
    required this.titleColor,
    required this.titleSize,
    this.subtitleWeight,
    required this.titleWeight,
    required this.padding,
    this.trailingSize,
    this.trailingWeight,
    this.trailingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: titleWeight,
                  fontSize: titleSize,
                  color: titleColor,
                ),
              ),
              trailingText == null
                  ? const SizedBox()
                  : Text(
                      trailingText!,
                      style: TextStyle(
                        fontWeight: trailingWeight,
                        fontSize: trailingSize,
                        color: titleColor,
                      ),
                    ),
            ],
          ),
          subtitle == null
              ? const SizedBox()
              : Text(
                  subtitle!,
                  style: TextStyle(
                    fontWeight: subtitleWeight,
                    fontSize: subtitleSize,
                    color: subtitleColor,
                  ),
                ),
        ],
      ),
    );
  }
}
