import 'package:flutter/material.dart';
import 'package:heavens_students/controller/connectivity_controlller/connectivity_controller.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:provider/provider.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.signal_wifi_off,
                size: screenWidth * 0.25, // Responsive icon size
                color: Colors.grey,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Oops! No Internet Connection.',
                style: TextStyle(
                  fontSize: screenWidth * 0.055, // Responsive text size
                  fontWeight: FontWeight.bold,
                ),
              ),
              // SizedBox(height: screenHeight * 0.01),
              Text(
                'Please check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorConstants.primary_black.withOpacity(.5),
                  fontSize: screenWidth * 0.035,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                width: screenWidth * 0.3,
                height: screenHeight * 0.04,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.dark_red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    context.read<NetworkController>().retryConnection(context);
                  },
                  child: Text(
                    "Retry",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
