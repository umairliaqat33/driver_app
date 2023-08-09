// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:driver_app/views/screens/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:driver_app/views/screens/request/components/offer_item.dart';
import 'package:driver_app/controllers/request_controller/driver_request_controller/driver_request_controller.dart';
import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/models/request_models/driver_request_model/driver_request_model.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:driver_app/views/screens/job_creation/job_viewing_screen.dart';
import 'package:driver_app/models/local/local_request_model.dart';
import 'package:driver_app/models/user_data.dart';
import 'package:driver_app/utils/global.dart';
import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/controllers/business_controllers/business_firestore_controller.dart';
import 'package:driver_app/controllers/driver_controller/driver_firestore_controller.dart';
import 'package:driver_app/controllers/request_controller/business_request_controller/business_request_controller.dart';
import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/models/local/offer_model.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';

class BusinessRequestScreen extends StatelessWidget {
  const BusinessRequestScreen({
    super.key,
    required this.localRequestModel,
    required this.offer,
    this.request,
  });
  final LocalRequestModel localRequestModel;
  final OfferModel offer;
  final BusinessRequestModel? request;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return true;
      },
      child: FractionallySizedBox(
        heightFactor: 0.96,
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.10),
          appBar: PreferredSize(
              preferredSize: Size(
                double.infinity,
                (SizeConfig.height12(context) * 4),
              ),
              child: const _BusinessRequestScreenAppBar()),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _BusinessScreenBodyRequestBlock(
                        AppStrings.otherOffers,
                        localRequestModel,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: (SizeConfig.height15(context)),
              ),
              Expanded(
                flex: 0,
                child: JobViewingScreen(
                  requestOffer: request,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeHeight() {}
}

class _BusinessRequestScreenAppBar extends StatelessWidget {
  const _BusinessRequestScreenAppBar();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      leading: null,
      titleSpacing: 0.0,
      title: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(right: 19),
        child: GestureDetector(
          onTap: () {
            _cancelRequest();
            Navigator.of(context).pop(true);
          },
          child: Text(AppStrings.cancelRequest,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: blackColor,
              )),
        ),
      ),
    );
  }

  void _cancelRequest() {
    BusinessRequestController requestController = BusinessRequestController();
    requestController.cancelBusinessRequest(getUid()!);
  }
}

class _BusinessScreenBodyRequestBlock extends StatefulWidget {
  final String driverCategory;
  final LocalRequestModel localRequestModel;
  const _BusinessScreenBodyRequestBlock(
      this.driverCategory, this.localRequestModel);

  @override
  State<_BusinessScreenBodyRequestBlock> createState() =>
      _BusinessScreenBodyRequestBlockState();
}

class _BusinessScreenBodyRequestBlockState
    extends State<_BusinessScreenBodyRequestBlock> {
  final List<DriverModel> driversRequestList = [];
  BusinessRequestController requestController = BusinessRequestController();
  final DriverRequestController _driverRequestController =
      DriverRequestController();
  final DriverFirestoreController _driverFirestoreController =
      DriverFirestoreController();
  UserData userData = UserData();

  @override
  void initState() {
    super.initState();
    _initializeDriver();
    _initializeDriver();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DriverRequestModel>>(
        stream: _driverRequestController.getDriverRequests(getUid()!),
        builder: (_, AsyncSnapshot<List<DriverRequestModel>> snapshot1) {
          if (snapshot1.hasData) {
            _storeRequests(snapshot1.data!);
            _isRideCompleted(snapshot1.data!);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (snapshot1.hasData)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                  child: Text(
                    widget.driverCategory.toUpperCase(),
                    style: const TextStyle(
                        color: whiteColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              if (snapshot1.hasData && snapshot1.data!.isNotEmpty)
                StreamBuilder(
                  stream: _driverFirestoreController
                      .getDrivers(extractDocumentIds(snapshot1.data!)),
                  builder: (_, AsyncSnapshot<QuerySnapshot> snapshot2) {
                    if (snapshot2.hasData) {
                      _storeRoleModels(snapshot2);
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.localRequestModel.roleModelList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return OfferItem<DriverModel>(
                          driverRequestModel: widget
                              .localRequestModel.driverRequestList?[index],
                          businessRequestOffer: null,
                          profile:
                              widget.localRequestModel.roleModelList?[index],
                          driverId: widget
                              .localRequestModel.roleModelList?[index].uid,
                        );
                      },
                    );
                  },
                ),
            ],
          );
        });
  }

  void _storeRequests(List<DriverRequestModel> snapshot) {
    for (int i = 0; i < snapshot.length; i++) {
      if (widget.localRequestModel.driverRequestList!.isEmpty ||
          widget.localRequestModel.driverRequestList!.length <= i) {
        widget.localRequestModel.driverRequestList!.add(snapshot[i]);
      } else {
        widget.localRequestModel.driverRequestList![i] = snapshot[i];
      }
    }
  }

  void _isRideCompleted(List<DriverRequestModel> list) async {
    BusinessRequestModel? businessRequestModel =
        await requestController.getActiveBusinessRequest(getUid());
    for (var element in list) {
      if (businessRequestModel != null &&
          businessRequestModel.isRideCompleted &&
          element.requestId == businessRequestModel.acceptorDriverId &&
          element.isRideCompleted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavigationBarScreen(
              index: 0,
            ),
          ),
          (route) => false,
        );
      }
    }
  }

  void _storeRoleModels(AsyncSnapshot<QuerySnapshot> snapshot) {
    widget.localRequestModel.roleModelList!.clear();
    snapshot.data?.docs.map((e) => e.data()).forEach((element) {
      widget.localRequestModel.roleModelList!.add(element as DriverModel);
    });
  }

  List<String> extractDocumentIds(List<DriverRequestModel> snapshot) {
    List<String> documentIdsList = [];
    if (snapshot.isNotEmpty) {
      for (var element in snapshot) {
        documentIdsList.add(element.requestId);
      }
    }
    return documentIdsList;
  }

  void _initializeDriver() {
    driversRequestList.add(DriverModel(
      email: "",
      name: "Test driver",
      isVerified: true,
      rating: 4.5,
      totalRatings: 27,
      vehicleType: VehicleType.car.name.toUpperCase(),
      profileImageLink: Assets.sampleProfileImage,
    ));
    driversRequestList.add(DriverModel(
      email: "",
      name: "Test driver",
      isVerified: true,
      rating: 4.5,
      totalRatings: 27,
      vehicleType: VehicleType.car.name.toUpperCase(),
      profileImageLink: Assets.sampleProfileImage,
    ));
  }

  Future<void> _getData() async {
    final DriverFirestoreController driverFirestoreController =
        DriverFirestoreController();
    final BusinessFirestoreController businessFirestoreController =
        BusinessFirestoreController();
    if (getUserType() == AppStrings.roleDriver) {
      userData = UserData<DriverModel>();
      userData.data = await driverFirestoreController.getData();
    } else {
      userData = UserData<BusinessModel>();
      userData.data = await businessFirestoreController.getBusinessData();
    }
  }
}
