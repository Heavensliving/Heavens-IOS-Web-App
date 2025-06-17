import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/cafe_controller/CafeController.dart';
import 'package:heavens_students/controller/cart_controller.dart';
import 'package:heavens_students/controller/connectivity_controlller/connectivity_controller.dart';
import 'package:heavens_students/controller/homepage_controller/HomepageController.dart';
import 'package:heavens_students/controller/homepage_controller/carousal_controller.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/controller/mess_controller/MessController.dart';
import 'package:heavens_students/controller/order_controller/order_controller.dart';
import 'package:heavens_students/controller/other_functions/otherFunctions.dart';
import 'package:heavens_students/controller/profile_controller/ProfileController.dart';
import 'package:heavens_students/controller/profile_controller/profilePic_controller.dart';
import 'package:heavens_students/firebase_options.dart';
import 'package:heavens_students/view/homepage/homepage.dart';
import 'package:heavens_students/view/homepage/payment_history/payment_history.dart';
import 'package:heavens_students/view/homepage/raised_tickets/raised_tickets.dart';
import 'package:heavens_students/view/no_internet_screen/noInternetScreen.dart';
import 'package:heavens_students/view/profile/change_password/ChangePassword.dart';
import 'package:heavens_students/view/profile/personal_information/PersonalInformation.dart';
import 'package:heavens_students/view/profile/stay_details/StayDetails.dart';
import 'package:heavens_students/view/sign_In/SignIn.dart';
import 'package:heavens_students/view/splash_screen/SplashScreen.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const HeavensStudent());
}

class HeavensStudent extends StatefulWidget {
  const HeavensStudent({super.key});

  @override
  State<HeavensStudent> createState() => _HeavensStudentState();
}

class _HeavensStudentState extends State<HeavensStudent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _checkForUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => Otherfunctions()),
        ChangeNotifierProvider(create: (_) => MessController()),
        ChangeNotifierProvider(create: (_) => HomepageController()),
        ChangeNotifierProvider(create: (_) => CafeController()),
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => NetworkController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => PicController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
        ChangeNotifierProvider(create: (_) => CarousalImageController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          'home': (context) => const Homepage(),
          '/raised': (context) => const RaisedTickets(),
          '/payment_history': (context) => const PaymentHistory(),
          '/signin': (context) => const Signin(),
          '/personal_information': (context) => const PersonalInformation(),
          '/change_password': (context) => const ChangePassword(),
          '/stay_detail': (context) => const StayDetails(),
          '/nointernet': (context) => NoInternetScreen(),
        },
      ),
    );
  }

  // Widget _buildHomeScreen(
  //     BuildContext context, NetworkController networkController) {
  //   // Always show SplashScreen first
  //   if (!networkController.isInitialized) {
  //     return const SplashScreen();
  //   }
  //deyy

  //   // Show NoInternetScreen when disconnected, otherwise show the appropriate screen
  //   return networkController.isConnected
  //       ? const SplashScreen()
  //       : const NoInternetScreen();
  // }

  Future<void> _checkForUpdate() async {
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.android) {
      await _checkAndroidUpdate();
    } else if (platform == TargetPlatform.iOS) {
      await _checkiOSUpdate();
    }
  }

  Future<void> _checkAndroidUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      log("Error checking for Android update: $e");
    }
  }

  Future<void> _checkiOSUpdate() async {
    //   final InAppReview inAppReview = InAppReview.instance;
    //   if (await inAppReview.isAvailable()) {
    //     inAppReview.openStoreListing(appStoreId: "1213344532");
    //   }
  }
}
