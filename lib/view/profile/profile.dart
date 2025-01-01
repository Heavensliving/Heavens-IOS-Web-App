import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/profile_controller/ProfileController.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/controller/profile_controller/profilePic_controller.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/view/profile/widgets/ProfileCard.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  String? name;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? "";
      email = prefs.getString("email") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    var picController = context.watch<PicController>();
    var loginController = context.watch<LoginController>();
    var student = loginController.studentDetailModel?.student;

    log("Profile pic from PicController: ${picController.profilePic}");

    return Scaffold(
      backgroundColor: ColorConstants.primary_white,
      appBar: AppBar(
        leading: SizedBox(),
        backgroundColor: ColorConstants.primary_white,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              buildProfileHeader(picController, student),
              const SizedBox(height: 25),
              ...buildProfileCards(context),
              buildLogoutCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileHeader(PicController picController, dynamic student) {
    log(" name -----${student?.name ?? name ?? ""}");
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(.2),
              backgroundImage: _getProfileImage(
                student?.photo,
                picController.profilePic,
              ),
              radius: 35,
              child: picController.isLoading
                  ? const CircularProgressIndicator(
                      color: ColorConstants.primary_white,
                    )
                  : const SizedBox(),
            ),
            Positioned(
              right: 0,
              bottom: 1,
              child: InkWell(
                onTap: () {
                  picController.showOptions2(context, true);
                },
                child: const CircleAvatar(
                  radius: 14,
                  child: Icon(
                    Icons.edit,
                    size: 17,
                    color: ColorConstants.primary_white,
                  ),
                  backgroundColor: ColorConstants.dark_red2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              overflow: TextOverflow.ellipsis, maxLines: 1,
              "${student.name ?? name ?? ""}",
              // "sxnjs",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            // SizedBox(
            //   height: 100,
            // ),
            Text(
              student?.email ?? email ?? "",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: ColorConstants.primary_black.withOpacity(.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ImageProvider _getProfileImage(String? photoUrl, dynamic localPic) {
    if ((photoUrl == null || photoUrl.isEmpty) && localPic == null) {
      return const NetworkImage(
        "https://example.com/default-profile-pic.png",
      );
    } else {}
    return localPic != null
        ? FileImage(localPic)
        : NetworkImage(photoUrl ?? "");
  }

  List<Widget> buildProfileCards(BuildContext context) {
    return [
      buildProfileCard(
        context,
        "Personal Information",
        Icons.person_2_outlined,
        "/personal_information",
      ),
      buildProfileCard(
        context,
        "Stay Details",
        Icons.speaker_notes_outlined,
        "/stay_detail",
      ),
      // buildProfileCard(
      //   context,
      //   "Community Chat",
      //   Icons.person_2_outlined,
      //   null,
      // ),
      // buildProfileCard(
      //   context,
      //   "Language",
      //   Icons.language_outlined,
      //   null,
      //   isLangCard: true,
      // ),
      // buildProfileCard(
      //   context,
      //   "Change Password",
      //   Icons.lock_outline,
      //   "/change_password",
      // ),
      // buildProfileCard(
      //   context,
      //   "FAQ",
      //   Icons.help_center_outlined,
      //   "/faq",
      // ),
      buildProfileCard(
        context,
        "Terms & Conditions",
        Icons.description,
        "/terms",
      ),
    ];
  }

  Widget buildProfileCard(
    BuildContext context,
    String data,
    IconData icon,
    String? routeName, {
    bool isLangCard = false,
  }) {
    return Column(
      children: [
        ProfileCards(
          onTap: routeName != null
              ? () {
                  return Navigator.pushNamed(context, routeName);
                }
              : null,
          data: data,
          icon: icon,
          lang: isLangCard,
        ),
        Divider(color: ColorConstants.primary_black.withOpacity(.1)),
      ],
    );
  }

  Widget buildLogoutCard(BuildContext context) {
    return Column(
      children: [
        ProfileCards(
          isLogout: true,
          onTap: () async {
            showLogOut(context);
          },
          data: "Logout",
          icon: Icons.logout_outlined,
        ),
        Divider(color: ColorConstants.primary_black.withOpacity(.1)),
      ],
    );
  }

  Future<void> showLogOut(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 8),
            Text(
              "Logout",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              elevation: 0,
            ),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              await context.read<ProfileController>().logout();
              context.read<PicController>().profilePic = null;

              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/signin', (Route<dynamic> route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
