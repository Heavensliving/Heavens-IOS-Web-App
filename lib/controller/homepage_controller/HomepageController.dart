import 'dart:convert';
import 'dart:developer';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/core/widgets/customSnackbar.dart';
import 'package:heavens_students/model/fees_model.dart';
import 'package:heavens_students/model/raised_ticket_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/base_url.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomepageController with ChangeNotifier {
  bool isLoading = false;
  List<RaisedTicketModel>? raisedTicketModels;
  List<FeesModel>? feesModel;
  bool nothing = false;
  raiseIssue(String issue, String description, String studentId,
      String properyId, BuildContext context) async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final name = prefs.getString("name") ?? "";
    final roomno = prefs.getString("roomNo") ?? "";
    final url = '${UrlConst.baseUrl}/maintenance/add';
    log(url);

    Map<String, dynamic> data = {
      "Name": name,
      "issue": issue,
      "description": description,
      "roomNo": roomno,
      "studentId": studentId,
      "propertyId": properyId
    };

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    String body = jsonEncode(data);
    log("body---$body");

    final response =
        await http.post(Uri.parse(url), body: body, headers: headers);
    log("response----${response.body}");
    log("status---${response.statusCode}");

    if (response.statusCode == 200) {
      log('Issue raised successfully');
      showCustomSnackbar(context, "Issue raised successfully");
      Navigator.pop(context);
    } else {
      if (response.statusCode == 404) {}
      showCustomSnackbar(
          context, "Oops! Something Went Wrong. Please Try Again.");
      log('Failed to raise issue: ${response.statusCode}');
      log('Response body: ${response.body}');
    }

    isLoading = false;
    notifyListeners();
  }

  getRaisedTickets() async {
    isLoading = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final studentId = prefs.getString("id") ?? "";
    final url = '${UrlConst.baseUrl}/maintenance/student/$studentId';
    log(url);
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    // log("response---${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body); // Decode as List
      raisedTicketModels =
          data.map((item) => RaisedTicketModel.fromJson(item)).toList();
      log("Successfully fetched raised tickets.");
      nothing = false;
    } else {
      nothing = true;
      log('Failed to load courses: ${response.statusCode}');
    }

    isLoading = false;
    notifyListeners(); // Notify listeners after loading is complete
  }
  // get fees details

  getFeesDetails() async {
    isLoading = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final id = prefs.getString("id") ?? "";

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final url = '${UrlConst.baseUrl}/fee/$id';
    log("fetch payment details url---$url");
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      log("response body in fees ------${response.body}");
      final data = json.decode(response.body);
      feesModel =
          (data as List).map((item) => FeesModel.fromJson(item)).toList();
    } else {
      log('Failed to load payment details: ${response.statusCode}');
      feesModel = null;
    }
    isLoading = false;
  }

  // notification

  final List<NotificationItem> notifications = [];
  DateTime? paymentPendingDate;

  checkPaymentStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('paymentPendingDate');
    log("payment pending date ---$savedDate");
    var loginController = context.read<LoginController>();
    var paymentStatus =
        loginController.studentDetailModel?.student?.paymentStatus;
    log("Payment status: $paymentStatus");

    if (paymentStatus == "Pending") {
      if (savedDate == null) {
        await _savePaymentPendingDate();
      }

      await _loadPaymentPendingDate();
      generateNotifications();
    } else {
      await _clearPaymentPendingDate();
    }
    notifyListeners();
  }

  Future<void> _savePaymentPendingDate() async {
    final prefs = await SharedPreferences.getInstance();

    if (paymentPendingDate == null) {
      paymentPendingDate = DateTime.now();
      await prefs.setString(
          'paymentPendingDate', paymentPendingDate!.toIso8601String());
      log("Payment pending date saved: $paymentPendingDate");
    }
  }

  Future<void> _loadPaymentPendingDate() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('paymentPendingDate');
    if (savedDate != null) {
      log("Saved date---$savedDate");
      paymentPendingDate = DateTime.parse(savedDate);
      log("Payment pending date loaded: $paymentPendingDate");
    } else {
      log("No payment pending date found in local storage.");
    }
  }

  Future<void> _clearPaymentPendingDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('paymentPendingDate');
    paymentPendingDate = null;
    notifications
        .clear(); // Clear notifications if payment is no longer pending
    log("Payment pending date cleared from local storage.");
  }

  generateNotifications() {
    if (paymentPendingDate != null) {
      DateTime now = DateTime.now();
      Duration difference = now.difference(paymentPendingDate!);
      log("Difference in days: ${difference.inDays}");
      log("Payment pending date: $paymentPendingDate");

      notifications.clear();

      notifications.add(NotificationItem(
        title: "Payment Pending",
        description: "Your payment is pending. Please complete it soon.",
      ));

      if (difference.inDays > 3) {
        notifications.add(NotificationItem(
          title: "Reminder",
          description: "Complete your payment soon.",
        ));
      }

      if (difference.inDays >= 6) {
        notifications.add(NotificationItem(
          title: "Urgent Reminder",
          description:
              "Tomorrow your account access will be blocked. Make the payment as soon as possible.",
        ));
      }

      log("Notifications generated: ${notifications.length}");
    }
  }
}

class NotificationItem {
  final String title;
  final String description;

  NotificationItem({required this.title, required this.description});
}
