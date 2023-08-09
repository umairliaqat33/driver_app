import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/models/request_models/driver_request_model/driver_request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:driver_app/models/local/local_request_model.dart';
import 'package:driver_app/models/location_model/location_model.dart';
import 'package:driver_app/models/users/user_model.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:driver_app/utils/collection_names.dart';
import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/utils/exceptions.dart';
import 'package:driver_app/utils/enums.dart';
import '../utils/global.dart';
import '../utils/keys.dart';

class FirestoreRepository {
  Future<void> postDetailsToFirebase(
    DriverModel? driverModel,
    BusinessModel? businessModel,
    UserType userType,
  ) async {
    try {
      if (userType == UserType.driver) {
        log('uploading data for $userType');
        await CollectionsNames.firestoreCollection
            .collection(CollectionsNames.driverCollection)
            .doc(driverModel!.uid)
            .set(
              driverModel.toJson(),
            );
      } else {
        log('uploading data for $userType');
        await CollectionsNames.firestoreCollection
            .collection(CollectionsNames.businessCollection)
            .doc(businessModel!.uid)
            .set(
              businessModel.toJson(),
            );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == AppStrings.noInternet) {
        throw SocketException("${e.code}${e.message}");
      } else {
        throw UnknownException(
            "${AppStrings.wentWrong} ${e.code} ${e.message}");
      }
    } on SocketException catch (e) {
      throw NoInternetException("No internet ${e.message}");
    } on FormatException catch (e) {
      throw FormatParsingException(
          "${AppStrings.fetchDataException} ${e.message}");
    }
  }

  Future<void> uploadUserData(
    UserModel? userModel,
  ) async {
    try {
      await CollectionsNames.firestoreCollection
          .collection(CollectionsNames.usersCollection)
          .doc(userModel!.uid)
          .set(
            userModel.toJson(),
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == AppStrings.noInternet) {
        throw SocketException("${e.code}${e.message}");
      } else {
        throw UnknownException(
            "${AppStrings.wentWrong} ${e.code} ${e.message}");
      }
    } on SocketException catch (e) {
      throw NoInternetException("No internet ${e.message}");
    } on FormatException catch (e) {
      throw FormatParsingException(
          "${AppStrings.fetchDataException} ${e.message}");
    }
  }

  Future<UserModel?> getUserData(
    String id,
  ) async {
    try {
      final value = await CollectionsNames.firestoreCollection
          .collection(CollectionsNames.usersCollection)
          .doc(id)
          .get();
      if (value.data() == null) return null;
      return UserModel.fromJson(value.data()!);
    } on FirebaseAuthException catch (e) {
      if (e.code == AppStrings.noInternet) {
        throw SocketException("${e.code}${e.message}");
      } else {
        throw UnknownException(
            "${AppStrings.wentWrong} ${e.code} ${e.message}");
      }
    } on SocketException catch (e) {
      throw NoInternetException("No internet ${e.message}");
    } on FormatException catch (e) {
      throw FormatParsingException(
          "${AppStrings.fetchDataException} ${e.message}");
    }
  }

  Future<bool> isUserDocumentEmpty(
    String id,
  ) async {
    bool isPresent = false;
    try {
      await CollectionsNames.firestoreCollection
          .collection(CollectionsNames.usersCollection)
          .doc(id)
          .snapshots()
          .first
          .then((value) {
        isPresent = value.exists;
      });
      return isPresent;
    } on FirebaseAuthException catch (e) {
      if (e.code == AppStrings.noInternet) {
        throw SocketException("${e.code}${e.message}");
      } else {
        throw UnknownException(
            "${AppStrings.wentWrong} ${e.code} ${e.message}");
      }
    } on SocketException catch (e) {
      throw NoInternetException("No internet ${e.message}");
    } on FormatException catch (e) {
      throw FormatParsingException(
          "${AppStrings.fetchDataException} ${e.message}");
    }
  }

