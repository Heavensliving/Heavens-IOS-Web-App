import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:http/http.dart' as http;
import 'package:heavens_students/core/constants/base_url.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicController extends ChangeNotifier {
  File? profilePic;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  updateProfilePic(File profilePic, BuildContext context,
      String profileCompletionPercentage) async {
    isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("access_token") ?? "";
      final id = prefs.getString("id") ?? "";
      log("id---$id");

      String? frontImageUrl;
      frontImageUrl = await uploadImageToFirebase(profilePic);
      log('Front Image URL: $frontImageUrl');

      final url = '${UrlConst.baseUrl}/students/edit/$id';
      log(url);

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> data = {
        "photo": frontImageUrl,
        "profileCompletionPercentage": profileCompletionPercentage
      };

      log("data---$data");

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        log('Profile updated successfully');
        this.profilePic = profilePic;
        log("response of profile----${response.body}");
        notifyListeners();
      } else {
        log('Failed to update profile: ${response.statusCode}');
        log('Error message: ${response.body}');
      }
    } catch (e) {
      log('Error occurred: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Ensure loading state is updated
    }
  }

  Future<void> showOptions2(BuildContext context, bool isFrontImage) async {
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
              await pickImage2(ImageSource.gallery, context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Camera',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await pickImage2(ImageSource.camera, context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> pickImage2(ImageSource source, BuildContext context) async {
    var login_controller =
        context.read<LoginController>().studentDetailModel?.student;
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      profilePic = File(pickedFile.path);
      if (login_controller?.profileCompletionPercentage != null) {
        int profileCompletion =
            int.parse(login_controller!.profileCompletionPercentage!);

        if (profileCompletion == 90) {
          await updateProfilePic(profilePic!, context, "100");
        } else if (profileCompletion == 10 || profileCompletion == 20) {
          await updateProfilePic(profilePic!, context, "20");
        } else if (profileCompletion == 100) {
          await updateProfilePic(profilePic!, context, "100");
        } else if (profileCompletion > 10 && profileCompletion < 90) {
          int newProfileCompletion = profileCompletion + 10;
          await updateProfilePic(
              profilePic!, context, newProfileCompletion.toString());
        }
      }
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();

      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageRef = storageRef.child(fileName);

      await imageRef.putFile(imageFile);

      String downloadUrl = await imageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
