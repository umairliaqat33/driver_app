import 'dart:developer';

import 'package:driver_app/utils/global.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/exceptions.dart';
import 'package:driver_app/repositories/auth_repository.dart';

class AuthController {
  final AuthRepository _firebaseAuthService = AuthRepository();

  Future<UserCredential?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    UserCredential? userCredentials;
    try {
      getUid();
      userCredentials = await _firebaseAuthService.signIn(email, password);
    } catch (e) {
      rethrow;
    }

    return userCredentials;
  }

  Future<UserCredential?> googleSignIn(
    UserType? userType,
  ) async {
    UserCredential? userCredential;
    try {
      userCredential = await _firebaseAuthService.googleSignIn();
    } on UnknownException catch (e) {
      log(e.message);
      throw UnknownException(e.message);
    }

    return userCredential;
  }

  Future<UserCredential?> facebookSignUp(
    UserType? userType,
  ) async {
    UserCredential? userCredential;
    try {
      userCredential = await _firebaseAuthService.facebookLogin();
    } on UnknownException catch (e) {
      log(e.message);
      throw UnknownException(e.message);
    }

    return userCredential;
  }

  Future<List<String>> checkAccountAuthType(String email) async {
    List<String> result;
    try {
      result = await _firebaseAuthService.checkAuthType(email);
    } catch (e) {
      rethrow;
    }
    return result;
  }

  void resetPassword(String email) async {
    try {
      _firebaseAuthService.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }
}
