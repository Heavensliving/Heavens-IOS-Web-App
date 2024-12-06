import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StayDetails extends StatelessWidget {
  const StayDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<LoginController>().studentDetailModel?.student;
    log("date---${provider?.joinDate}");
    DateTime dateTime = DateTime.parse(provider!.joinDate!);

    String formattedDate = DateFormat('MMM d, y').format(dateTime);
    return Scaffold(
      backgroundColor: ColorConstants.primary_white,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: ColorConstants.primary_white,
            )),
        title: Text(
          "Stay Details",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ColorConstants.primary_white),
        ),
        backgroundColor: ColorConstants.dark_red,
      ),
      body: Center(
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.home, color: ColorConstants.dark_red, size: 30),
                    SizedBox(width: 10),
                    Text(
                      provider.pgName ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: ColorConstants.dark_red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Detail rows
                _buildDetailRow(
                    Icons.business, "Stay Type: ", provider.typeOfStay ?? ""),
                SizedBox(height: 10),
                _buildDetailRow(
                    Icons.single_bed, "Room Type: ", provider.roomType ?? ""),
                SizedBox(height: 10),
                _buildDetailRow(
                    Icons.calendar_today, "Join Date: ", formattedDate),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: ColorConstants.dark_red),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            "$title $value",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
