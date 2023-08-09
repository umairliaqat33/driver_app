import 'package:flutter/material.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/business/components/subscription_list_tile_widget.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';

class BusinessSubscriptionCard extends StatelessWidget {
  final String subscriptionType;
  final String subscriptionAmount;
  final Function onTap;

  const BusinessSubscriptionCard({
    Key? key,
    required this.subscriptionAmount,
    required this.subscriptionType,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: greyColor,
              spreadRadius: 0.08,
              // blurRadius: 0.01,
              blurStyle: BlurStyle.outer,
            ),
          ]),
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.width12(context),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.height12(context),
                  ),
                  height: (SizeConfig.height8(context) * 4) + 2,
                  width: (SizeConfig.width8(context) * 4) + 2,
                  decoration: const BoxDecoration(
                    color: blackColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: SizedBox(
                    height: (SizeConfig.height8(context) * 4) + 2,
                    width: (SizeConfig.width8(context) * 4) + 2,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubscriptionListTileWidget(
                        title: subscriptionType,
                        subtitle: subscriptionType == "Monthly Subscription"
                            ? null
                            : "Yearly Subscription",
                        trailingText: subscriptionAmount,
                        subtitleSize: 10,
                        titleSize: 16,
                        trailingSize: 20,
                        titleColor: blackColor,
                        subtitleColor: primaryColor,
                        subtitleWeight: FontWeight.w600,
                        titleWeight: FontWeight.w600,
                        trailingWeight: FontWeight.w700,
                        padding: EdgeInsets.only(
                          top: SizeConfig.height12(context),
                          bottom: SizeConfig.height10(context),
                          left: SizeConfig.width8(context),
                          right: SizeConfig.width12(context),
                        ),
                      ),
                      SubscriptionListTileWidget(
                        title: "Services",
                        subtitle: "Priority customer service",
                        subtitleSize: 10,
                        titleSize: 12,
                        titleColor: blackColor,
                        subtitleColor: greyColor,
                        subtitleWeight: FontWeight.w400,
                        titleWeight: FontWeight.w500,
                        padding: EdgeInsets.only(
                          bottom: SizeConfig.height10(context),
                          left: SizeConfig.width8(context),
                          right: SizeConfig.width12(context),
                        ),
                      ),
                      SubscriptionListTileWidget(
                        title: "24/7 Access",
                        subtitle:
                            "Access to exclusive deliveries around your area",
                        subtitleSize: 10,
                        titleSize: 12,
                        titleColor: blackColor,
                        subtitleColor: greyColor,
                        subtitleWeight: FontWeight.w400,
                        titleWeight: FontWeight.w500,
                        padding: EdgeInsets.only(
                          bottom: SizeConfig.height10(context),
                          left: SizeConfig.width8(context),
                          right: SizeConfig.width12(context),
                        ),
                      ),
                      SubscriptionListTileWidget(
                        title: "Affordable Rates",
                        subtitle: "Get everything is minimum rates",
                        subtitleSize: 10,
                        titleSize: 12,
                        titleColor: blackColor,
                        subtitleColor: greyColor,
                        subtitleWeight: FontWeight.w400,
                        titleWeight: FontWeight.w500,
                        padding: EdgeInsets.only(
                          bottom: SizeConfig.height10(context),
                          left: SizeConfig.width8(context),
                          right: SizeConfig.width12(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.height12(context),
                right: SizeConfig.width12(context),
              ),
              child: CustomButton(
                color: primaryColor,
                textColor: whiteColor,
                text: "CHECKOUT",
                onTap: () => onTap(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
