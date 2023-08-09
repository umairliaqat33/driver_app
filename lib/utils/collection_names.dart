import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CollectionsNames {
  static final firestoreCollection = FirebaseFirestore.instance;
  static final firebaseAuth = FirebaseAuth.instance;
  static String driverCollection = 'drivers';
  static String businessCollection = 'businesses';
  static String usersCollection = 'users';
  static String locationCollection = 'locations';
  static String businessRequestCollection = 'businessRequests';
  static String driverRequestCollection = 'driverRequests';
}
