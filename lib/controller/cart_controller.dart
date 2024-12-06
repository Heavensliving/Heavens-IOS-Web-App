import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/base_url.dart';
import 'package:heavens_students/view/cartpage/widgets/confirmOrder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartController with ChangeNotifier {
  List<Map<String, dynamic>> addOns = [];
  bool outStock = false;

// void submitOrder(BuildContext context, String itemName, int quantity,
//       String image, String prize, String id, int lowStock, int quantityStock) {
//     log("Quantity: $quantity");
//     bool itemExists = false;
//     int itemPrice = int.tryParse(prize) ?? 0;
//     if (quantity > quantityStock) {
//       outStock = true;
//       log("Cannot add more than available stock.");
//       return;
//     }

//     for (var addOn in addOns) {
//       if (addOn['id'] == id) {
//         if (quantity > 0) {
//           addOn['quantity'] = quantity;
//           addOn['total'] = itemPrice * quantity;
//           addOn['lowStock'] = lowStock - quantity;
//           addOn['quantityStock'] = quantityStock - quantity;
//         } else {
//           addOns.remove(addOn);
//           log("Removed $itemName from addOns because quantity is 0");
//         }
//         itemExists = true;
//         break;
//       }
//     }

//     if (!itemExists && quantity > 0) {
//       addOns.add({
//         "name": itemName,
//         "quantity": quantity,
//         "image": image,
//         "price": itemPrice,
//         "total": itemPrice * quantity,
//         "id": id,
//         "lowStock": lowStock - quantity,
//         "quantityStock": quantityStock - quantity,
//       });
//     }
//     log("adons--$addOns");
//     outStock = addOns.any((addOn) => addOn['quantityStock'] == 0);
//     calculateCumulativeTotal();
//   }

  void submitOrder(BuildContext context, String itemName, int quantity,
      String image, String prize, String id, int lowStock, int quantityStock) {
    log("Requested Quantity stock: $quantityStock");
    log("Requested Quantity: $quantity");
    int itemPrice = int.tryParse(prize) ?? 0;
    log("Item Price: $itemPrice");

    // Check if the requested quantity exceeds available stock
    // if ( 0==quantityStock && quantity > 0) {
    //   outStock = true;
    //   log("Cannot add more than available stock.");
    //   return;
    // }

    // Check if the item already exists in the cart
    bool itemExists = false;
    for (var addOn in addOns) {
      if (addOn['id'] == id) {
        itemExists = true;

        updateItemQuantity(addOn, quantity, itemPrice);
        break;
      }
    }

    // If the item does not exist and requested quantity is greater than zero, add it
    if (!itemExists && quantity > 0) {
      addOns.add({
        "name": itemName,
        "quantity": quantity,
        "image": image,
        "price": itemPrice,
        "total": itemPrice * quantity,
        "id": id,
        "lowStock": lowStock,
        "quantityStock":
            quantityStock - quantity, // Adjust stock for new addition
      });
      log("Added $itemName to addOns with quantity $quantity");
    }

    log("Current addOns: $addOns");

    // Update outOfStock status based on current addOns
    outStock = addOns.any((addOn) => addOn['quantityStock'] <= 0);

    calculateCumulativeTotal();

    notifyListeners();
  }

  void updateItemQuantity(
      Map<String, dynamic> addOn, int newQuantity, int itemPrice) {
    int previousQuantity = addOn['quantity'];

    // Handle case where item exists but stock is zero
    if (addOn['quantityStock'] <= 0) {
      if (newQuantity < previousQuantity) {
        // Decrease quantity
        int decreaseAmount = previousQuantity - newQuantity;

        // Update to new requested quantity
        addOn['quantity'] = newQuantity;
        addOn['total'] = itemPrice * newQuantity; // Update total price

        // Increase available stock back
        addOn['quantityStock'] += decreaseAmount;

        log("Updated ${addOn['name']} to quantity ${addOn['quantity']} (stock restored)");

        // If new quantity is zero or less, remove the item from the list
        if (newQuantity <= 0) {
          log("Removing ${addOn['name']} from addOns because quantity is now $newQuantity");
          addOns.remove(addOn);
        }
      } else {
        log("Cannot increase ${addOn['name']} as stock is zero.");
      }

      return; // Exit function after handling this case
    }

    // Normal increment/decrement logic when stock is available
    if (newQuantity > previousQuantity) {
      // Increase quantity by one
      addOn['quantity'] += 1;
      addOn['total'] = itemPrice * addOn['quantity']; // Update total price
      addOn['quantityStock'] -= 1; // Decrease available stock
      log("Updated ${addOn['name']} to quantity ${addOn['quantity']}");
    } else if (newQuantity < previousQuantity) {
      // Decrease quantity by one
      if (newQuantity > 0) {
        // Update to new requested quantity
        addOn['quantity'] = newQuantity;
        addOn['total'] = itemPrice * newQuantity; // Update total price
        addOn['quantityStock'] += 1; // Increase available stock back
        log("Updated ${addOn['name']} to quantity ${addOn['quantity']}");
      } else {
        // If new quantity is zero or less, remove the item from the list
        log("Removing ${addOn['name']} from addOns because quantity is now $newQuantity");

        // Increase stock when removing item from cart
        addOn['quantityStock'] +=
            previousQuantity; // Restore stock before removal

        addOns.remove(addOn);
      }
    }

    // Update outOfStock status after modifying quantities
    outStock = addOns.any((addOn) => addOn['quantityStock'] <= 0);
  }

  void removeItem(String id) {
    addOns.removeWhere((item) => item["id"] == id);
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // void submitOrder(BuildContext context, String itemName, int quantity,
  //     String image, String prize, String id, int lowStock, int quantityStock) {
  //   log("Quantity: $quantity");
  //   bool itemExists = false;
  //   int itemPrice = int.tryParse(prize) ?? 0;

  //   if (quantity > quantityStock) {
  //     outStock = true;
  //     log("Cannot add more than available stock.");
  //     return;
  //   }

  //   for (var addOn in addOns) {
  //     if (addOn['id'] == id) {
  //       if (quantity > 0) {
  //         addOn['quantity'] = quantity;
  //         addOn['total'] = itemPrice * quantity;
  //         addOn['lowStock'] = lowStock - quantity;
  //         addOn['quantityStock'] = quantityStock - quantity;
  //       } else {
  //         addOns.remove(addOn);
  //         log("Removed $itemName from addOns because quantity is 0");
  //       }
  //       itemExists = true;
  //       break;
  //     }
  //   }

  //   if (!itemExists && quantity > 0) {
  //     addOns.add({
  //       "name": itemName,
  //       "quantity": quantity,
  //       "image": image,
  //       "price": itemPrice,
  //       "total": itemPrice * quantity,
  //       "id": id,
  //       "lowStock": lowStock - quantity,
  //       "quantityStock": quantityStock - quantity,
  //     });
  //   }

  //   log("adons--$addOns");

  //   outStock = addOns.any((addOn) => addOn['quantityStock'] == 0);
  //   calculateCumulativeTotal();
  // }

  int cumulativeTotal = 0;

  void calculateCumulativeTotal() {
    cumulativeTotal = 0;
    for (var addOn in addOns) {
      int itemTotal = addOn['total'] as int? ?? 0;
      cumulativeTotal += itemTotal;
    }
    log("Cumulative total amount: $cumulativeTotal");
    notifyListeners();
  }

  // void adjustTotal(int adjustmentAmount) {
  //   cumulativeTotal += adjustmentAmount;
  //   log("Adjusted cumulative total: $cumulativeTotal");
  //   notifyListeners();
  // }

  var orderId = "";

  bool _isloading = false;
  bool get isLoading => _isloading;

  set isLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  bookOrder(List<Map<String, dynamic>> orders, BuildContext context) async {
    isLoading = true; // Start loading

    final url = '${UrlConst.baseUrl}/cafeOrder/occupant/add';
    log(url);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final pgName = prefs.getString("pgName") ?? "";
    final name = prefs.getString("name") ?? "";
    final roomNo = prefs.getString("roomNo") ?? "";
    final contact = prefs.getString("contact") ?? "";
    final studentId = prefs.getString("studentUniqueId") ?? "";

    Map<String, dynamic> data = {
      "occupant": studentId,
      "propertyName": pgName,
      "customerName": name,
      "roomNumber": roomNo,
      "contact": contact,
      "items": orders,
      "discount": 5,
      "paymentMethod": "cash",
    };

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    String body = jsonEncode(data);

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      log("Response Body of cafe order: ${response.body}");

      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        orderId = jsonResponse["order"]["orderId"];

        log("Order ID: $orderId");
        log("Request sent successfully.");

        // Await for Navigator.push to complete
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmAnimated(
                    isAddons: false,
                  )),
        );
      } else {
        log('Failed to load book order: ${response.statusCode}');
        log('Error Response Body of booking cafe item: ${response.body}');
      }
    } catch (e) {
      log('Error occurred while booking order: $e');
    } finally {
      // Ensure loading is set to false regardless of success or failure
      // addOns.clear();
      isLoading = false;
      log("Addons list cleared: $addOns");
      log("loading---$isLoading");
    }
  }
}
