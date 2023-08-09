import 'dart:async';
import 'dart:developer';

import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/text_fields/text_field_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/vehicle_type_card.dart';
import 'package:driver_app/models/local/offer_model.dart';
import 'package:driver_app/utils/utils.dart';

class JobCreationScreen extends StatefulWidget {
  final Function onAllTap;
  final Function onBikeTap;
  final Function onCarTap;

  final Function(BusinessRequestModel, OfferModel) onFindDriver;
  final String? pickupAddress;
  final String? dropOffAddress;
  final Function onDropOfFieldTap;
  final Function onPickUpFieldTap;
  final VehicleType selectedVehicleType;

  const JobCreationScreen({
    super.key,
    required this.selectedVehicleType,
    required this.onAllTap,
    required this.onBikeTap,
    required this.onCarTap,
    required this.onFindDriver,
    required this.pickupAddress,
    this.dropOffAddress,
    required this.onDropOfFieldTap,
    required this.onPickUpFieldTap,
  });

  @override
  State<JobCreationScreen> createState() => _JobCreationScreenState();
}

class _JobCreationScreenState extends State<JobCreationScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropOffController = TextEditingController();
  final TextEditingController _fareController = TextEditingController();
  late StreamController dropOffLocationStreamController;
  final Border _border = Border.all(
    color: primaryColor.withOpacity(0.7),
    width: 2,
  );
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    if (widget.pickupAddress != null) {
      _pickupController.text = widget.pickupAddress!;
    }
    if (widget.dropOffAddress != null) {
      _dropOffController.text = widget.dropOffAddress!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.height10(context),
        right: SizeConfig.width15(context) + 1,
        left: SizeConfig.width15(context) + 1,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _vehicleCategoryContainer(
              widget.onCarTap,
              widget.onBikeTap,
              widget.onAllTap,
            ),
            TextFieldWidget(
              icon: Assets.pickupLocationPinIcon,
              hintText: "Pickup Location",
              textController: _pickupController,
              readOnlyEnabled: true,
              validator: (value) {
                if (_pickupController.text.isEmpty) {
                  return "Pickup location required";
                }
                return null;
              },
              onTap: () => widget.onPickUpFieldTap(),
            ),
            TextFieldWidget(
              icon: Assets.dropOffLocationIcon,
              hintText: "Drop off location",
              textController: _dropOffController,
              suffixIcon: _dropOffController.text.isEmpty
                  ? null
                  : SvgPicture.asset(
                      Assets.cancelIcon,
                      color: greyColor,
                    ),
              suffixIconOnPressed: () =>
                  _dropOffController.text.isEmpty ? null : onClearIconButton(),
              validator: (value) {
                if (_dropOffController.text.isEmpty) {
                  return "Drop off location required";
                }
                return null;
              },
              readOnlyEnabled: true,
              onTap: () => widget.onDropOfFieldTap(),
            ),
            TextFieldWidget(
              maxLength: 5,
              icon: Assets.fareAmountIcon,
              textInputType: TextInputType.number,
              hintText: "Make your fare",
              textController: _fareController,
              validator: (value) => Utils.fareValidator(value),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.height5(context) + 1),
              child: CustomButton(
                color: primaryColor,
                textColor: whiteColor,
                text: "FIND DRIVER",
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onFindDriver(
                        BusinessRequestModel(
                          requestId: "",
                          isRideCompleted: false,
                          isRideCancelled: false,
                          pickupLocationLatitude: 0.00,
                          pickupLocationLongitude: 0.00,
                          dropOffLocationLatitude: 0.00,
                          dropOffLocationLongitude: 0.00,
                          fare: double.parse(_fareController.text),
                          riderType: "",
                        ),
                        OfferModel(
                            pickupLocationLatitude: 0.00,
                            pickupLocationLongitude: 0.00,
                            dropOffLocationLatitude: 0.00,
                            dropOffLocationLongitude: 0.00,
                            charges: _fareController.text,
                            paymentType: PaymentType.cash.name.toUpperCase()));
                  } else {
                    log("locations or fare is empty");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onClearIconButton() {
    _dropOffController.clear();
  }

  Row _vehicleCategoryContainer(
      Function onCarTap, Function onBikeTap, Function onAllTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _vehicleCategoryBox(
          VehicleType.all,
          Assets.cubeTypeVehicle,
          onAllTap,
          yellowColor,
          "All Drivers",
        ),
        _vehicleCategoryBox(
          VehicleType.bike,
          Assets.bikeTypeVehicle,
          onBikeTap,
          skyColor,
          "Bike",
        ),
        _vehicleCategoryBox(
          VehicleType.car,
          Assets.carTypeVehicle,
          onCarTap,
          greyBlackColor,
          "Car",
        ),
      ],
    );
  }

  GestureDetector _vehicleCategoryBox(
    VehicleType vehicleType,
    String image,
    Function onTap,
    Color color,
    String text,
  ) {
    return GestureDetector(
      onTap: () => onTap(),
      child: VehicleTypeCard(
        color: color,
        image: image,
        text: vehicleType.name.toUpperCase(),
        border: widget.selectedVehicleType == vehicleType ? _border : null,
      ),
    );
  }
}
