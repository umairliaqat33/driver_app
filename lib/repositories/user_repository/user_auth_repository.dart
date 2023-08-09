import 'package:firebase_auth/firebase_auth.dart';

import 'package:driver_app/repositories/auth_repository.dart';

class UserAuthRepository {
  final AuthRepository _authRepository = AuthRepository();

  Future<UserCredential?> signUp(
    String email,
    String password,
  ) async {
    UserCredential? userCredential;
    try {
      userCredential = await _authRepository.signUp(
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
      userCredential = await _authRepository.googleSignIn();
    } catch (e) {
      rethrow;
    }
    return userCredential;
  }

  Future<UserCredential?> facebookLogin() async {
    UserCredential? userCredential;
    try {
      userCredential = await _authRepository.facebookLogin();
    } catch (e) {
      rethrow;
    }
    return userCredential;
  }
}
