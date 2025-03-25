import 'dart:async';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/custom_scafold.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkController extends ChangeNotifier {
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  bool isInitialized = false;

  NetworkController() {
    _init();
  }

  ConnectivityResult get connectivityResult => _connectivityResult;
  bool get isConnected => _connectivityResult != ConnectivityResult.none;

  Future<void> _init() async {
    try {
      // Get initial connectivity status (returns List<ConnectivityResult>)
      final results = await connectivity.checkConnectivity();
      // Take the first result (or none if empty)
      _connectivityResult =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      isInitialized = true;
      notifyListeners();

      // Listen for connectivity changes
      _connectivitySubscription = connectivity.onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        log('Connectivity changed: $results');
        // Take the first result (or none if empty)
        _connectivityResult =
            results.isNotEmpty ? results.first : ConnectivityResult.none;
        notifyListeners();
      });
    } catch (e) {
      log('Error initializing NetworkController', error: e);
    }
  }

  Future<void> checkConnection() async {
    final results = await connectivity.checkConnectivity();
    _connectivityResult =
        results.isNotEmpty ? results.first : ConnectivityResult.none;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> retryConnection(BuildContext context) async {
    try {
      log("Checking connectivity...");
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

  Future<void> checkAccessToken({
    required Future<void> Function() onLogout,
    required void Function() navigateToSignIn,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("access_token") ?? "";

      if (accessToken.isEmpty || JwtDecoder.isExpired(accessToken)) {
        log("Token expired or missing");
        await prefs.clear();
        await onLogout();
        navigateToSignIn();
      }
    } catch (e, stackTrace) {
      log("Token validation failed", error: e, stackTrace: stackTrace);
    }
  }
}
