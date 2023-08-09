import 'package:driver_app/utils/global.dart';

class AppStrings {
  static String signUpString = "Sign Up";
  static String noInternet = 'network-request-failed';
  static String wrongPassword = 'wrong-password';
  static String userNotFound = 'user-not-found';
  static String enteredWrongPassword = 'Email or Password is incorrect';
  static String wentWrong = "Something went wrong";
  static String fetchDataException = "There was a problem in fetching data";
  static String emailInUse = 'email-already-in-use';
  static String imageMissingError = "Image required";
  static String driverNotRegistered = "Not Registered!";
  static String driverApprovedRejected = "Driver Approval Rejected!";
  static String driverNotApproved = "Driver Approval In Review!";
  static String roleDriver = "driver";
  static String roleBusiness = "business";
  static String subscription = "subscription";
  static String favoriteBusinesses = "Favorite Businesses";
  static String favoriteDrivers = "Favorite Drivers";
  static String settings = "Settings";
  static String usingYourOwnVehicle = "Are you using your own vehicle?";
  //Notification dummy data sample
  static String notificationTitleSample1 = "You ride started";
  static String notificationDescriptionSample1 =
      "You have to reach at point A to pick-up parcel";
  static String notificationTitleSample2 = "Rider arrives";
  static String notificationDescriptionSample2 =
      "You reach your pick-up location contact business";
  static String timeSample = "1 min ago";
  static String storagePermissionDeniedText = "Storage Permission denied once";
  static String storagePermissionDeniedPermanentlyText =
      "Storage Permission denied Permanently";
  static String dropOffLocation = "Drop-off Location";
  static String chooseOnMap = "Choose on map";
  static String recentDeliveries = "Recent Deliveries";
  static String cancelRequest = "Cancel Request";
  static String favorite = "favorite";
  static String otherOffers = "Other offers";
  static String accept = "Accept";
  static String decline = "Decline";
  static String makeOffer = "MAKE OFFER";
  static String currentFare = "Current Fare";
  static String reasonableFare = "Offer a reasonable fare";
  static String offerYourFare = "OFFER YOUR FARE";
  static String dropOffParcelImage = "Drop-off parcel image";
  static String driverCompletedRide =
      "The Driver has Completed the Ride. Please pay your driver";
  static String iHavePaid = "I have paid";
  static String endRide = "END RIDE";
  static String complaint = "Complaint";
  static String parcelPaidOffImage = "Parcel drop-off image";
  static String askExperience = "How was your experience with";
  static String rateUser = "Rate ${getUserType()}";
}
