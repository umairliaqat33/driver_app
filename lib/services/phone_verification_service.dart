import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class PhoneVerificationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> phoneVerification(String phoneNumber) async {
    String verificationId = "";
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          log("Number verified");
          log("Number verified");
          log(phoneAuthCredential.toString());
        },
        verificationFailed: (verificationFailed) async {
          log("Verification Failed${verificationFailed.message}");
          log(verificationFailed.message.toString());
        },
        codeSent: (verificationID, resendingToken) async {
          verificationId = verificationID;
          log("Code sent");
          log(verificationID.toString());
          log(resendingToken.toString());
        },
        codeAutoRetrievalTimeout: (verificationId) async {},
        timeout: const Duration(seconds: 90),
      );
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (e) {
      log(e.toString());
    }
    return verificationId;
  }
}
