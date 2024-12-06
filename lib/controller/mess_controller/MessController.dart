import 'dart:convert';
import 'dart:developer';
import 'package:heavens_students/model/add_on_model.dart';
import 'package:heavens_students/model/menu_items_model.dart';
import 'package:heavens_students/model/mess_order_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/base_url.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessController with ChangeNotifier {
  List<MenuItemModel>? menuItemsModel;
  List<AddOnModel>? addOnModel;
  MessOrderModel? messOrderModel;
  int todaysIndex = 0;

  Future<void> getMenuItems() async {
    final url = '${UrlConst.baseUrl}/mess/getAllMeals';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        menuItemsModel = menuItemModelFromJson(response.body);
        log("response of getting list---${response.body}");
      } else {
        log('Failed to load menu items: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching menu items: $e');
    }

    notifyListeners();
  }

// find index

  findTodayIndex(final String day) {
    todaysIndex = -1;

    if (menuItemsModel == null || menuItemsModel!.isEmpty) return -1;

    for (int i = 0; i < menuItemsModel!.length; i++) {
      // log("dayname---$day");
      // log("data base day name---${menuItemsModel![i].dayOfWeek}");
      if (menuItemsModel![i].dayOfWeek == day) {
        todaysIndex = i;
        log("Found matching index: $todaysIndex for day: ${menuItemsModel![i].dayOfWeek}");
        break;
      }
      // log("Final index: $todaysIndex");
    }

    // notifyListeners();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   notifyListeners();
    // });

    return todaysIndex;
  }

  // Method to filter available items
  getAddOns() async {
    final url = '${UrlConst.baseUrl}/adOn';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    log(url);

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List<AddOnModel> fetchedAddOns = addOnModelFromJson(response.body);

      addOnModel =
          fetchedAddOns.where((addon) => addon.status == 'available').toList();

      log("Add-ons fetched successfully and filtered by availability.");
    } else {
      log('Failed to load add-ons: ${response.statusCode}');
    }
  }

  // getAddOns() async {
  //   //  isLoading = true;
  //   final url = '${UrlConst.baseUrl}/adOn';
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final accessToken = prefs.getString("access_token") ?? "";
  //   final headers = {
  //     'Authorization': 'Bearer $accessToken',
  //     'Content-Type': 'application/json',
  //   };
  //   log(url);
  //   final response = await http.get(Uri.parse(url), headers: headers);
  //   // log(response.body);
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);

  //     addOnModel = addOnModelFromJson(response.body);
  //     log("add on fetched sucessfully");
  //   } else {
  //     log('Failed to load courses: ${response.statusCode}');
  //   }
  //   // isLoading = false;
  // }

  // Add add-ones

  postAddOns(BuildContext context, String mealType, List addOns,
      String bookingStatus, String bookingDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString("name") ?? "";
    final roomno = prefs.getString("roomNo") ?? "";
    final studentId = prefs.getString("studentUniqueId") ?? "";
    final contactNo = prefs.getString("contact") ?? "";
    final propertyId = prefs.getString("propertyId") ?? "";
    final accessToken = prefs.getString("access_token") ?? "";
    final url = '${UrlConst.baseUrl}/messOrder/add';
    log(url);
    DateFormat inputFormat = DateFormat("MMM dd, yyyy");
    log("date time-- $bookingDate");
    DateTime dateTime = inputFormat.parse(bookingDate);

    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    String formattedDateString = outputFormat.format(dateTime);
    log("addons from --$addOns");
    Map<String, dynamic> data = {
      "name": name,
      "roomNo": roomno,
      "contact": contactNo,
      "mealType": mealType,
      "adOns": addOns,
      "property": propertyId,
      "student": studentId,
      "status": bookingStatus,
      "deliverDate": formattedDateString
    };
    log("deliver date---$formattedDateString");
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    String body = jsonEncode(data);
    log("body---$body");
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      log("response---${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        getMessorderDetails();
        log("addOns---${addOns}");
        log("Request successful");
        if (addOns.isEmpty && bookingStatus == "true") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Your ${mealType} booking is confirmed.",
              ),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        addOns.clear();
      } else {
        log('Failed to load courses: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      log('Error occurred: $e');
    } finally {
      notifyListeners();
    }
  }

  // submit order

  List addOns = [];

  void submitOrder(
    BuildContext context,
    String itemname,
    int quantity,
    String image,
    String id,
    String price,
  ) {
    log("quantity--$quantity");
    bool itemExists = false;

    for (var addOn in addOns) {
      if (addOn['id'] == id) {
        addOn['quantity'] = quantity;
        addOn['price'] = price;
        addOn['image'] = image;
        addOn['id'] = id;

        itemExists = true;

        if (quantity == 0) {
          addOns.remove(addOn);
          log("Removed $itemname from addOns because quantity is 0");
        }
        break;
      }
    }

    if (!itemExists && quantity > 0) {
      addOns.add({
        "name": itemname,
        "quantity": quantity,
        "price": price,
        "image": image,
        "id": id,
      });
    }

    log("Addons mess ---$addOns");
  }

