import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/base_url.dart';
import 'package:heavens_students/model/carosual_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CarousalImageController with ChangeNotifier {
  List<CarousalModel>? carousalModels;
  bool isLoading = false;

  getCarousalImages() async {
    isLoading = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("access_token") ?? "";
      final id = prefs.getString("id") ?? "";

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      final url = '${UrlConst.baseUrl}/carousal';
      log(url);
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        log("Response body of carousal images ------ ${response.body}");

        final data = json.decode(response.body);

        // Check if data is a List and parse it
        if (data is List) {
          carousalModels = CarousalModel.fromJsonList(data);
        } else {
          log('Expected a list but got something else');
        }
      } else {
        log('Failed to load carousal images: ${response.statusCode}');
      }
    } catch (e) {
      log('Error occurred: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Notify listeners regardless of success or failure
    }
  }
}
