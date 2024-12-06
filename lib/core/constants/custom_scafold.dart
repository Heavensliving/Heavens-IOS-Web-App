import 'package:flutter/material.dart';

// This function displays a custom SnackBar with curved borders and customizable padding.
void customSnackBar({
  required String message, // The message to display in the SnackBar
  required BuildContext context, // The BuildContext to show the SnackBar within
  Duration? duration, // Optional: Duration for which the SnackBar is displayed
  EdgeInsetsGeometry? padding, // Optional: Padding for the SnackBar content
  Color? backgroundColor, // Optional: Background color of the SnackBar
}) {
  // Create a SnackBar widget with specified properties
  var snack = SnackBar(
    backgroundColor: Colors.red[300],
    behavior: SnackBarBehavior.floating, // Make the SnackBar floating
    margin: const EdgeInsets.all(20), // Set margin around the SnackBar
    duration: duration ??
        const Duration(milliseconds: 3000), // Default duration if not provided
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(10), // Rounded corners for the SnackBar
    ),
    content: Text(
      message, // Display the provided message text
      style: TextStyle(color: Colors.white), // Default text style
    ),
  );

  // Hide any currently displayed SnackBar
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  // Show the created SnackBar
  ScaffoldMessenger.of(context).showSnackBar(snack);
}
