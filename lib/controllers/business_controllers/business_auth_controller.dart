import 'package:firebase_auth/firebase_auth.dart';

import 'package:driver_app/repositories/business_repository/business_auth_repository.dart';

class BusinessAuthController {
  final BusinessAuthRepository _businessAuthRepository =
      BusinessAuthRepository();

  Future<UserCredential?> signUp(
    String email,
    String password,
  ) async {
    UserCredential? userCredential;
    try {
      userCredential = await _businessAuthRepository.signUp(
        email,
        password,
      );
    } catch (e) {
      rethrow;
    }

    return userCredential;
  }

  Future<UserCredential?> googleSignIn() async {
    UserCredential? userCredential;
    try {
      userCredential = await _businessAuthRepository.googleSignIn();
    } catch (e) {
      rethrow;
    }

    return userCredential;
  }

  Future<UserCredential?> facebookSignUp() async {
    UserCredential? userCredential;
    try {
      userCredential = await _businessAuthRepository.facebookLogin();
    } catch (e) {
      rethrow;
    }

    return userCredential;
  }
}
