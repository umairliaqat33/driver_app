import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/business/business_registration_screen.dart';
import 'package:driver_app/views/screens/business/components/business_subscription_card.dart';
import 'package:driver_app/views/widgets/others/back_arrow_app_bar.dart';

class BusinessSubscriptionScreen extends StatefulWidget {
  final List<bool> isDataCompleted;

  const BusinessSubscriptionScreen({
    Key? key,
    required this.isDataCompleted,
  }) : super(key: key);

  @override
  State<BusinessSubscriptionScreen> createState() =>
      _BusinessSubscriptionScreenState();
}

class _BusinessSubscriptionScreenState
    extends State<BusinessSubscriptionScreen> {
  List<bool> _isDataCompleted = [];

  @override
  void initState() {
    super.initState();
    _isDataCompleted = widget.isDataCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          (SizeConfig.height12(context) * 4),
        ),
        child: BackArrowAppbar(
          fontSize: 18,
          textColor: appTextColor,
          text: 'Business Info',
          picture: Assets.arrowBack,
          onPressed: () {
            Navigator.of(context).pop();
          },
          appBarColor: backgroundColor,
          elevation: 1,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: (SizeConfig.width8(context) * 2),
          right: (SizeConfig.width8(context) * 2),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: (SizeConfig.height20(context) + 10),
                ),
                child: const Text(
                  "Grow Your Business!",
                  style: TextStyle(
                    color: appTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.height8(context),
              ),
              const Text(
                "Subscribe to our package and enjoy the benefits of delivering services at an affordable rates.",
                style: TextStyle(
                  color: greyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: SizeConfig.height12(context) * 2,
              ),
              BusinessSubscriptionCard(
                subscriptionAmount: '£99',
                subscriptionType: 'Yearly Subscription',
                onTap: () async => _getSubscription(),
              ),
              SizedBox(
                height: SizeConfig.height8(context),
              ),
              BusinessSubscriptionCard(
                subscriptionAmount: '£49',
                subscriptionType: 'Monthly Subscription',
                onTap: () async => _getSubscription(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getSubscription() async {
    setState(() {
      _isDataCompleted[1] = true;
    });
    log('CHECKOUT tapped');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => BusinessRegistrationScreen(
          isDataCompleted: _isDataCompleted,
        ),
      ),
    );
  }
}
