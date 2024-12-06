import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/controller/profile_controller/ProfileController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/widgets/CustomButton.dart';
import 'package:heavens_students/core/widgets/CustomTextformField.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PersonalInformationCard extends StatefulWidget {
  final TabController tabController;
  const PersonalInformationCard({super.key, required this.tabController});

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
    var provider = context.read<ProfileController>();
    var login_controller =
        context.watch<LoginController>().studentDetailModel?.student;
    log("percent in profile1---${login_controller!.profileCompletionPercentage}");
    return Scaffold(
      backgroundColor: ColorConstants.primary_white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                // Name Field
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
                  readOnly: true, // Prevent direct typing
                  enabled: login_controller.profileCompletionPercentage !=
                      "100", // Conditional enable/disable
                  suffixIcon:
                      Icon(Icons.calendar_month_rounded), // Date picker icon
                  onTap: () => selectDate(context), // Show date picker on tap
                  controller: dob_controller, // Controller for date value
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
                          await provider.addPersonalInformation(
                              name_controller.text,
                              email_controller.text,
                              phoneNumber,
                              dob_controller.text,
                              blood_controller.text,
                              address_controller.text,
                              "40",
                              widget.tabController,
                              context);
                          context
                              .read<LoginController>()
                              .getStudentDetail(context);
                        }
                      } else {
                        widget.tabController.animateTo(1);
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
}
