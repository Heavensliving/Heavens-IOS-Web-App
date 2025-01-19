import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/mess_controller/MessController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/view/MessManager/AddOnPage/AddonPage.dart';
import 'package:heavens_students/view/MessManager/widgets/customMessMangerCard.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Messmanager extends StatefulWidget {
  const Messmanager({Key? key}) : super(key: key);

  @override
  State<Messmanager> createState() => _MessmanagerState();
}

class _MessmanagerState extends State<Messmanager> {
  final List<String> meals = ["Breakfast", "Lunch", "Dinner"];

  @override
  void initState() {
    super.initState();
    ini();
  }

  ini() async {
    final messController = context.read<MessController>();
    await messController.getMenuItems();
    messController.getAddOns();
    messController.getMessorderDetails();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final now = DateTime.now();
    final currentHour = now.hour;

    return currentHour >= 23 || currentHour < 4
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        "assets/images/cafe_closed.png",
                        height: screenHeight * 0.25,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Text(
                      "Our mess is unavailable!!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.0),
                    Text(
                      "from 11 PM to 4 AM.\nWe look forward to serving you shortly!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: ColorConstants.primary_black.withOpacity(.5),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.dark_red2,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth > 600 ? 18 : 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : DefaultTabController(
            initialIndex: 1,
            length: 3,
            child: Scaffold(
              backgroundColor: ColorConstants.primary_white.withOpacity(.8),
              appBar: AppBar(
                backgroundColor: ColorConstants.primary_white.withOpacity(.8),
                centerTitle: true,
                leading: SizedBox(),
                title: const Text(
                  "Mess Manager",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                bottom: TabBar(
                  indicatorColor: ColorConstants.dark_red2,
                  indicatorWeight: 3,
                  labelColor: ColorConstants.dark_red2,
                  unselectedLabelColor:
                      ColorConstants.primary_black.withOpacity(.5),
                  tabs: const [
                    Tab(text: "Yesterday"),
                    Tab(text: "Today"),
                    Tab(text: "Tomorrow"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  buildMealList(context, offsetDays: -1),
                  buildMealList(context, offsetDays: 0),
                  buildMealList(context, offsetDays: 1),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: ColorConstants.dark_red,
                child: const Icon(Icons.add,
                    size: 32, color: ColorConstants.primary_white),
                onPressed: () {
                  final messController = context.read<MessController>();
                  messController.addOns.clear();
                  messController.total.clear();
                  messController.cumulativeTotal = 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MealSelectionPage()),
                  );
                },
              ),
            ),
          );
  }

  Widget buildMealList(BuildContext context, {required int offsetDays}) {
    context.read<MessController>().getMessorderDetails();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
        itemCount: meals.length,
        separatorBuilder: (context, index) => const SizedBox(height: 5),
        itemBuilder: (context, index) {
          final mealType = meals[index];
          final date = DateTime.now().add(Duration(days: offsetDays));
          final formattedDate = DateFormat('MMM d, yyyy').format(date);
          final bool isYesterday = offsetDays == -1;

          return Consumer<MessController>(
            builder: (context, value, child) {
              final availabilityData =
                  value.getMealAvailability(formattedDate, mealType);
              log("available data===$availabilityData");
              final availability = availabilityData?["availability"];
              final orderId = availabilityData?["orderId"];
              final addons = availabilityData?["adOns"];
              final bookingStatus = availabilityData?["bookingStatus"];
              log("avaliabilty data---$availabilityData");
              log("Index $index - Availability: $availability, Order ID: $orderId, addons:$addons");
              log("statuss of mess=---$orderId");
              return CustomMessMangerCard(
                bookingStatus: bookingStatus,
                addOns: "true",
                itemIndex: index,
                Yesterday: isYesterday,
                button_text: isYesterday ? "Closed" : "Menu",
                date: formattedDate,
                meals: mealType,
                status: availability,
                orderId: orderId,
              );
            },
          );
        },
      ),
    );
  }
}
