import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/controller/profile_controller/ProfileController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/widgets/CustomButton.dart';
import 'package:heavens_students/core/widgets/CustomTextformField.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';
import 'package:provider/provider.dart';

class GeneralInformation extends StatefulWidget {
  final TabController tabController;
  const GeneralInformation({super.key, required this.tabController});

  @override
  State<GeneralInformation> createState() => _GeneralInformationState();
}

class _GeneralInformationState extends State<GeneralInformation> {
  TextEditingController clgName_controller = TextEditingController();
  TextEditingController course_controller = TextEditingController();
  TextEditingController year_controller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  init() async {
    var provider = context.watch<LoginController>();

    var prov = provider.studentDetailModel?.student;

    // Check if the values are already set, otherwise set them once
    if (clgName_controller.text.isEmpty) {
      clgName_controller.text = prov?.collegeName ?? "";
    }
    if (course_controller.text.isEmpty) {
      course_controller.text = prov?.course ?? "";
    }
    if (year_controller.text.isEmpty) {
      year_controller.text = prov?.year ?? "";
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init();
  }

  @override
  Widget build(BuildContext context) {
    // var prov = context.read<LoginController>().studentDetailModel?.student;
    var provider = context.watch<ProfileController>();
    final frontImageSize =
        provider.frontImage?.lengthSync() ?? 0; // Size in bytes
    final backImageSize =
        provider.backImage?.lengthSync() ?? 0; // Size in bytes
    log("back image sized---$backImageSize");
    log("front image sized---$frontImageSize");
    // Check if images are less than or equal to 400 KB
    const maxSizeInBytes = 400 * 1024;
    var login_controller =
        context.watch<LoginController>().studentDetailModel?.student;
    log("login_controller?.adharBackImage---${login_controller?.adharFrontImage}");
    log(" profileController.backImage---${provider.frontImage}");
    return Form(
      key: formkey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "College Name / Company Name",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  CustomTextField(
                      enabled:
                          login_controller!.profileCompletionPercentage == "100"
                              ? false
                              : true,
                      validator: (String? value) {
                        return (value == null || value.isEmpty)
                            ? 'Enter college/company name'
                            : null;
                      },
                      controller: clgName_controller,
                      hintText: "Enter college/company name"),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Course / Designation",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  CustomTextField(
                      enabled:
                          login_controller.profileCompletionPercentage == "100"
                              ? false
                              : true,
                      validator: (String? value) {
                        return (value == null || value.isEmpty)
                            ? 'Enter course/designation'
                            : null;
                      },
                      controller: course_controller,
                      hintText: "Enter Course/Designation"),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Year Of Study / Working",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  CustomTextField(
                      maxLength: 2,
                      enabled:
                          login_controller.profileCompletionPercentage == "100"
                              ? false
                              : true,
                      controller: year_controller,
                      keyboardType: TextInputType.number,
                      hintText: "Enter year",
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the year';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Aadhar Card",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Maximum File Size:400 KB",
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Consumer<ProfileController>(
                    builder: (context, provider, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                if (login_controller.adharFrontImage == "") {
                                  provider.showOptions(context, true);
                                }
                                return;
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                height:
                                    MediaQuery.of(context).size.height * .14,
                                width: MediaQuery.of(context).size.width * .4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColorConstants.primary_black
                                        .withOpacity(.3),
                                  ),
                                ),
                                child: provider.frontImage == null &&
                                        login_controller.adharFrontImage == ""
                                    ? Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 30,
                                        color: ColorConstants.primary_black
                                            .withOpacity(.5),
                                      )
                                    : login_controller.adharFrontImage != ""
                                        ? Image.network(
                                            login_controller.adharFrontImage!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            provider.frontImage!,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                            Text(
                              "Front page",
                              style: TextStyle(
                                  color: ColorConstants.primary_black
                                      .withOpacity(.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                if (login_controller.adharBackImage == "") {
                                  provider.showOptions(context, false);
                                }

                                return;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                height:
                                    MediaQuery.of(context).size.height * .14,
                                width: MediaQuery.of(context).size.width * .4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColorConstants.primary_black
                                        .withOpacity(.3),
                                  ),
                                ),
                                child: provider.backImage == null &&
                                        login_controller.adharBackImage == ""
                                    ? Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 30,
                                        color: ColorConstants.primary_black
                                            .withOpacity(.5),
                                      )
                                    : login_controller.adharBackImage != ""
                                        ? Image.network(
                                            login_controller.adharBackImage!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            provider.backImage!,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                            Text(
                              "Back page",
                              style: TextStyle(
                                  color: ColorConstants.primary_black
                                      .withOpacity(.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .13,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Custombutton(
                  child: provider.isLoading
                      ? CircularProgressIndicator(
                          color: ColorConstants.primary_white,
                        )
                      : Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                  onTap: () async {
                    if (login_controller.profileCompletionPercentage == "100") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BottomNavigation(initialIndex: 4),
                        ),
                      );
                    } else {
                      if (formkey.currentState!.validate()) {
                        log("back image sized---$backImageSize");
                        log("front image sized---$frontImageSize");

                        if (provider.frontImage == null &&
                            login_controller.adharFrontImage == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 188, 50, 48),
                              content: Text(
                                "Please upload the front page image",
                                style: TextStyle(
                                  color: ColorConstants.primary_white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        } else if (provider.backImage == null &&
                            login_controller.adharBackImage == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 188, 50, 48),
                              content: Text(
                                "Please upload the back page image",
                                style: TextStyle(
                                  color: ColorConstants.primary_white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        } else if (frontImageSize > maxSizeInBytes) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 188, 50, 48),
                              content: Text(
                                "Front image size must be less than or equal to 400 KB.",
                                style: TextStyle(
                                  color: ColorConstants.primary_white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        } else if (backImageSize > maxSizeInBytes) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 188, 50, 48),
                              content: Text(
                                "Back image size must be less than or equal to 400 KB.",
                                style: TextStyle(
                                  color: ColorConstants.primary_white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        } else {
                          var phone = year_controller.text;
                          int year = int.parse(phone);
                          await provider.addGeneralDetails(
                            clgName_controller.text,
                            course_controller.text,
                            year,
                            "100",
                            context,
                            provider.frontImage,
                            provider.backImage,
                          );
                          context
                              .read<LoginController>()
                              .getStudentDetail(context);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor:
                                const Color.fromARGB(255, 188, 50, 48),
                            content: Text(
                              "Add Aadhar details",
                              style: TextStyle(
                                color: ColorConstants.primary_white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  text: "Submit",
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
              )

              // Padding(
              //     padding: const EdgeInsets.only(bottom: 20),
              //     child: Custombutton(
              //       child: provider.isLoading
              //           ? CircularProgressIndicator(
              //               color: ColorConstants.primary_white,
              //             )
              //           : Text(
              //               "Submit",
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 20,
              //               ),
              //             ),
              //       onTap: () async {
              //         if (login_controller.profileCompletionPercentage ==
              //             "100") {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) =>
              //                     BottomNavigation(initialIndex: 4),
              //               ));
              //         } else {
              //           if (formkey.currentState!.validate()) {
              //             if (provider.frontImage == null &&
              //                 login_controller.adharFrontImage == "") {
              //               ScaffoldMessenger.of(context).showSnackBar(
              //                 SnackBar(
              //                   backgroundColor:
              //                       const Color.fromARGB(255, 188, 50, 48),
              //                   content: Text(
              //                     "Please upload the front page image",
              //                     style: TextStyle(
              //                       color: ColorConstants.primary_white,
              //                       fontSize: 16,
              //                     ),
              //                   ),
              //                 ),
              //               );
              //             } else if (provider.backImage == null &&
              //                 login_controller.adharBackImage == "") {
              //               ScaffoldMessenger.of(context).showSnackBar(
              //                 SnackBar(
              //                   backgroundColor:
              //                       const Color.fromARGB(255, 188, 50, 48),
              //                   content: Text(
              //                     "Please upload the back page image",
              //                     style: TextStyle(
              //                       color: ColorConstants.primary_white,
              //                       fontSize: 16,
              //                     ),
              //                   ),
              //                 ),
              //               );
              //             } else {
              //               var phone = year_controller.text;
              //               int year = int.parse(phone);
              //               await provider.addGeneralDetails(
              //                   clgName_controller.text,
              //                   course_controller.text,
              //                   year,
              //                   "100",
              //                   context,
              //                   provider.frontImage,
              //                   provider.backImage);
              //               context
              //                   .read<LoginController>()
              //                   .getStudentDetail(context);

              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) =>
              //                         BottomNavigation(initialIndex: 4),
              //                   ));
              //             }
              //           } else {
              //             ScaffoldMessenger.of(context).showSnackBar(
              //               SnackBar(
              //                 backgroundColor:
              //                     const Color.fromARGB(255, 188, 50, 48),
              //                 content: Text(
              //                   "Add Aadhar details",
              //                   style: TextStyle(
              //                     color: ColorConstants.primary_white,
              //                     fontSize: 16,
              //                   ),
              //                 ),
              //               ),
              //             );
              //           }
              //         }
              //       },
              //       text: "Submit",
              //       padding: EdgeInsets.symmetric(vertical: 10),
              //     ))
            ],
          ),
        ),
      ),
    );
  }
}
