import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:driver_app/models/users/user_model.dart';
import 'package:driver_app/repositories/firestore_repository.dart';
import 'package:driver_app/utils/collection_names.dart';

class UserRepository {
  final FirestoreRepository _firestoreRepository = FirestoreRepository();

  Future<void> uploadUserData(
    UserModel? userModel,
  ) async {
    try {
      _firestoreRepository.uploadUserData(userModel);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserInformation() async {
    try {
      User? user = FirestoreRepository.checkUser();
      UserModel? userModel = await _firestoreRepository.getUserData(user!.uid);
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserInformation(UserModel userModel) async {
    try {
      await CollectionsNames.firestoreCollection
          .collection(CollectionsNames.usersCollection)
          .doc(FirestoreRepository.checkUser()!.uid)
          .update(userModel.toJson());
    } catch (e) {
      log(e.toString());
    }
  }
}
