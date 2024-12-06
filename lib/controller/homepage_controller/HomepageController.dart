import 'dart:convert';
import 'dart:developer';
import 'package:heavens_students/core/widgets/customSnackbar.dart';
import 'package:heavens_students/model/fees_model.dart';
import 'package:heavens_students/model/raised_ticket_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/base_url.dart';
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
}
