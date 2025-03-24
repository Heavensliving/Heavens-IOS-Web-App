// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';

// class NetworkController extends ChangeNotifier {
//   final Connectivity connectivity = Connectivity();
//   late StreamSubscription _connectivitySubscription;
//   ConnectivityResult _connectivityResult = ConnectivityResult.none;

//   NetworkController() {
//     _connectivitySubscription =
//         connectivity.onConnectivityChanged.listen((event) {
//       if (event.isNotEmpty) {
//         _updateConnectionStatus(event.first);
//       }
//     });
//   }

//   ConnectivityResult get connectivityResult => _connectivityResult;

//   void _updateConnectionStatus(ConnectivityResult result) {
//     _connectivityResult = result;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     // Cancel the subscription when the controller is disposed
//     _connectivitySubscription.cancel();
//     super.dispose();
//   }
// }

<<<<<<< HEAD
=======
// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';

// class NetworkController extends ChangeNotifier {
//   final Connectivity connectivity = Connectivity();
//   late StreamSubscription _connectivitySubscription;
//   ConnectivityResult _connectivityResult = ConnectivityResult.none;

//   NetworkController() {
//     _connectivitySubscription =
//         connectivity.onConnectivityChanged.listen((event) {
//       if (event.isNotEmpty) {
//         _updateConnectionStatus(event.first);
//       }
//     });
//   }

//   ConnectivityResult get connectivityResult => _connectivityResult;

//   void _updateConnectionStatus(ConnectivityResult result) {
//     _connectivityResult = result;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     // Cancel the subscription when the controller is disposed
//     _connectivitySubscription.cancel();
//     super.dispose();
//   }
// }

>>>>>>> 8831dc7 (changes added in connectivity controller)
import 'dart:async';
import 'dart:developer';
import 'package:heavens_students/controller/profile_controller/ProfileController.dart';
import 'package:heavens_students/controller/profile_controller/profilePic_controller.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/custom_scafold.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkController extends ChangeNotifier {
<<<<<<< HEAD
  final Connectivity connectivity = Connectivity();
  late StreamSubscription _connectivitySubscription;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  NetworkController() {
    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen((event) {
      if (event.isNotEmpty) {
        _updateConnectionStatus(event.first);
      }
    });
  }
  void _updateConnectionStatus(ConnectivityResult result) {
    _connectivityResult = result;
    notifyListeners();
  }

  ConnectivityResult get connectivityResult => _connectivityResult;

  void handleNavigation(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isConnected) {
        navigatorKey.currentState?.pushReplacementNamed('/nointernet');
=======
  final Connectivity connectivity = Connectivity();
  late StreamSubscription _connectivitySubscription;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  NetworkController() {
    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen((event) {
      if (event.isNotEmpty) {
        _updateConnectionStatus(event.first);
      }
    });
  }
  void _updateConnectionStatus(ConnectivityResult result) {
    _connectivityResult = result;
    notifyListeners();
  }

  ConnectivityResult get connectivityResult => _connectivityResult;

  void handleNavigation(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        if (_connectivityResult == ConnectivityResult.none) {
          Navigator.pushNamed(context, "/nointernet");
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigation(initialIndex: 0),
            ),
            (route) => false,
          );
        }
>>>>>>> 8831dc7 (changes added in connectivity controller)
      if (context.mounted) {
        if (_connectivityResult == ConnectivityResult.none) {
          Navigator.pushNamed(context, "/nointernet");
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigation(initialIndex: 0),
            ),
            (route) => false,
          );
        }
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

  checkAccessToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    // Duration tokenTime = JwtDecoder.getTokenTime(accessToken);
    DateTime expirationDate = JwtDecoder.getExpirationDate(accessToken);
    bool isTokenExpired = JwtDecoder.isExpired(accessToken);
    log("Token is expired or not ----${isTokenExpired}");
    log("expiray date ----${expirationDate}");
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
