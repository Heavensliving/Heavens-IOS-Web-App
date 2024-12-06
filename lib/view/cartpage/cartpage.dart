import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/cart_controller.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/widgets/CustomButton.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';
import 'package:heavens_students/view/cartpage/widgets/cartcard.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isCashOnDeliverySelected = false;

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CartController>();
    var student = context.watch<LoginController>().studentDetailModel?.student;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigation(initialIndex: 2),
              ),
            );
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Order Summary",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: provider.addOns.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You haven’t made any \norders",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Text(
                    "Order is empty. You can make orders from the home screen.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConstants.primary_black.withOpacity(.7),
                    ),
                  ),
                  SizedBox(height: 100),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BottomNavigation(initialIndex: 2),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: ColorConstants.dark_red2,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Try Ordering",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // log("length---${provider.addOns.length}");
                            final addon = provider.addOns[index];
                            return CartCard(
                              lowSctock: addon["lowStock"],
                              quantity: addon["quantityStock"],
                              id: addon["id"] ?? "",
                              itemName: addon['name'] ?? '',
                              itemCount: addon['quantity']?.toString() ?? '1',
                              image: addon['image'] ?? '',
                              pricePerItem: addon['price'].toString(),
                            );
                          },
                          childCount: provider.addOns.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                "Deliver To",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                color: Colors.grey.withOpacity(.2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student?.name ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            color: ColorConstants.dark_red),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            [
                                              if (student?.address != null &&
                                                  student!.address!.isNotEmpty)
                                                student.address,
                                              if (student?.roomNo != null &&
                                                  student!.roomNo!.isNotEmpty)
                                                "Room No: ${student.roomNo}",
                                              if (student?.pgName != null &&
                                                  student!.pgName!.isNotEmpty)
                                                "Property: ${student.pgName}",
                                            ].join(",\n"),
                                            style: TextStyle(
                                              color: ColorConstants
                                                  .primary_black
                                                  .withOpacity(.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.phone,
                                            color: ColorConstants.dark_red),
                                        SizedBox(width: 10),
                                        Text(
                                          student?.contactNo ?? "",
                                          style: TextStyle(
                                              color: ColorConstants
                                                  .primary_black
                                                  .withOpacity(.5)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Payment method",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    activeColor: ColorConstants.dark_red,
                                    value: isCashOnDeliverySelected,
                                    onChanged: (value) {
                                      setState(() {
                                        isCashOnDeliverySelected = value!;
                                      });
                                    },
                                  ),
                                  Text("Cash on Delivery",
                                      style: TextStyle(
                                          color: ColorConstants.primary_black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                color: Colors.grey.withOpacity(.2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Price Details",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Price (${provider.addOns.length} items)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          "₹ ${provider.cumulativeTotal}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Delivery charges",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              " FREE Delivery",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total Amount",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          "₹ ${provider.cumulativeTotal}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: .5,
                      color: ColorConstants.primary_black.withOpacity(.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "₹ ${provider.cumulativeTotal}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.error_outline,
                                size: 15,
                                color: ColorConstants.primary_black
                                    .withOpacity(.3),
                              )
                            ],
                          ),
                          Consumer<CartController>(
                            builder: (context, value, child) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 6),
                              child: Custombutton(
                                  child: value.isLoading
                                      ? CircularProgressIndicator(
                                          color: ColorConstants.primary_white,
                                        )
                                      : Text(
                                          "Place Order",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorConstants.primary_white,
                                              fontSize: 18),
                                        ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 15),
                                  text: "Place Order",
                                  fontSize: 17,
                                  onTap: () {
                                    if (isCashOnDeliverySelected) {
                                      List<Map<String, dynamic>>
                                          transformedList =
                                          provider.addOns.map((item) {
                                        return {
                                          'id': item['id'],
                                          'itemName': item['name'],
                                          'quantity': item['quantity']
                                        };
                                      }).toList();

                                      log("transformed list--$transformedList");

                                      provider.bookOrder(
                                          transformedList, context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          margin: EdgeInsets.only(
                                              bottom: 70, left: 15, right: 15),
                                          content: Text(
                                            "Choose Your Payment Option",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          backgroundColor: ColorConstants
                                              .primary_black
                                              .withOpacity(0.5),
                                          duration: Duration(seconds: 3),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          // margin: EdgeInsets.all(10),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
