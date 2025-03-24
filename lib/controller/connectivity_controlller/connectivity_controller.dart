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
  // final Connectivity connectivity = Connectivity();
  // late StreamSubscription _connectivitySubscription;
  // ConnectivityResult _connectivityResult = ConnectivityResult.none;

  // NetworkController() {
  //   _connectivitySubscription =
  //       connectivity.onConnectivityChanged.listen((event) {
  //     if (event.isNotEmpty) {
  //       _updateConnectionStatus(event.first);
  //       // handleNavigation(con);
  //     }
  //   });
  // }

  // ConnectivityResult get connectivityResult => _connectivityResult;
  // void _updateConnectionStatus(ConnectivityResult result) {
  //   _connectivityResult = result;
  //   notifyListeners();
  // }

  // void handleNavigation(BuildContext context) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (context.mounted) {
  //       if (_connectivityResult == ConnectivityResult.none) {
  //         Navigator.pushNamed(context, "/nointernet");
  //       }
  //     }
  //   });
  // }

  final Connectivity connectivity = Connectivity();
  late StreamSubscription _connectivitySubscription;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  BuildContext? _context;

  NetworkController() {
    _init();
  }

  // Call this when you have a valid context
  void setContext(BuildContext context) {
    _context = context;
    _checkInitialConnectivity();
  }

  Future<void> _init() async {
    final results = await connectivity.checkConnectivity();
    _updateConnectionStatus(_determinePrimaryStatus(results));

    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty) {
        final newStatus = _determinePrimaryStatus(results);
        _updateConnectionStatus(newStatus);
        _handleConnectivityChange(newStatus);
      }
    });
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await connectivity.checkConnectivity();
    final status = _determinePrimaryStatus(results);
    _updateConnectionStatus(status);
    _handleConnectivityChange(status);
  }

  ConnectivityResult _determinePrimaryStatus(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.none)
        ? ConnectivityResult.none
        : results.firstWhere(
            (result) => result != ConnectivityResult.none,
            orElse: () => ConnectivityResult.none,
          );
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_context != null && _context!.mounted) {
        if (result == ConnectivityResult.none) {
          Navigator.of(_context!).pushNamedAndRemoveUntil(
            '/nointernet',
            (route) => route.settings.name == '/nointernet',
          );
        }
      }
    });
  }

  ConnectivityResult get connectivityResult => _connectivityResult;

  void _updateConnectionStatus(ConnectivityResult result) {
    _connectivityResult = result;
    notifyListeners();
  }

  // Future<void> _checkInitialConnectivity() async {
  //   final result = await connectivity.checkConnectivity();
  //   _updateConnectionStatus(result);
  // }

  // void handleNavigation() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (_connectivityResult == ConnectivityResult.none) {
  //       // Navigate to no internet screen if there's no connectivity
  //       Navigator.pushNamed(context, "/nointernet");
  //     } else {
  //       // Navigate to the main screen if connected
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => BottomNavigation(initialIndex: 0),
  //         ),
  //         (route) => false,
  //       );
  //     }
  //   });
  // }

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
