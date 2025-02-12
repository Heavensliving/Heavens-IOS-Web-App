import 'dart:async';
import 'dart:developer';
import 'package:heavens_students/controller/profile_controller/ProfileController.dart';
import 'package:heavens_students/controller/profile_controller/profilePic_controller.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/custom_scafold.dart';
import 'package:heavens_students/main.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkController extends ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  NetworkController() {
    _checkInitialConnectivity();
    startListeningToConnectivityChanges();
  }

  ConnectivityResult get connectivityResult => _connectivityResult;
  bool get isConnected => _connectivityResult != ConnectivityResult.none;

  Future<void> _checkInitialConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    log("Initial Connectivity: $results");

    if (results != ConnectivityResult.none) {
      _connectivityResult = results.first;
    } else {
      _connectivityResult = ConnectivityResult.none;
      notifyListeners();
      handleNavigation();
    }
  }

  void startListeningToConnectivityChanges() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      log("Connectivity Changed: $result");
      if (result != _connectivityResult) {
        _connectivityResult = result.first;
        notifyListeners();
      }

      if (_connectivityResult == ConnectivityResult.none) {
        handleNavigation();
      }
    });
  }

  void handleNavigation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isConnected) {
        navigatorKey.currentState?.pushReplacementNamed('/nointernet');
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> retryConnection(BuildContext context) async {
    try {
      log("Checking connectivity...");

      // await Future.delayed(
      //     Duration(seconds: 1));

      final response = await http.get(Uri.parse('https://www.google.com'));

      log("Current connectivity status: ${response.statusCode}");

      if (response.statusCode == 200) {
        log("Internet connected, navigating to the main screen.");

        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BottomNavigation(initialIndex: 0),
            ),
          );
        }
      } else {
        log("No internet connection.");
        customSnackBar(
          message: 'Still no internet connection.',
          context: context,
        );
      }
    } on Exception catch (e) {
      log("Couldn't check connectivity status", error: e);
      customSnackBar(
        message: 'Error checking internet connection.',
        context: context,
      );
    }
  }

  // when access token expires then logout

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  checkAccessToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    Duration tokenTime = JwtDecoder.getTokenTime(accessToken);

    bool isTokenExpired = JwtDecoder.isExpired(accessToken);
    log("Token is expired or not ----${tokenTime.inDays}");
    if (isTokenExpired) {
      log("Token is expired.");
      await prefs.clear();
      await context.read<ProfileController>().logout();
      context.read<PicController>().profilePic = null;

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/signin', (Route<dynamic> route) => false);
    } else {
      log("Token is valid.");
    }
  }
}