// calculate total
  List<int> total = [];
  int cumulativeTotal = 0;

  void calculateTotal(int totalAmount) {
    if (total.isEmpty) {
      cumulativeTotal = totalAmount;
    } else {
      cumulativeTotal += totalAmount;
    }

    total.add(cumulativeTotal);

    log("Total amount list: $total");
    log("Cumulative total amount: $cumulativeTotal");

    notifyListeners();
  }

  void adjustTotal(int adjustmentAmount) {
    cumulativeTotal += adjustmentAmount;

    log(" $cumulativeTotal");

    notifyListeners();
  }

  List addOnListMess = [];
  // get mess order detail
  Future<void> getMessorderDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString("studentUniqueId") ?? "";
    final url = '${UrlConst.baseUrl}/messOrder/user/orders?student=$studentId';
    final accessToken = prefs.getString("access_token") ?? "";

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      messOrderModel = MessOrderModel.fromJson(data);
      log("Get mess order data fetched successfully");
      log("Get mess order data fetched successfully---${response.body}");
      addOnListMess = createTodaysAddOnList();
    } else {
      log('Failed to load Get mess order: ${response.statusCode}');
      throw Exception('Failed to load Get mess order');
    }

    notifyListeners();
  }

  Map<String, String>? getMealAvailability(String date, String mealType) {
    // getMessorderDetails();
    if (messOrderModel == null || messOrderModel!.studentOrders == null) {
      return null;
    }

    for (var order in messOrderModel!.studentOrders!) {
      String formattedOrderDate =
          DateFormat('MMM d, yyyy').format(order.deliverDate!);

      if (formattedOrderDate == date &&
          order.mealType == mealType &&
          order.adOns!.isEmpty) {
        String availability = order.status == "true" ? "Booked" : "Cancelled";
        return {
          "bookingStatus": order.bookingStatus ?? "",
          "availability": availability,
          "orderId": order.orderId ?? "",
          "addons": "true"
        };
      }
    }

    return null;
  }

  List<Map<String, dynamic>> createTodaysAddOnList() {
    List<Map<String, dynamic>> addOnList = [];

    if (messOrderModel?.studentOrders != null) {
      DateTime today = DateTime.now();
      for (var order in messOrderModel!.studentOrders!) {
        // Check if the deliverDate is today
        if (order.deliverDate != null && isSameDay(order.deliverDate!, today)) {
          if (order.adOns != null && order.adOns!.isNotEmpty) {
            for (var adOn in order.adOns!) {
              addOnList.add({
                'orderId': order.orderId,
                'mealType': order.mealType,
                'name': adOn.name,
                'quantity': adOn.quantity,
                'price': adOn.prize,
                'bookingStatus': order.bookingStatus
              });
            }
          }
        }
      }
    }
    log("Today's Add-ons: $addOnList");
    return addOnList;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
