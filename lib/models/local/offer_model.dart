class OfferModel {
  final double pickupLocationLatitude;
  final double pickupLocationLongitude;
  final double dropOffLocationLatitude;
  final double dropOffLocationLongitude;
  final String charges;
  final String paymentType;

  OfferModel(
      {required this.pickupLocationLatitude,
      required this.pickupLocationLongitude,
      required this.dropOffLocationLatitude,
      required this.dropOffLocationLongitude,
      required this.charges,
      required this.paymentType});
}
