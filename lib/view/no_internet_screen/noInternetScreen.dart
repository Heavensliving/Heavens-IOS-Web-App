import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_off,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops! No Internet Connection.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              // padding: EdgeInsets.symmetric(vertical: 3),
              height: 30,
              width: 80,
              decoration: BoxDecoration(
                color: ColorConstants.dark_red,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Container(
                    child: Text(
                  "Retry",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
