import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/controller/profile_controller/ProfileController.dart';
import 'package:heavens_students/controller/profile_controller/profilePic_controller.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/widgets/CustomButton.dart';
import 'package:heavens_students/core/widgets/CustomTextformField.dart';
import 'package:heavens_students/view/profile/widgets/fullScreenImageWidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PersonalInformationCard extends StatefulWidget {
  final TabController? tabController;
  const PersonalInformationCard({super.key, this.tabController});

  @override
  State<PersonalInformationCard> createState() =>
      _PersonalInformationCardState();
}

class _PersonalInformationCardState extends State<PersonalInformationCard> {
  TextEditingController name_controller = TextEditingController();
  TextEditingController phone_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController dob_controller = TextEditingController();
  TextEditingController blood_controller = TextEditingController();
  TextEditingController address_controller = TextEditingController();
  late LoginController loginController;

  final formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init();
  }

  // @override
  // void initState() {
  //   init();
  //   super.initState();
  // }

  init() async {
    var provider = context.watch<LoginController>();

    var prov = provider.studentDetailModel?.student;

    log("date---${prov?.dateOfBirth}");

    String dateString = prov?.dateOfBirth ?? "";
    if (dateString.isNotEmpty) {
      DateTime dateTime = DateTime.parse(dateString);
      String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
      dob_controller.text = formattedDate;
    } else {
      dob_controller.text = "";
    }

    name_controller.text = prov?.name ?? "";
    email_controller.text = prov?.email ?? "";
    phone_controller.text = prov?.contactNo ?? "";
    blood_controller.text = prov?.bloodGroup ?? "";
    log("dob of profile--${prov?.dateOfBirth ?? ""}");
    log("blood group--${prov?.bloodGroup ?? ""}");
    address_controller.text = prov?.address ?? "";
  }

  @override
  Widget build(BuildContext context) {
    var picController = context.watch<PicController>();
    var provider = context.read<ProfileController>();
    var login_controller =
        context.watch<LoginController>().studentDetailModel?.student;
    log("percent in profile1---${login_controller!.profileCompletionPercentage}");
    var loginControllers = context.watch<LoginController>();
    var student = loginControllers.studentDetailModel?.student;
    return Scaffold(
      backgroundColor: ColorConstants.primary_white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.tabController == null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .23,
                          ),
                          Text(
                            "Edit Profile",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .08,
                      ),
                    ],
                  ),
                SizedBox(height: 20),

                Center(
                  child: Stack(
                    children: [
                      InkWell(
                        hoverColor: Colors.transparent,
                        onTap: student?.photo == null || student?.photo == ""
                            ? null
                            : () {
                                FullScreenImage(imageUrl: student?.photo ?? "");
                              },
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.withValues(alpha: .2),
                          backgroundImage: _getProfileImage(
                            student?.photo,
                            picController.profilePic,
                          ),
                          radius: 60,
                          child: picController.isLoading
                              ? CircularProgressIndicator(
                                  color: ColorConstants.primary_white,
                                )
                              : const SizedBox(),
                        ),
                      ),
                      if (login_controller.profileCompletionPercentage != "100")
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
                                Icons.camera_alt_outlined,
                                size: 17,
                                color: ColorConstants.primary_white,
                              ),
                              backgroundColor: ColorConstants.dark_red2,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text("Name",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                CustomTextField(
                  enabled: login_controller.profileCompletionPercentage == "100"
                      ? false
                      : true,
                  controller: name_controller,
                  hintText: "Enter Name",
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the name';
                    }

                    RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

                    if (!regex.hasMatch(value)) {
                      return "Please enter a valid name ";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Email Field
                Text("E-mail",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                CustomTextField(
                  enabled: login_controller.profileCompletionPercentage == "100"
                      ? false
                      : true,
                  controller: email_controller,
                  hintText: "Enter E-mail",
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email address';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Phone Field
                Text("Phone",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                CustomTextField(
                  maxLength: 10,
                  controller: phone_controller,
                  enabled: login_controller.profileCompletionPercentage == "100"
                      ? false
                      : true,
                  hintText: "Enter phone",
                  keyboardType: TextInputType.number,
                  prefix: Text("   +91 ",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the phone number';
                    }
                    RegExp regex = RegExp(r'^\+?[0-9]{10,15}$');
                    if (!regex.hasMatch(phone_controller.text)) {
                      return "Enter a valid phone number";
                    }

                    return null;
                  },
                ),
                SizedBox(height: 20),

                Text("Date Of Birth",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                CustomTextField(
                  readOnly: true,
                  enabled:
                      login_controller.profileCompletionPercentage != "100",
                  suffixIcon: Icon(Icons.calendar_month_rounded),
                  onTap: () => selectDate(context),
                  controller: dob_controller,
                  hintText: "Enter DOB",
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Select date of birth';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                Text("Blood Group",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                CustomTextField(
                  maxLength: 5,
                  controller: blood_controller,
                  enabled: login_controller.profileCompletionPercentage == "100"
                      ? false
                      : true,
                  hintText: "Enter Blood Group",
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter blood group';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 20),

                Text("Address",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                CustomTextField(
                  maxLines: 3,
                  controller: address_controller,
                  enabled: login_controller.profileCompletionPercentage == "100"
                      ? false
                      : true,
                  hintText: "Enter Address",
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Enter address'
                        : null;
                  },
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Custombutton(
                    onTap: () async {
                      log("blood group in button---${blood_controller.text}");
                      if (login_controller.profileCompletionPercentage !=
                          "100") {
                        if (formKey.currentState!.validate()) {
                          log("Blood Group After Validation: ${blood_controller.text}");
                          var phone = phone_controller.text;
                          int phoneNumber = int.parse(phone);
                          log("date of birth----${dob_controller.text}");
                          log("blood group ----${blood_controller.text}");

                          if (widget.tabController != null) {
                            await provider.addPersonalInformation(
                                name_controller.text,
                                email_controller.text,
                                phoneNumber,
                                dob_controller.text,
                                blood_controller.text,
                                address_controller.text,
                                "40",
                                widget.tabController!,
                                context);
                          }
                          context
                              .read<LoginController>()
                              .getStudentDetail(context);
                        }
                      } else {
                        widget.tabController?.animateTo(1);
                      }
                    },
                    child: provider.isLoading
                        ? CircularProgressIndicator(
                            color: ColorConstants.primary_white,
                          )
                        : Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                    text: "Next",
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: ColorConstants.dark_red),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: Colors.blue)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String formattedDate =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year.toString()}";
        dob_controller.text = formattedDate;
      });
    }
  }

  ImageProvider _getProfileImage(String? photoUrl, dynamic localPic) {
    if ((photoUrl == null || photoUrl.isEmpty) && localPic == null) {
      return const NetworkImage(
        "https://example.com/default-profile-pic.png",
      );
    }

    return localPic != null
        ? FileImage(localPic)
        : CachedNetworkImageProvider(photoUrl ?? "");
  }
}
