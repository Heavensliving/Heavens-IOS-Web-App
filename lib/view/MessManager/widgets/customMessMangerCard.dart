import 'package:flutter/material.dart';
import 'package:heavens_students/model/menu_items_model.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:heavens_students/controller/mess_controller/MessController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/widgets/CustomButton.dart';
import 'package:heavens_students/view/MessManager/widgets/QRcode_page.dart';

class CustomMessMangerCard extends StatefulWidget {
  final String meals;
  final int itemIndex;
  final String date;
  final String button_text;
  final bool Yesterday;
  final String? status;
  final String? orderId;
  final String? addOns;
  final String? bookingStatus;

  const CustomMessMangerCard({
    Key? key,
    required this.meals,
    required this.date,
    required this.button_text,
    required this.Yesterday,
    required this.itemIndex,
    this.status,
    this.orderId,
    this.addOns,
    this.bookingStatus,
  }) : super(key: key);

  @override
  State<CustomMessMangerCard> createState() => _CustomMessMangerCardState();
}

class _CustomMessMangerCardState extends State<CustomMessMangerCard> {
  bool isExpandable = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MessController>();
    final today = DateFormat('MMM d, yyyy').format(DateTime.now());

    return Card(
      color: ColorConstants.primary_white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with meals and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.meals,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.date,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: ColorConstants.primary_black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                // Status and actions
                if (!widget.Yesterday)
                  widget.date == today
                      ? buildTodayStatus(context)
                      : buildFutureStatus(context, provider),
              ],
            ),
            const SizedBox(height: 20),

            Custombutton(
              onTap: () {
                setState(() {
                  if (widget.Yesterday) {
                    isExpandable = false;
                  } else {
                    isExpandable = !isExpandable;
                  }
                });
              },
              text: widget.button_text,
              padding: const EdgeInsets.symmetric(vertical: 3),
            ),

            if (isExpandable) buildExpandableMenu(provider),
          ],
        ),
      ),
    );
  }

  Widget buildTodayStatus(BuildContext context) {
    if (widget.status == "Booked") {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                final selectedDate =
                    DateFormat('MMM d, yyyy').parse(widget.date);
                final selectedDayOfWeek =
                    DateFormat('EEEE').format(selectedDate);
                var provider = context.watch<MessController>();

                final dayMenu = provider.menuItemsModel?.firstWhere(
                  (menu) => menu.dayOfWeek == selectedDayOfWeek,
                  orElse: () => MenuItemModel(
                      dayOfWeek: selectedDayOfWeek,
                      breakfast: [],
                      lunch: [],
                      dinner: []),
                );

                final menuItems = widget.meals == "Breakfast"
                    ? dayMenu?.breakfast ?? []
                    : widget.meals == "Lunch"
                        ? dayMenu?.lunch ?? []
                        : dayMenu?.dinner ?? [];

                // log("add on list mess manager---$addOnList");
                return QrcodePage(
                  bookingStatus: widget.bookingStatus ?? "",
                  isAddons: false,
                  bookingId: widget.orderId ?? "",
                  foodItems: menuItems,
                  mealType: widget.meals,
                );
              },
            ),
          );
        },
        child: QrImageView(
          data: widget.orderId ?? "",
          size: 50,
        ),
      );
    } else {
      return Text(
        "Cancelled",
        style: TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.red,
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }

  Widget buildFutureStatus(BuildContext context, MessController provider) {
    if (widget.status == null) {
      return Row(
        children: [
          InkWell(
            onTap: () {
              provider.postAddOns(
                context,
                widget.meals,
                [],
                "false",
                widget.date,
              );
              provider.getMealAvailability(widget.date, widget.meals);
            },
            child: const CircleAvatar(
              radius: 21,
              backgroundColor: Colors.red,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          InkWell(
            onTap: () {
              // showDialog(
              //   context: context,
              //   builder: (context) => AlertDialog(
              //     title: Text("Confrim"),
              //     content: Text("Are you sure you want to delete this order?"),
              //     actions: [
              //       TextButton(
              //         onPressed: () {
              //           // Navigator.of(context).pop();
              //         },
              //         child: Text("Cancel"),
              //       ),
              //       TextButton(
              //         onPressed: () {
              //           // Navigator.of(context).pop();
              //           // ScaffoldMessenger.of(context)
              //           //     .showSnackBar(
              //           //   SnackBar(
              //           //       content: Text(
              //           //           "deleted")),
              //           // );
              //         },
              //         child: Text("Delete"),
              //       ),
              //     ],
              //   ),
              // );
              provider.postAddOns(
                context,
                widget.meals,
                [],
                "true",
                widget.date,
              );
              provider.getMealAvailability(widget.date, widget.meals);
              provider.total.clear();
              provider.cumulativeTotal = 0;
            },
            child: const CircleAvatar(
              radius: 21,
              backgroundColor: Colors.green,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (widget.status == "Booked" && widget.addOns == "true") {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                final selectedDate =
                    DateFormat('MMM d, yyyy').parse(widget.date);
                final selectedDayOfWeek =
                    DateFormat('EEEE').format(selectedDate);

                final dayMenu = provider.menuItemsModel?.firstWhere(
                  (menu) => menu.dayOfWeek == selectedDayOfWeek,
                  orElse: () => MenuItemModel(
                      dayOfWeek: selectedDayOfWeek,
                      breakfast: [],
                      lunch: [],
                      dinner: []),
                );

                final menuItems = widget.meals == "Breakfast"
                    ? dayMenu?.breakfast ?? []
                    : widget.meals == "Lunch"
                        ? dayMenu?.lunch ?? []
                        : dayMenu?.dinner ?? [];
                return QrcodePage(
                  bookingStatus: widget.bookingStatus ?? "",
                  isAddons: false,
                  bookingId: widget.orderId ?? "",
                  foodItems: menuItems,
                  mealType: widget.meals,
                );
              },
            ),
          );
        },
        child: QrImageView(
          data: widget.orderId ?? "",
          size: 50,
        ),
      );
    } else {
      return const Text(
        "Cancelled",
        style: TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.red,
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }

  Widget buildExpandableMenu(MessController provider) {
    final selectedDate = DateFormat('MMM d, yyyy').parse(widget.date);
    final selectedDayOfWeek = DateFormat('EEEE').format(selectedDate);

    final dayMenu = provider.menuItemsModel?.firstWhere(
      (menu) => menu.dayOfWeek == selectedDayOfWeek,
      orElse: () => MenuItemModel(
          dayOfWeek: selectedDayOfWeek, breakfast: [], lunch: [], dinner: []),
    );

    final menuItems = widget.meals == "Breakfast"
        ? dayMenu?.breakfast ?? []
        : widget.meals == "Lunch"
            ? dayMenu?.lunch ?? []
            : dayMenu?.dinner ?? [];

    final noItemsAvailable = menuItems.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Menu Items",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 5),
        if (noItemsAvailable)
          Text(
            "No items available",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
              color: ColorConstants.primary_black.withOpacity(0.5),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Text(
              "- ${menuItems[index]}",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                color: ColorConstants.primary_black.withOpacity(0.5),
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: menuItems.length,
          ),
      ],
    );
  }
}
