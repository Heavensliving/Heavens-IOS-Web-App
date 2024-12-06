import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otherfunctions with ChangeNotifier {
  saveUserData(
    String accessToken,
    // String refreshToken,
    String studentId,
    String email,
    String name,
    String id,
    bool islogged,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    // await prefs.setString('refresh_token', refreshToken);
    await prefs.setString('studentId', studentId);
    await prefs.setString('id', id);
    await prefs.setString('email', email);

    await prefs.setString('email', email);
    await prefs.setString('name', name);
    await prefs.setBool('islogged', islogged);
    // await prefs.setString('percent', percent);

    log('Saved access_token: $accessToken');
    log('Saved student_id: $studentId');
    log('Saved email: $email');
    log('Saved name: $name');
    log('Is logged: $islogged');
    log('Saved id: $id');
    // log('profile compeletion percentage: $percent');
    notifyListeners();
  }

  saveStudentData(
    String name,
    String roomNo,
    String contactNo,
    String studentUniqueId,
    String propertyId,
    String contact,
    String percent,
    String pgName,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('roomNo', roomNo);
    await prefs.setString('studentUniqueId', studentUniqueId);
    await prefs.setString('propertyId', propertyId);
    await prefs.setString('contact', contact);
    await prefs.setString('profileCompletionPercentage', percent);
    await prefs.setString('pgName', pgName);

    log('Saved roomNo: $roomNo');
    log('Saved studentUniqueId: $studentUniqueId');
    log('Saved propertyId: $propertyId');
    log('Saved name: $name');

    notifyListeners();
  }
}
