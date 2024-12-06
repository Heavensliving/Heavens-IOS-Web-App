import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/view/MessManager/order_details/OrderDetails.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodePage extends StatefulWidget {
  final String bookingId;
  final String mealType;
  final List foodItems;
  final bool isAddons;
  final String? addonItems;
  final String bookingStatus;

  const QrcodePage({
    super.key,
    required this.bookingId,
    required this.mealType,
    required this.foodItems,
    required this.isAddons,
    this.addonItems,
    required this.bookingStatus,
  });

  @override
  State<QrcodePage> createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {
  @override
  Widget build(BuildContext context) {
    log("booking status---${widget.bookingStatus}");
    var time = "";
    if (widget.mealType == "Breakfast") {
      time = "8 AM - 9 PM";
    } else if (widget.mealType == "Dinner") {
      time = "12:45 AM - 2 PM";
    } else {
      time = "8 PM - 9 PM";
    }
    double screenHeight = MediaQuery.of(context).size.height;
    log("fooditems--${widget.foodItems}");
    return Scaffold(
      backgroundColor: ColorConstants.primary_white,
      appBar: AppBar(
        backgroundColor: ColorConstants.primary_white,
        leading: InkWell(
            onTap: () {
              if (widget.isAddons) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetails(),
                    ));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavigation(initialIndex: 1),
                    ));
              }
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          "Mess Manager",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: screenHeight * .03),
            QrImageView(
              data: widget.bookingId,
              size: screenHeight * 0.23,
            ),
            Text(
              "Booking ID: ${widget.bookingId}",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            ),
            SizedBox(height: screenHeight * .04),
            Container(
              height: screenHeight * 0.7,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              color: Colors.grey.withOpacity(.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Meal Type",
                        style: TextStyle(
                            color:
                                ColorConstants.primary_black.withOpacity(.5)),
                      ),
                      Text(
                        widget.mealType,
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorConstants.primary_black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Meal Time",
                        style: TextStyle(
                            color:
                                ColorConstants.primary_black.withOpacity(.5)),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorConstants.primary_black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Location",
                        style: TextStyle(
                            color:
                                ColorConstants.primary_black.withOpacity(.5)),
                      ),
                      Text(
                        context
                                .watch<LoginController>()
                                .studentDetailModel
                                ?.student
                                ?.pgName ??
                            "",
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorConstants.primary_black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isAddons ? "Adon Item" : "Food Items",
                        style: TextStyle(
                            color:
                                ColorConstants.primary_black.withOpacity(.5)),
                      ),
                      widget.isAddons
                          ? Text(
                              "${widget.addonItems}",
                              style: TextStyle(
                                fontSize: 18,
                                color: ColorConstants.primary_black,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * .32,
                              child: ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 10,
                                ),
                                itemCount: widget.foodItems.length,
                                itemBuilder: (context, index) => Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.foodItems[index]}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: ColorConstants.primary_black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      SizedBox(height: 30),
                      Text(
                        "Booking Status",
                        style: TextStyle(
                            color:
                                ColorConstants.primary_black.withOpacity(.5)),
                      ),
                      Text(
                        widget.bookingStatus == "delivered"
                            ? "Delivered"
                            : "Pending",
                        style: TextStyle(
                          fontSize: 18,
                          color: widget.bookingStatus == "delivered"
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
