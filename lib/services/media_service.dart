import 'dart:developer';
import 'dart:io';

import 'package:driver_app/utils/exceptions.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:driver_app/repositories/firestore_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaService {
  static Future<DateTime?> datePicker(
    bool isDateOfBirth,
    BuildContext context,
  ) {
    return showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: isDateOfBirth ? DateTime(1900) : DateTime.now(),
            lastDate: isDateOfBirth ? DateTime.now() : DateTime(2030))
        .then(
      (pickedDate) {
        if (pickedDate != null) {
          return pickedDate;
        } else if (pickedDate == null) {
          return null;
        }
        return null;
      },
    );
  }

  static Future<String?> uploadFile(
    PlatformFile? platformFile,
    String userType, {
    bool isRequest = false,
  }) async {
    if (platformFile == null) return null;
    String path = "";
    User? user = FirestoreRepository.checkUser();
    path = isRequest
        ? 'files/requestsImages/$userType/${user!.uid}/${DateTime.now().millisecond}'
        : 'files/$userType/${user!.uid}/${DateTime.now().millisecond}';
    final file = File(platformFile.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    final TaskSnapshot taskSnapshot = await ref.putFile(file);
    return await taskSnapshot.ref.getDownloadURL();
  }

  // ignore: body_might_complete_normally_nullable
  static Future<PlatformFile?> selectFile() async {
    PermissionStatus permissionStatus = await Permission.storage.request();
    try {
      if (permissionStatus == PermissionStatus.granted) {
        PlatformFile platformFile;
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );
        if (result == null) return null;
        platformFile = result.files.first;
        log(platformFile.path.toString());
        log(platformFile.toString());
        return platformFile;
      }
    } catch (e) {
      if (permissionStatus == PermissionStatus.denied) {
        throw StoragePermissionDenied(
          AppStrings.storagePermissionDeniedText,
        );
      } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
        throw StoragePermissionDeniedPermanently(
          AppStrings.storagePermissionDeniedPermanentlyText,
        );
      } else {
        throw UnknownException("${AppStrings.wentWrong} ${log.toString()}");
      }
    }
  }
}