  Future getData(
    String id,
    UserType userType,
  ) async {
    try {
      if (userType == UserType.driver) {
        var value = await CollectionsNames.firestoreCollection
            .collection(CollectionsNames.driverCollection)
            .doc(id)
            .get();
        if (value.data() == null) return null;
        return DriverModel.fromJson(value.data()!);
      } else if (userType == UserType.business) {
        var value = await CollectionsNames.firestoreCollection
            .collection(CollectionsNames.businessCollection)
            .doc(id)
            .get();
        if (value.data() == null) return null;

        return BusinessModel.fromJson(value.data()!);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == AppStrings.noInternet) {
        throw SocketException("${e.code}${e.message}");
      } else {
        throw UnknownException(
            "${AppStrings.wentWrong} ${e.code} ${e.message}");
      }
    } on SocketException catch (e) {
      throw NoInternetException("No internet ${e.message}");
    } on FormatException catch (e) {
      throw FormatParsingException(
          "${AppStrings.fetchDataException} ${e.message}");
    }
  }

  Future<DriverModel?> getSpecificDriverData(
    String id,
  ) async {
    DocumentSnapshot<Map<String, dynamic>> value = await CollectionsNames
        .firestoreCollection
        .collection(CollectionsNames.driverCollection)
        .doc(id)
        .get();
    if (value.data() == null) return null;
    return DriverModel.fromJson(value.data()!);
  }

  Future<BusinessModel?> getSpecificBusinessData(
    String id,
  ) async {
    var value = await CollectionsNames.firestoreCollection
        .collection(CollectionsNames.businessCollection)
        .doc(id)
        .get();
    if (value.data() == null) return null;
    return BusinessModel.fromJson(value.data()!);
  }

  static User? checkUser() {
    User? user = CollectionsNames.firebaseAuth.currentUser;
    return user;
  }

  static Future<UserType?> checkUserType() async {
    User? user = CollectionsNames.firebaseAuth.currentUser;
    final value = await CollectionsNames.firestoreCollection
        .collection(CollectionsNames.usersCollection)
        .doc(user?.uid)
        .get();
    if (value.data() == null) return null;
    UserModel userModel = UserModel.fromJson(value.data()!);
    UserType userType =
        userModel.role == 'driver' ? UserType.driver : UserType.business;

    return userType;
  }

  Stream<List<LocationModel?>> getAllAvailableDrivers() {
    return CollectionsNames.firestoreCollection
        .collection(CollectionsNames.locationCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => LocationModel.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<void> updateLatestLocation(LocationModel locationModel) async {
    await CollectionsNames.firestoreCollection
        .collection(CollectionsNames.locationCollection)
        .doc(locationModel.userId)
        .set(locationModel.toJson());
  }

  Future<LocationModel?> getUserLocation(String uid) async {
    var value = await CollectionsNames.firestoreCollection
        .collection(CollectionsNames.locationCollection)
        .doc(uid)
        .get();
    if (value.data() == null) return null;
    return LocationModel.fromJson(value.data()!);
  }

  Future<void> createRequest(BusinessRequestModel request) async {
    try {
      await CollectionsNames.firestoreCollection
          .collection(CollectionsNames.businessRequestCollection)
          .doc(request.requestId)
          .set(request.toJson());
    } catch (e) {
      log("Exception in firestore repository ${e.toString()}");
    }
  }

  void deleteAllDriverRequest(String businessId) async {
    final WriteBatch batch = CollectionsNames.firestoreCollection.batch();

    await CollectionsNames.firestoreCollection
        .collection(CollectionsNames.businessRequestCollection)
        .doc(businessId)
        .collection(CollectionsNames.driverRequestCollection)
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        batch.delete(doc.reference);
      }
    });

