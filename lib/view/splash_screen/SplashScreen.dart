import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/cafe_controller/CafeController.dart';
import 'package:heavens_students/controller/homepage_controller/HomepageController.dart';
import 'package:heavens_students/controller/homepage_controller/carousal_controller.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // bool _isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('islogged') ?? false;
    log("--$isLoggedIn");

    if (isLoggedIn) {
      await context.read<LoginController>().getStudentDetail(context);
      await context.read<CarousalImageController>().getCarousalImages();
      await context.read<CafeController>().getCafeItems();
      await context.read<CarousalImageController>().getCarousalImages();
      await context.read<HomepageController>().checkPaymentStatus(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavigation(initialIndex: 0),
        ),
      );
    } else {
      Navigator.pushReplacementNamed(context, "/signin");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.dark_red,
      body: Center(
          child: SizedBox(
        height: 100,
        width: 100,
        child: Image.asset("assets/images/logo.png"),
      )),
    );
  }
}
