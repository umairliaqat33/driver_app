import 'package:flutter/material.dart';

import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/global.dart';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:driver_app/views/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeGlobalController();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (BuildContext context) {
        return const MyApp();
      },
    ),
  );
}

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: snackbarKey,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: 'Gilroy',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: blackColor),
          bodyMedium: TextStyle(color: blackColor),
          bodySmall: TextStyle(color: blackColor),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Switch Driver',
      home: const SplashScreen(),
    );
  }
}
