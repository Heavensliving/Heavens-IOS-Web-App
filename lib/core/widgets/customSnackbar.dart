import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';

void showCustomSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: ColorConstants.primary_black.withOpacity(.5),
      duration: Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(10),
    ),
  );
}
