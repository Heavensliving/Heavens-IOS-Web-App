import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heavens_students/controller/mess_controller/MessController.dart';
import 'package:heavens_students/core/widgets/CustomButton.dart';
import 'package:heavens_students/view/MessManager/order_details/OrderDetails.dart';
import 'package:heavens_students/view/cafe/widgets/verticalCard.dart';
import 'package:heavens_students/view/cartpage/widgets/confirmOrder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:heavens_students/core/constants/constants.dart';

class MealSelectionPage extends StatefulWidget {
  final String? selectedmeal;

  MealSelectionPage({Key? key, this.selectedmeal}) : super(key: key);

  @override
  _MealSelectionPageState createState() => _MealSelectionPageState();
}

class _MealSelectionPageState extends State<MealSelectionPage> {
  late String selectedMeal;

  @override
  void initState() {
    super.initState();
    context.read<MessController>().getAddOns();
    selectedMeal = widget.selectedmeal ?? "Breakfast";
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<MessController>();
    bool isselected = false;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.primary_white,
      appBar: AppBar(
        backgroundColor: ColorConstants.primary_white,
        title: Text(
          "Add ons",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetails(),
                  ));
            },
            child: Icon(
              Icons.shopping_bag,
              size: 27,
              color: ColorConstants.dark_red,
            ),
          ),
          SizedBox(
            width: 18,
          )
        ],
      ),
      body: provider.addOnModel!.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "Add-ons are currently unavailable. Please check back later.",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: ColorConstants.primary_black.withOpacity(.5)),
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.selectedmeal == null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Select add-on",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildMealContainer("Breakfast"),
                                      _buildMealContainer("Lunch"),
                                      _buildMealContainer("Dinner"),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              )
                            : SizedBox(
                                height: 1,
                              ),
                        // Filtering the list based on availability
                        GridView.builder(
                          itemCount: context
                                  .watch<MessController>()
                                  .addOnModel
                                  ?.length ??
                              0,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 5,
                            childAspectRatio: 0.63,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var provider = context.watch<MessController>();
                            var currentItem = provider.addOnModel?[index];

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorConstants.dark_red.withOpacity(.1),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: VerticalCard(
                                lowsctock: 5,
                                quantity: 10,
                                id: currentItem?.id ?? "",
                                isCafe: false,
                                description: currentItem?.description ?? "",
                                image: currentItem?.image ?? "",
                                name: currentItem?.itemname ?? "",
                                price: "${currentItem?.prize ?? 0}",
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Amount to be paid:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            Text(
                              "\₹ ${provider.cumulativeTotal}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () async {
                            if (provider.addOns.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  margin: EdgeInsets.only(
                                      bottom: 75, right: 10, left: 10),
                                  content: Text(
                                    "Select addons",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  backgroundColor: ColorConstants.primary_black
                                      .withOpacity(.5),
                                  duration: Duration(seconds: 3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              showConfirmOrderDialog(
                                  context, provider.addOns, selectedMeal);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.025, vertical: 5),
                            decoration: BoxDecoration(
                              color: ColorConstants.dark_red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Book Meal",
                                style: TextStyle(
                                  color: ColorConstants.primary_white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildMealContainer(String mealType) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMeal = mealType;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selectedMeal == mealType
              ? ColorConstants.dark_red
              : ColorConstants.dark_red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          mealType,
          style: TextStyle(
            color: selectedMeal == mealType
                ? ColorConstants.primary_white
                : ColorConstants.primary_black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void showConfirmOrderDialog(
      BuildContext context, List foodItems, String mealType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Order"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Highlight meal type
            Text(
              'Meal Type: $mealType',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mealType == 'Veg' ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 10),

            // List of food items
            Text(
              'Food Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            for (var item in foodItems)
              Text(
                '- ${item["name"]} (${item["quantity"]})',
                style: TextStyle(fontSize: 14),
              ),
            SizedBox(height: 20),
          ],
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Custombutton(
                  onTap: () async {
                    var provider = context.read<MessController>();

                    final formattedDate =
                        DateFormat('MMM d, yyyy').format(DateTime.now());

                    await provider.postAddOns(context, selectedMeal,
                        provider.addOns, "true", "$formattedDate");
                    log("addonss--------${provider.addOns}");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmAnimated(
                          isAddons: true,
                        ),
                      ),
                    );

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text("Order Confirmed")),
                    // );
                  },
                  text: "Confirm Order", // Corrected typo here
                  fontSize: 17,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog on cancel
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
