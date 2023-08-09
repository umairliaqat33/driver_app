import 'package:firebase_auth/firebase_auth.dart';

import 'package:driver_app/repositories/driver_repository/driver_auth_repository.dart';

class DriverAuthController {
  final DriverAuthRepository _driverAuthRepository = DriverAuthRepository();

  Future<UserCredential?> signUp(
    String email,
    String password,
  ) async {
    UserCredential? userCredential;
    try {
      userCredential = await _driverAuthRepository.signUp(
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
      userCredential = await _driverAuthRepository.googleSignIn();
    } catch (e) {
      rethrow;
    }
    return userCredential;
  }

  Future<UserCredential?> facebookSignUp() async {
    UserCredential? userCredential;
    try {
      userCredential = await _driverAuthRepository.facebookLogin();
    } catch (e) {
      rethrow;
    }

    return userCredential;
  }
}
