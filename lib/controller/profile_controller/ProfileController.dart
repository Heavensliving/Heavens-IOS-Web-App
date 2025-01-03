import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/base_url.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController with ChangeNotifier {
  File? frontImage;
  File? backImage;
  File? profilePic;
  final ImagePicker _picker = ImagePicker();
  bool _isloading = false;
  bool get isLoading => _isloading;
  set isLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  addPersonalInformation(
      String? name,
      String? email,
      int? phone,
      String? dob,
      String? blood_group,
      String? address,
      String? percent,
      TabController tabController,
      BuildContext context) async {
    isLoading = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("access_token") ?? "";
      final id = prefs.getString("id") ?? "";
      // log("id---$id");
      // log("access token---$id");
      final url = '${UrlConst.baseUrl}/students/edit/$id';
      log(url);

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(dob.toString());
      Map data = {
        "name": name,
        "email": email,
        "contactNo": phone,
        "bloodGroup": blood_group,
        "dateOfBirth": parsedDate.toString(),
        "address": address,
        "profileCompletionPercentage": percent,
      };
      log("data----$data");
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      // log(response.body);

      if (response.statusCode == 200) {
        log("response of adding updating---${response.body}");
        log('Profile updated successfully');
        // context.watch<LoginController>().getStudentDetail(context);
        isLoading = false;
        tabController.animateTo(1);
      } else {
        log('Failed to update personal infromation: ${response.statusCode}');
      }
    } catch (e) {
      log('Error occurred: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

// add parent details
  addParentDetails(
    String? parent_name,
    int? parent_phn,
    String? occupation,
    String? percent,
    TabController tabController,
  ) async {
    isLoading = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("access_token") ?? "";
      final id = prefs.getString("id") ?? "";
      log("id---$id");

      final url = '${UrlConst.baseUrl}/students/edit/$id';
      log(url);

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> data = {
        "parentName": parent_name,
        "parentNumber": parent_phn,
        "parentOccupation": occupation,
        "profileCompletionPercentage": percent
      };
      log("data---$data");

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        log("Parent name----${jsonResponse["student"]["parentName"]}");
        log('Profile updated successfully');

        tabController.animateTo(2);
      } else {
        log('Failed to update profile: ${response.statusCode}');
        log('Error message: ${response.body}');
      }
    } catch (e) {
      log('Error occurred: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // general details
  Future<void> addGeneralDetails(
    String collage_name,
    String course,
    int? year,
    String? percent,
    BuildContext context,
    File? frontImage,
    File? backImage,
  ) async {
    isLoading = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("access_token") ?? "";
      final id = prefs.getString("id") ?? "";

      final url = '${UrlConst.baseUrl}/students/edit/$id';

      // Upload images and get their URLs
      String? frontImageUrl;
      String? backImageUrl;

      if (frontImage != null) {
        frontImageUrl = await uploadImageToFirebase(frontImage);
        log('Front Image URL: $frontImageUrl');
      }

      if (backImage != null) {
        backImageUrl = await uploadImageToFirebase(backImage);
        log('Back Image URL: $backImageUrl');
      }

      Map<String, dynamic> data = {
        "collegeName": collage_name,
        "course": course,
        "year": year,
        "profileCompletionPercentage": percent,
        "adharFrontImage": frontImageUrl,
        "adharBackImage": backImageUrl,
      };

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      log(response.body);

      if (response.statusCode == 200) {
        context.read<LoginController>().getStudentDetail(context);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => BottomNavigation(initialIndex: 4),
        //     ));

        log('Profile updated successfully');
        frontImage = null;
        backImage = null;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(initialIndex: 4),
          ),
        );
      } else {
        log('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      log('Error occurred: $e');
    } finally {
      isLoading = false;
    }
  }

  // Future<String?> uploadImageToFirebase(File imageFile) async {
  //   isLoading = true;
  //   try {
  //     final originalImage = img.decodeImage(await imageFile.readAsBytes());

  //     int quality = 100;
  //     List<int> compressedImageData =
  //         img.encodeJpg(originalImage!, quality: quality);

  //     while (compressedImageData.length > 400 * 1024) {
  //       quality -= 5;
  //       if (quality < 0) break;
  //       compressedImageData = img.encodeJpg(originalImage, quality: quality);
  //     }

  //     final compressedImageFile = File(
  //         '${imageFile.parent.path}/compressed_${imageFile.uri.pathSegments.last}');
  //     await compressedImageFile.writeAsBytes(compressedImageData);

  //     final storageRef = FirebaseStorage.instance.ref();
  //     String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //     final imageRef = storageRef.child(fileName);

  //     await imageRef.putFile(compressedImageFile);

  //     String downloadUrl = await imageRef.getDownloadURL();

  //     await compressedImageFile.delete();
  //     isLoading = false;
  //     notifyListeners();
  //     return downloadUrl;
  //   } catch (e) {
  //     isLoading = false;
  //     notifyListeners();
  //     print('Error uploading image: $e');
  //     return null;
  //   }
  // }
  Future<String?> uploadImageToFirebase(File imageFile) async {
    isLoading = true;
    try {
      // Read the image file as bytes directly without decoding or compressing
      final imageBytes = await imageFile.readAsBytes();

      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageRef = storageRef.child(fileName);

      // Upload the original image file directly
      await imageRef.putData(imageBytes);

      // Get the download URL for the uploaded image
      String downloadUrl = await imageRef.getDownloadURL();

      isLoading = false;
      notifyListeners();
      return downloadUrl;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      log('Error uploading image: $e');
      return null;
    }
  }

  Future showOptions(
    BuildContext context,
    bool isFrontImage,
  ) async {
    final result = await showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              'Photo Gallery',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onPressed: () async {
              Navigator.of(context).pop();

              await pickImage(ImageSource.gallery, isFrontImage);
              ;
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Camera',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onPressed: () async {
              Navigator.of(context).pop();

              await pickImage(ImageSource.camera, isFrontImage);
            },
          ),
        ],
      ),
    );
  }

  Future<void> pickImage(
    ImageSource source,
    bool isFrontImage,
  ) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      if (isFrontImage) {
        // if (kIsWeb) {
        //   frontImage = Image.network(pickedFile.path);
        // } else {
        //   frontImage = Image.file(File(pickedFile.path));
        // }
        frontImage = File(pickedFile.path);
      } else {
        backImage = File(pickedFile.path);
      }
      notifyListeners();
    }
  }

  // Future<void> pickImage(
  //   ImageSource source,
  //   bool isFrontImage,
  // ) async {
  //   final pickedFile = await _picker.pickImage(source: source);

  //   if (pickedFile != null) {
  //     if (kIsWeb) {

  //       final reader = html.FileReader();
  //       reader.readAsDataUrl(pickedFile);

  //       reader.onLoadEnd.listen((e) {
  //         final imageUrl = reader.result as String;

  //         if (isFrontImage) {
  //           frontImage = Image.network(imageUrl);
  //         } else {
  //           backImage = Image.network(imageUrl);
  //         }

  //         notifyListeners();
  //       });
  //     } else {
  //       if (isFrontImage) {
  //         frontImage = File(pickedFile.path);
  //       } else {
  //         backImage = File(pickedFile.path);
  //       }
  //       notifyListeners();
  //     }
  //   }
  // }

  logout() {
    frontImage = null;
    backImage = null;
    profilePic = null;
    notifyListeners();
  }
}
