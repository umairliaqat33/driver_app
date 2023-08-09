import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/views/screens/request/components/offer_item.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/models/local/local_request_model.dart';
import '../../../utils/colors.dart';
import 'package:driver_app/views/screens/job_creation/job_viewing_screen.dart';

class DriverRequestOverlay extends StatefulWidget {
  final LocalRequestModel localRequestModel;
  const DriverRequestOverlay({super.key, required this.localRequestModel});

  @override
  State<StatefulWidget> createState() => _DriverRequestOverlayState();
}

class _DriverRequestOverlayState extends State<DriverRequestOverlay> {
  final List<DriverModel> businessRequestList = [];
  bool _isListVisible = false;
  BusinessRequestModel? _requestModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: whiteTransparent,
      ),
      child: _isListVisible
          ? JobViewingScreen(
              requestOffer: _requestModel,
            )
          : SingleChildScrollView(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.localRequestModel.roleModelList?.length,
                itemBuilder: (BuildContext context, int index) {
                  if (widget.localRequestModel.businessRequestList?[index] !=
                          null &&
                      widget.localRequestModel.businessRequestList?[index]
                              .isRideCompleted !=
                          true) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isListVisible = true;
                          });
                          _requestModel = widget
                              .localRequestModel.businessRequestList?[index];
                        },
                        child: OfferItem<BusinessModel>(
                            driverRequestModel: null,
                            businessRequestOffer: widget
                                .localRequestModel.businessRequestList?[index],
                            profile:
                                widget.localRequestModel.roleModelList?[index]),
                      ),
                    );
                  } else {
                    return null;
                  }
                },
              ),
            ),
    );
  }
}