    await batch.commit();
  }

  Future<void> cancelBusinessRequest(String documentId) async {
    try {
      final WriteBatch batch = CollectionsNames.firestoreCollection.batch();
      //this will help us to delete the documents in a nested collection and
      //then the next delete command below will delete whole document
      await CollectionsNames.firestoreCollection
          .collection(CollectionsNames.businessRequestCollection)
          .doc(documentId)
          .collection(CollectionsNames.driverRequestCollection)
          .get()
          .then((value) async {
        for (var doc in value.docs) {
          batch.delete(doc.reference);
        }
      });

      await batch.commit();
      await CollectionsNames.firestoreCollection
          .collection(CollectionsNames.businessRequestCollection)
          .doc(documentId)
          .delete();
    } catch (e) {
      log("Exception in firestore repository ${e.toString()}");
    }
  }

  Future<void> declineBusinessOffer(String documentId) async {
    try {
      await CollectionsNames.firestoreCollection
          .collection(CollectionsNames.businessRequestCollection)
          .doc(documentId)
          .delete();
    } catch (e) {
      log("Exception in firestore repository ${e.toString()}");
    }
  }

  Future<void> declineDriverOffer(String documentId) async {
    try {
      await CollectionsNames.firestoreCollection
          .collection(CollectionsNames.businessRequestCollection)
          .doc(getUid())
          .collection(CollectionsNames.driverRequestCollection)
          .doc(documentId)
          .delete();
    } catch (e) {
      log("Exception in firestore repository ${e.toString()}");
    }
  }

  Stream<QuerySnapshot> getBusinessesRequests(String? riderType) {
    var value = CollectionsNames.firestoreCollection
        .collection(CollectionsNames.businessRequestCollection)
        .where(KeyStrings.riderType, isEqualTo: riderType)
        .withConverter(
            fromFirestore: BusinessRequestModel.fromFirestore,
            toFirestore: (BusinessRequestModel requestModel, _) =>
                requestModel.toFirestore())
        .snapshots();
    return value;
  }

  Stream<List<BusinessRequestModel>> getBusinessesRequestsStream(
      String? riderType) {
    riderType = riderType == VehicleType.bike.name
        ? VehicleType.car.name
        : VehicleType.bike.name;
    return CollectionsNames.firestoreCollection
        .collection(CollectionsNames.businessRequestCollection)
        .where(KeyStrings.riderType, isNotEqualTo: riderType)
        .snapshots()
        .map<List<BusinessRequestModel>>(
      (snapshots) {
        return snapshots.docs.map(
          (doc) {
            return BusinessRequestModel.fromJson(doc.data());
          },
        ).toList();
      },
    ).map<List<BusinessRequestModel>>(
      (event) {
        return event
            .where(
              (element) => !element.declinedUsersIdList!.contains(
                getUid(),
              ),
            )
            .toList();
      },
    ).map<List<BusinessRequestModel>>(
      (event) {
        return event
            .where((element) => (element.acceptorDriverId!.isEmpty ||
                element.acceptorDriverId == getUid()))
            .toList();
      },
    );
  }

  Stream<DocumentSnapshot?> getSpecificDriverReqStream(
    String driverReqId,
    String businessReqId,
  ) {
    return CollectionsNames.firestoreCollection
        .collection(CollectionsNames.businessRequestCollection)
        .doc(businessReqId)
        .collection(CollectionsNames.driverRequestCollection)
        .doc(driverReqId)
        .snapshots();
  }

  Stream<DocumentSnapshot?> getSpecificBusinessReqStream(
    String businessReqId,
  ) {
    return CollectionsNames.firestoreCollection
        .collection(CollectionsNames.businessRequestCollection)
        .doc(businessReqId)
        .snapshots();
  }

  Future<BusinessRequestModel?> getActiveBusinessRequest(
      String? businessId) async {
    var value = await CollectionsNames.firestoreCollection
        .collection(CollectionsNames.businessRequestCollection)
        .doc(businessId)
        .get();
    if (value.data() == null) return null;
    return BusinessRequestModel.fromJson(value.data()!);
  }

  Stream<QuerySnapshot> getBusinesses(List<String>? documentIds) {
    final CollectionReference businessCollection = CollectionsNames
        .firestoreCollection
        .collection(CollectionsNames.businessCollection);
    final value = (documentIds == null)
        ? businessCollection.snapshots()
        : businessCollection
            .where("uid", whereIn: documentIds)
            .withConverter(
                fromFirestore: BusinessModel.fromFirestore,
                toFirestore: (BusinessModel businessModel, _) =>
                    businessModel.toFirestore())
            .snapshots();
    return value;
  }

  Stream<QuerySnapshot> getDrivers(List<String>? documentIds) {
    final CollectionReference businessCollection = CollectionsNames
        .firestoreCollection
        .collection(CollectionsNames.driverCollection);
    final value = (documentIds == null)
        ? businessCollection.snapshots()
        : businessCollection
            .where("uid", whereIn: documentIds)
            .withConverter(
                fromFirestore: DriverModel.fromFirestore,
                toFirestore: (DriverModel driverModel, _) =>
                    driverModel.toFirestore())
            .snapshots();
    return value;
  }

  // Stream<List<DriverRequestModel>> getDriverRequests(String businessId) {
  //   final CollectionReference businessCollection = CollectionsNames
  //       .firestoreCollection
  //       .collection(CollectionsNames.businessRequestCollection);

  //   final CollectionReference driverCollection = businessCollection
  //       .doc(businessId)
  //       .collection(CollectionsNames.driverRequestCollection);

  //   return businessCollection
  //       .doc(businessId)
  //       .snapshots()
  //       .asyncMap((businessDoc) {
  //     return driverCollection.get().then((driverQuerySnapshot) {
  //       return driverQuerySnapshot.docs.map((driverDoc) {
  //         final Map<String, dynamic> data =
  //             driverDoc.data() as Map<String, dynamic>;
  //         return DriverRequestModel.fromJson(data);
  //       }).toList();
  //     });
  //   });
  // }

  Stream<List<DriverRequestModel>> getDriverRequests(String businessRequestId) {
//     CollectionReference reference = CollectionsNames.firestoreCollection
    //     .collection(CollectionsNames.businessRequestCollection);

    // Query requestQuery = reference
    //     .where('requestId', isEqualTo: businessRequestId)
    //     .where('isRideCompleted', isEqualTo: false);

    // return requestQuery.snapshots().map(
    //       (snapshot) => snapshot.docs
    //           .map(
    //             (doc) => DriverRequestModel.fromJson(
    //               jsonDecode(doc.data().toString()),
    //             ),
    //           )
    //           .toList(),
    //     );

    return CollectionsNames.firestoreCollection
        .collection(CollectionsNames.businessRequestCollection)
        .doc(businessRequestId)
        .collection(CollectionsNames.driverRequestCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => DriverRequestModel.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<DriverRequestModel?> getAcceptedDriverRequest(
    String businessReqId,
    String driverReqId,
  ) async {
    final value = await CollectionsNames.firestoreCollection
        .collection(CollectionsNames.businessRequestCollection)
        .doc(businessReqId)
        .collection(CollectionsNames.driverRequestCollection)
        .doc(driverReqId)
        .get();
    if (value.data() == null) return null;
    return DriverRequestModel.fromJson(value.data()!);
  }

  Stream<QuerySnapshot> getBusinessRequestGeneralStream() {
    return CollectionsNames.firestoreCollection
        .collection(CollectionsNames.businessRequestCollection)
        .snapshots();
  }

  Future<void> sendDriverRequest(
    DriverRequestModel requestModel,
    String? businessRequestId,
  ) async {
    try {
      await CollectionsNames.firestoreCollection
          .collection(CollectionsNames.businessRequestCollection)
          .doc(businessRequestId)
          .collection(CollectionsNames.driverRequestCollection)
          .doc(requestModel.requestId)
          .set(requestModel.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  /*Stream<QuerySnapshot> sendDriverRequest(String uid) {
    final CollectionReference driverCollection = CollectionsNames.firestoreCollection
      .collection(CollectionsNames.driverCollection);
    final value =  (documentIds == null) ?
      driverCollection.snapshots() :
      driverCollection.where(KeyStrings.uid, whereIn: documentIds)
      .withConverter(
      fromFirestore: DriverModel.fromFirestore,
      toFirestore: (DriverModel driverModel, _) => driverModel.toFirestore()
      ).snapshots();
    return value;
  }*/

  StreamSubscription<QuerySnapshot<Object?>> getActiveBusinessesRequests(
    String? riderType,
    LocalRequestModel localRequestModel,
  ) {
    return getBusinessesRequests(riderType).listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            localRequestModel.businessRequestList
                ?.add(change.doc.data() as BusinessRequestModel);
            break;
          case DocumentChangeType.modified:
            int? index = localRequestModel.businessRequestList
                ?.indexOf(change.doc.data() as BusinessRequestModel);
            localRequestModel.businessRequestList?[index!] =
                change.doc.data() as BusinessRequestModel;
            break;
          case DocumentChangeType.removed:
            localRequestModel.businessRequestList
                ?.remove(change.doc.data() as BusinessRequestModel);
            break;
        }
      }
    });
  }
}
