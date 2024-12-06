import 'dart:convert';
import 'dart:developer';
import 'package:heavens_students/controller/other_functions/otherFunctions.dart';
import 'package:heavens_students/core/constants/base_url.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/model/student_detail_model.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController with ChangeNotifier {
  StudentDetailModel? studentDetailModel;
  // bool isLoading = false;
  bool _isloading = false;
  bool get isLoading => _isloading;
  set isLoading(bool value) {
    _isloading = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  var errorMessage = '';
  // login data
  Future<void> loginData(
      final String email, final String password, BuildContext context) async {
    isLoading = true;

    try {
      var login = Uri.parse("${UrlConst.baseUrl}/user/userLogin");

      Map<String, dynamic> data = {"email": email, "password": password};
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("access_token") ?? "";
      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      String body = jsonEncode(data);
      log("enters---1");
      log("body---$body");

      var response = await http.post(
        login,
        headers: headers,
        body: body,
      );

      log(response.body);

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        log("Response: ${response.body}");
        log("JSON message: ${jsonResponse["message"]}");

        var access_token = jsonResponse["token"];
        var name = jsonResponse["user"]["name"];
        var email = jsonResponse["user"]["email"];
        var studentId = jsonResponse["user"]["studentId"];
        var Id = jsonResponse["user"]["Id"];

        if (jsonResponse["message"] != "Invalid password") {
          await context
              .read<Otherfunctions>()
              .saveUserData(access_token, studentId, email, name, Id, true);
          getStudentDetail(context);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigation(initialIndex: 0),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 188, 50, 48),
            content: Text(
              jsonResponse["message"],
              style:
                  TextStyle(color: ColorConstants.primary_white, fontSize: 16),
            ),
          ),
        );
      }
    } catch (e) {
      log("Error occurred: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 188, 50, 48),
          content: Text(
            "An error occurred. Please try again later.",
            style: TextStyle(color: ColorConstants.primary_white, fontSize: 16),
          ),
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //get details

  getStudentDetail(BuildContext context) async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id") ?? "";
    final url = '${UrlConst.baseUrl}/students/$id';

    final accessToken = prefs.getString("access_token") ?? "";
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    log("Fetching data from URL: $url");

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // log(response.body);
        studentDetailModel = StudentDetailModel.fromJson(data);
        var student = studentDetailModel?.student;
        context.read<Otherfunctions>().saveStudentData(
            student?.name ?? "",
            student?.roomNo ?? "",
            student?.contactNo ?? "",
            student?.id ?? "",
            student?.propertyId ?? "",
            student?.contactNo ?? "",
            student?.profileCompletionPercentage ?? "",
            student?.pgName ?? "");
        log("student model----$studentDetailModel");
        log("Fetched student details successfully");
        log("Percent---${student?.profileCompletionPercentage ?? ""}");
      } else {
        // no internet screen
        // Navigator.pushReplacementNamed(context, "/nointernet");
        log('Failed to load student details: ${response.statusCode}');
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      log('Error occurred while fetching student details: $e');
    }
  }

  var error_message;
  forgotpsd(String email, BuildContext context) async {
    isLoading = true;

    final url = '${UrlConst.baseUrl}/user/forgot-password';
    log(url);

    Map<String, dynamic> data = {
      "email": email,
    };

    log("data--$data");

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      log("response----${response.body}");
      log("status of login-----${response.statusCode}");

      if (response.statusCode == 200) {
        log("it sends");
        await ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorConstants.primary_black.withOpacity(.3),
            content: Text("We've Successfully Sent You an Email!"),
          ),
        );
        Navigator.pushReplacementNamed(context, "/signin");
      } else {
        var jsonResponse = jsonDecode(response.body);
        error_message = jsonResponse["message"];
        log('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      log('Error occurred while sending forgot password request: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
