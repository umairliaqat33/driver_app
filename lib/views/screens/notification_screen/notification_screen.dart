// ignore_for_file: unused_element

import 'package:driver_app/models/notification/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: _NotificationAppBar(),
      ),
      body: _NotificationScreenBody(),
    );
  }
}

class _NotificationAppBar extends StatelessWidget {
  const _NotificationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Notifications",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: appTextColor,
          )),
      backgroundColor: Colors.transparent,
      bottomOpacity: 0.0,
      elevation: 0.0,
      titleSpacing: 16.0,
    );
  }
}

class _NotificationScreenBody extends StatelessWidget {
  _NotificationScreenBody({super.key});

  final List<NotificationModel> notifications = [
    NotificationModel(
        asset: Assets.tickFilled,
        title: AppStrings.notificationTitleSample1,
        description: AppStrings.notificationDescriptionSample1,
        time: AppStrings.timeSample)
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (BuildContext context, int index) {
          return NotificationItem(notification: notifications[index]);
        });
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.notification});
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: notificationImageBoxColor,
                  borderRadius: BorderRadius.circular(6)),
              child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: SvgPicture.asset(
                    Assets.tickFilled,
                    fit: BoxFit.cover,
                  ))),
          Padding(
              padding: const EdgeInsets.only(left: 11.0, top: 2.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Your ride started",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: appTextColor),
                  ),
                  Text("You have to reach at point A to pick-up parcel",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: greyColor)),
                  Text("9 min ago",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 8,
                          color: greyColor)),
                ],
              ))
        ],
      ),
    );
  }
}
