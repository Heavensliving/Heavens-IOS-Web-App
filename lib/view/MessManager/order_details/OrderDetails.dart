import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heavens_students/controller/mess_controller/MessController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/view/MessManager/widgets/QRcode_page.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    var addons = context.watch<MessController>().addOnListMess;

    // Group items by orderId

    Map<String, List<Map<String, dynamic>>> groupedAddons = {};
    for (var addon in addons) {
      final orderId = addon["orderId"];
      if (!groupedAddons.containsKey(orderId)) {
        groupedAddons[orderId] = [];
      }
      groupedAddons[orderId]!.add(addon);
    }

    // Convert grouped items to a list
    List<Map<String, dynamic>> groupedList = groupedAddons.entries.map((entry) {
      final orderId = entry.key;
      final items = entry.value;

      final totalQuantity = items.fold<int>(
        0,
        (sum, item) => sum + ((item["quantity"] ?? 0) as int),
      );

      final totalPrice = items.fold<int>(
        0,
        (sum, item) =>
            sum +
            (((item["price"] ?? 0) as int) * ((item["quantity"] ?? 0) as int)),
      );
      final bookingStatus = items.first["bookingStatus"];
      log("booking sts---$bookingStatus");
      return {
        "orderId": orderId,
        "items": items,
        "mealType": items.first["mealType"],
        "totalQuantity": totalQuantity,
        "totalPrice": totalPrice,
        "bookingStatus": bookingStatus
      };
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigation(initialIndex: 1),
                  ));
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: groupedList.isEmpty
          ? Center(
              child: Text(
                "At this moment, no orders have been placed.",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
            )
          : Consumer<MessController>(
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: groupedList.length,
                    itemBuilder: (context, index) {
                      final group = groupedList[index];
                      final items =
                          group["items"] as List<Map<String, dynamic>>;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order ID: ${group["orderId"]}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Meal Type: ${group["mealType"]}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: ColorConstants.primary_black
                                            .withOpacity(.5)),
                                  ),
                                  SizedBox(height: 10),
                                  // List of items within this order

                                  Text(
                                    "Total Quantity: ${group["totalQuantity"]}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: ColorConstants.primary_black
                                            .withOpacity(.5)),
                                  ),
                                  SizedBox(height: 5),
                                  ...items.map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        "*  ${item["name"]} (x${item["quantity"]}) - ₹${(item["price"] ?? 0) * (item["quantity"] ?? 0)}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            // color: ColorConstants.dark_red
                                            //     .withOpacity(.7),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    );
                                  }).toList(),
                                  SizedBox(height: 10),
                                  Text(
                                    "Total Price: ₹${group["totalPrice"]}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: ColorConstants.dark_red),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  // log("booking status---${group["bookingStatus"]}");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QrcodePage(
                                        bookingStatus: group[
                                            "bookingStatus"], // Pass the booking status here
                                        foodItems: [],
                                        isAddons: true,
                                        bookingId: group["orderId"],
                                        mealType: group["mealType"],
                                        addonItems: items
                                            .map((item) => item["name"])
                                            .join(", "),
                                      ),
                                    ),
                                  );
                                },
                                child: QrImageView(
                                  data: "${group["orderId"]}",
                                  size: 60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
