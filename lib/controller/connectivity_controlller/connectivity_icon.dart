import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';

class NetworkController extends ChangeNotifier {
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

  ConnectivityResult get connectivityResult => _connectivityResult;

  void _updateConnectionStatus(ConnectivityResult result) {
    _connectivityResult = result;
    notifyListeners();
  }

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
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription when the controller is disposed
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
