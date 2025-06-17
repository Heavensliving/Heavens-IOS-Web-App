import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/cafe_controller/CafeController.dart';
import 'package:heavens_students/controller/connectivity_controlller/connectivity_controller.dart';
import 'package:heavens_students/controller/homepage_controller/HomepageController.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/controller/profile_controller/ProfileController.dart';
import 'package:heavens_students/controller/profile_controller/profilePic_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heavens_students/controller/homepage_controller/carousal_controller.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('islogged') ?? false;

      if (!mounted) return;

      // final networkController =
      // Provider.of<NetworkController>(context, listen: false);
      // await networkController.checkAccessToken(context);
      await context.read<NetworkController>().checkAccessToken(
        onLogout: () async {
          await context.read<ProfileController>().logout();
          context.read<PicController>().profilePic = null;
        },
        navigateToSignIn: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/signin',
            (route) => false,
          );
        },
      );

      if (isLoggedIn) {
        await _loadAuthenticatedData(context);
        _navigateToHome(context);
      } else {
        _navigateToSignIn(context);
      }
    } catch (e, stackTrace) {
      log("Error during initialization", error: e, stackTrace: stackTrace);
      if (mounted) _navigateToSignIn(context);
    }
  }

  Future<void> _loadAuthenticatedData(BuildContext context) async {
    // final networkController = context.read<NetworkController>();
    // await networkController.checkAccessToken(context);
    await context.read<NetworkController>().checkAccessToken(
      onLogout: () async {
        await context.read<ProfileController>().logout();
        context.read<PicController>().profilePic = null;
      },
      navigateToSignIn: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/signin',
          (route) => false,
        );
      },
    );

    await Future.wait<void>([
      context.read<LoginController>().getStudentDetail(context),
      context.read<CarousalImageController>().getCarousalImages(),
      context.read<CafeController>().getCafeItems(),
      context.read<HomepageController>().checkPaymentStatus(context),
    ]);
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const BottomNavigation(initialIndex: 0),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  void _navigateToSignIn(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      "/signin",
    );
    // Navigator.pushNamed(context, "/getstarted");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: ColorConstants.dark_red,
          body: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive sizing
              final logoSize = constraints.maxWidth * 0.4;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: SizedBox(
                        key: ValueKey<double>(logoSize),
                        width: logoSize,
                        height: logoSize,
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
