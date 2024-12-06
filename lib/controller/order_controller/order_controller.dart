import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/base_url.dart';
import 'package:heavens_students/model/OrderHistoryModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderController with ChangeNotifier {
  bool _isloading = false;
  bool get isLoading => _isloading;
  set isLoading(bool value) {
    _isloading = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  OrderHistoryModel? orderHistoryModel;
  List<CafeOrder> deliveredOrders = [];
  List<CafeOrder> pendingOrders = [];

  getOrderHistory() async {
    isLoading = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final id = prefs.getString("studentUniqueId") ?? "";
    final url = '${UrlConst.baseUrl}/cafeOrder/orderHistory/$id';
    log(url);

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      orderHistoryModel = OrderHistoryModel.fromJson(data);
      // log("Response of cart: ${response.body}");

      deliveredOrders = orderHistoryModel?.cafeOrders?.where((order) {
            return order.status?.toLowerCase() == 'delivered' ||
                order.status?.toLowerCase() == 'cancelled';
          }).toList() ??
          [];

      // Filter pending and ongoing orders
      pendingOrders = orderHistoryModel?.cafeOrders?.where((order) {
            return order.status?.toLowerCase() == 'pending' ||
                order.status?.toLowerCase() == 'ongoing';
          }).toList() ??
          [];

      // log("Delivered orders: $deliveredOrders");
      // log("Pending orders: $pendingOrders");
    } else {
      log('Failed to load orders: ${response.statusCode}');
    }

    isLoading = false;
    notifyListeners();
  }
}
