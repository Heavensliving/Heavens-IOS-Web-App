// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:heavens_students/controller/cafe_controller/CafeController.dart';
// import 'package:heavens_students/controller/connectivity_controlller/connectivity_icon.dart';
// import 'package:heavens_students/controller/homepage_controller/HomepageController.dart';
// import 'package:heavens_students/controller/homepage_controller/carousal_controller.dart';
// import 'package:heavens_students/controller/login_controller/LoginController.dart';
// import 'package:heavens_students/core/constants/constants.dart';
// import 'package:heavens_students/core/constants/image_constants.dart';
// import 'package:heavens_students/core/widgets/CustomTextformField.dart';
// import 'package:heavens_students/core/widgets/customSnackbar.dart';
// import 'package:heavens_students/view/homepage/notification_page/notification.dart';
// import 'package:heavens_students/view/homepage/widgets/FinishSetupCard.dart';
// import 'package:heavens_students/view/homepage/widgets/custom_card.dart';
// import 'package:heavens_students/view/homepage/widgets/imageslider.dart';
// import 'package:provider/provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/services.dart';

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   String? roomNo;
//   late NetworkController _networkController;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//     checkNotificationPermission(context);
//   });
//     loadStudentData();
//   }

//   Future<void> checkNotificationPermission(BuildContext context) async {
//   var status = await Permission.notification.status;
//   if (!status.isGranted) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showEnableNotificationDialog(context);
//     });
//   }
// }

// void showEnableNotificationDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false, // Prevents dismissal unless action is taken
//     builder: (BuildContext dialogContext) {
//       return AlertDialog(
//         title: const Text("Enable Notifications"),
//         content: const Text(
//           "This app requires notification permissions to function properly.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(dialogContext).pop(); // Close dialog
//               exitApp(); // Exit if declined
//             },
//             child: const Text("Exit"),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.of(dialogContext).pop(); // Close dialog
//               var result = await Permission.notification.request();

//               if (result.isGranted) {
//                 debugPrint("Notification permission granted.");
//               } else if (result.isPermanentlyDenied) {
//                 // Redirect to app settings if permission is permanently denied
//                 openAppSettings();
//               } else {
//                 // If permission is denied but not permanently, request again
//                 var secondResult = await Permission.notification.request();
//                 if (secondResult.isGranted) {
//                   debugPrint("Notification permission granted on second request.");
//                 } else {
//                   // Redirect to app settings if denied again
//                   openAppSettings();
//                 }
//               }
//             },
//             child: const Text("Enable"),
//           ),
//         ],
//       );
//     },
//   );
// }

// void exitApp() {
//   if (Platform.isAndroid) {
//     SystemNavigator.pop(); // Proper way to close app on Android
//   } else if (Platform.isIOS) {
//     exit(0); // Not recommended by Apple, but works if needed
//   }
// }

//   Future<void> loadStudentData() async {
//     _networkController = NetworkController();

//     final loginController = context.read<LoginController>();

//     // Check if the widget is still mounted before proceeding
//     if (!mounted) return;

//     await loginController.getStudentDetail(context);

//     // Check for mounted again after each await
//     if (!mounted) return;

//     await context.read<CarousalImageController>().getCarousalImages();

//     if (!mounted) return;

//     context.read<HomepageController>().getRaisedTickets();

//     if (!mounted) return;

//     context.read<CafeController>().getCafeItems();

//     // Check for mounted again
//     if (!mounted) return;

//     context.read<CafeController>().getCategoryName();

//     // Check for mounted again
//     if (!mounted) return;

//     context.read<HomepageController>().getFeesDetails();
//   }

//   @override
//   void dispose() {
//     _networkController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final prov = context.watch<LoginController>().studentDetailModel?.student;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     var imageController =
//         context.watch<CarousalImageController>().carousalModels;
//     String warningMessage;
//     Color containerColor;
//     log("warning status---${prov?.warningStatus}");
//     if (prov?.warningStatus == 1) {
//       warningMessage = "First warning";
//       containerColor = Colors.yellow;
//     } else if (prov?.warningStatus == 2) {
//       warningMessage = "Second warning";
//       containerColor = Colors.orange;
//     } else {
//       warningMessage = "Blacklisted";
//       containerColor = Colors.red;
//     }
//     return Scaffold(
//       backgroundColor: Colors.grey.withOpacity(.1),
//       // appBar: AppBar(
//       //   toolbarHeight: 80,
//       //   backgroundColor: Colors.grey.withOpacity(.1),
//       //   elevation: 0,
//       //   leadingWidth: screenWidth * 0.6,
//       //   leading: Padding(
//       //     padding: const EdgeInsets.only(left: 15),
//       //     child: Consumer<LoginController>(
//       //       builder: (context, value, child) => Column(
//       //         crossAxisAlignment: CrossAxisAlignment.start,
//       //         mainAxisAlignment: MainAxisAlignment.center,
//       //         children: [
//       //           Text(
//       //             value.studentDetailModel?.student?.name ?? "Student Name",
//       //             style: TextStyle(
//       //               fontWeight: FontWeight.bold,
//       //               fontSize: screenWidth * 0.045,
//       //             ),
//       //             maxLines: 1,
//       //             overflow: TextOverflow.ellipsis,
//       //           ),
//       //           Text(
//       //             value.studentDetailModel?.student?.studentId ?? "ID",
//       //             style: TextStyle(
//       //               fontWeight: FontWeight.normal,
//       //               fontSize: screenWidth * 0.035,
//       //             ),
//       //             maxLines: 1,
//       //             overflow: TextOverflow.ellipsis,
//       //           ),
//       //           value.studentDetailModel?.student?.warningStatus != 0
//       //               ? Container(
//       //                   child: Text(
//       //                     warningMessage,
//       //                     style: TextStyle(
//       //                         fontWeight: FontWeight.bold,
//       //                         fontSize: 10,
//       //                         color: ColorConstants.primary_white),
//       //                   ),
//       //                   padding:
//       //                       EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       //                   decoration: BoxDecoration(
//       //                       color: containerColor,
//       //                       borderRadius: BorderRadius.circular(5)),
//       //                 )
//       //               : SizedBox()
//       //         ],
//       //       ),
//       //     ),
//       //   ),
//       // ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * .05,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Consumer<LoginController>(
//                     builder: (context, value, child) => Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           value.studentDetailModel?.student?.name ??
//                               "Student Name",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: screenWidth * 0.045,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Text(
//                           value.studentDetailModel?.student?.studentId ?? "ID",
//                           style: TextStyle(
//                             fontWeight: FontWeight.normal,
//                             fontSize: screenWidth * 0.035,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         value.studentDetailModel?.student?.warningStatus != 0
//                             ? Container(
//                                 child: Text(
//                                   warningMessage,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 10,
//                                       color: ColorConstants.primary_white),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 3),
//                                 decoration: BoxDecoration(
//                                     color: containerColor,
//                                     borderRadius: BorderRadius.circular(5)),
//                               )
//                             : SizedBox()
//                       ],
//                     ),
//                   ),
//                   InkWell(
//                     splashColor: Colors.transparent,
//                     onTap: () {
//                       // showCustomSnackbar(context,
//                       //     "You don't have any notifications at the moment.");
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => NotificationPage(),
//                           ));
//                     },
//                     child: Stack(
//                       children: [
//                         Icon(
//                           Icons.notifications,
//                           size: 30,
//                           // color: ColorConstants.dark_red,
//                         ),
//                         context
//                                     .watch<HomepageController>()
//                                     .notifications
//                                     .length ==
//                                 0
//                             ? SizedBox()
//                             : Positioned(
//                                 top: MediaQuery.of(context).size.height * .001,
//                                 right:
//                                     MediaQuery.of(context).size.height * .005,
//                                 child: CircleAvatar(
//                                   radius: 5,
//                                   backgroundColor: ColorConstants.dark_red,
//                                   child: Center(
//                                     child: Text(
//                                         style: TextStyle(
//                                             fontSize: MediaQuery.of(context)
//                                                     .size
//                                                     .height *
//                                                 .008,
//                                             color:
//                                                 ColorConstants.primary_white),
//                                         "${context.watch<HomepageController>().notifications.length}"),
//                                   ),
//                                 ))
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//               if (prov?.profileCompletionPercentage != "100")
//                 FinishSetupCard(
//                   percent: prov?.profileCompletionPercentage ?? "0",
//                 ),
//               SizedBox(height: 20),
//               if (imageController?[0].homeScreenImages.isNotEmpty == true)
//                 Consumer<CarousalImageController>(
//                   builder: (context, value, child) => ImageSlider(
//                     imageList: value.carousalModels![0].homeScreenImages,
//                   ),
//                 ),
//               SizedBox(height: 30),
//               buildRowCards(
//                 context,
//                 [
//                   CustomCard(
//                       onTap: () {
//                         showCustomSnackbar(context,
//                             "At this time, we are unable to accept online payments.");
//                       },
//                       image: ImageConstants.fee_payments,
//                       heading: "Fee Payments",
//                       subtitle: "Pay your fees easily."),
//                   CustomCard(
//                     onTap: () =>
//                         Navigator.pushNamed(context, "/payment_history"),
//                     image: ImageConstants.payment_history,
//                     heading: "Payment History",
//                     subtitle: "View Transactions.",
//                   )
//                 ],
//               ),
//               const SizedBox(height: 15),
//               buildRowCards(
//                 context,
//                 [
//                   CustomCard(
//                       onTap: () {
//                         if (prov?.profileCompletionPercentage != "100") {
//                           showCustomSnackbar(context,
//                               "Complete your profile for full access.");
//                         } else if (prov!.isBlocked == true) {
//                           showCustomSnackbar(
//                               context, "Complete your payment to gain entry");
//                         } else {
//                           showBottomSheet(context);
//                         }
//                       },
//                       image: ImageConstants.maintenance,
//                       heading: "Maintenance",
//                       subtitle: "Report issue easily."),
//                   CustomCard(
//                     onTap: () => Navigator.pushNamed(context, "/raised"),
//                     image: ImageConstants.raisedtickets,
//                     heading: "Raised Tickets",
//                     subtitle: "Track your requests.",
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildRowCards(BuildContext context, List<Widget> cards) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: cards.map((card) {
//         return SizedBox(
//           width: screenWidth * 0.45,
//           child: card,
//         );
//       }).toList(),
//     );
//   }

//   void showBottomSheet(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final formKey = GlobalKey<FormState>();
//     final reasonController = TextEditingController();
//     String? selectedReason;
//     final reasons = ["Electrical", "Water", "House Keeping", "Food", "Others"];

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       isScrollControlled: true,
//       builder: (context) {
//         var provider =
//             context.watch<LoginController>().studentDetailModel?.student;
//         return Padding(
//           padding: MediaQuery.of(context).viewInsets,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       "Raise a Ticket",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: screenHeight * 0.025,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   SizedBox(
//                     width: screenWidth * 0.9,
//                     child: StatefulBuilder(
//                       builder: (context, setState) {
//                         return Align(
//                           alignment: Alignment
//                               .centerRight, // Aligns the dropdown to the right
//                           child: DropdownButtonFormField<String>(
//                             isExpanded: true,
//                             decoration: InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(
//                                   color: Colors.grey.shade400,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(
//                                   color: Colors.black.withOpacity(0.5),
//                                 ),
//                               ),
//                               hintText: "Select the reason",
//                               contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 16),
//                             ),
//                             value: selectedReason,
//                             onTap: () {
//                               FocusScope.of(context).unfocus();
//                             },
//                             onChanged: (String? value) {
//                               setState(() {
//                                 selectedReason = value;
//                               });
//                             },
//                             items: reasons.map((reason) {
//                               return DropdownMenuItem<String>(
//                                 value: reason,
//                                 child: Text(reason),
//                               );
//                             }).toList(),
//                             validator: (value) =>
//                                 value == null ? 'Please select a reason' : null,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   CustomTextField(
//                     controller: reasonController,
//                     minLines: 3,
//                     maxLines: 5,
//                     hintText: "Describe the issue",
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a description';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     height: screenHeight * 0.05,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (formKey.currentState!.validate()) {
//                           context.read<HomepageController>().raiseIssue(
//                               selectedReason ?? "",
//                               reasonController.text,
//                               provider?.id ?? "",
//                               provider?.propertyId ?? "",
//                               context);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         backgroundColor: ColorConstants.dark_red2,
//                       ),
//                       child: context.watch<HomepageController>().isLoading
//                           ? CircularProgressIndicator(
//                               color: ColorConstants.dark_red,
//                             )
//                           : Text(
//                               "Submit",
//                               style: TextStyle(
//                                 fontSize: screenWidth * 0.045,
//                                 color: Colors.white,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/base_url.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:heavens_students/controller/cafe_controller/CafeController.dart';
import 'package:heavens_students/controller/connectivity_controlller/connectivity_icon.dart';
import 'package:heavens_students/controller/homepage_controller/HomepageController.dart';
import 'package:heavens_students/controller/homepage_controller/carousal_controller.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/constants/image_constants.dart';
import 'package:heavens_students/core/widgets/CustomTextformField.dart';
import 'package:heavens_students/core/widgets/customSnackbar.dart';
import 'package:heavens_students/view/homepage/notification_page/notification.dart';
import 'package:heavens_students/view/homepage/widgets/FinishSetupCard.dart';
import 'package:heavens_students/view/homepage/widgets/custom_card.dart';
import 'package:heavens_students/view/homepage/widgets/imageslider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? roomNo;
  late NetworkController _networkController;
  Color appBarColor = Colors.brown; // Default color
  Color mainContainerColor = Colors.brown; // Default color for the container
  String? mainContainerImage; // URL for the container background image
  double containerHeight = 0.27; // Default height (27% of screen height)
  String emergencyMessageText = "";
  bool emergencyMessageEnable = false; // Add this line


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkNotificationPermission(context);
    });
    loadStudentData();
    fetchAppBarColor(); // Fetch the color when the widget is initialized
  }

  // Method to fetch the app bar color from the API
   Future<void> fetchAppBarColor() async {
    try {
      final response = await http.get(Uri.parse('${UrlConst.baseUrl}/appui/'));

      // Print the response status code and body for debugging
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if the 'data' field exists and is a list
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> dataList = responseData['data'];

          // Check if the list is not empty
          if (dataList.isNotEmpty) {
            final Map<String, dynamic> firstItem = dataList[0];

            // Extract the appBarColor from the first item
            final String hexColor = firstItem['appBarColor'];

            // Extract the mainContainerColor and mainContainerImage
            final String containerHexColor = firstItem['mainContainerColor'];
            final String? containerImage = firstItem['mainContainerImage'];

            // Extract the containerHeight and convert it to a double
            final dynamic fetchedHeight = firstItem['containerHeight'];
            final double height = fetchedHeight != null
                ? double.parse(fetchedHeight.toString()) // Convert to double
                : 0.27; // Default height if not provided

            // Extract the emergencyMessageText
            final String emergencyText = firstItem['emergencyMessageText'] ?? "Your dynamic message goes here.";

            // Extract the emergencyMessageEnable
            final bool emergencyEnable = firstItem['emergencyMessageEnable'] ?? false;

            // Print the fetched values for debugging
            debugPrint('Fetched appBarColor: $hexColor');
            debugPrint('Fetched mainContainerColor: $containerHexColor');
            debugPrint('Fetched mainContainerImage: $containerImage');
            debugPrint('Fetched containerHeight: $height');
            debugPrint('Fetched emergencyMessageText: $emergencyText');
            debugPrint('Fetched emergencyMessageEnable: $emergencyEnable');

            setState(() {
              appBarColor = Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
              mainContainerColor = Color(int.parse(containerHexColor.replaceFirst('#', '0xFF')));
              mainContainerImage = containerImage;
              containerHeight = height; // Update container height
              emergencyMessageText = emergencyText; // Update emergency message
              emergencyMessageEnable = emergencyEnable; // Update emergency message enable
            });
          } else {
            debugPrint('Data list is empty');
          }
        } else {
          debugPrint('Invalid response format: "data" field is missing or not a list');
        }
      } else {
        throw Exception('Failed to load app bar color');
      }
    } catch (e) {
      debugPrint('Failed to fetch app bar color: $e');
    }
  }

  Future<void> checkNotificationPermission(BuildContext context) async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showEnableNotificationDialog(context);
      });
    }
  }

  void showEnableNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissal unless action is taken
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Enable Notifications"),
          content: const Text(
            "This app requires notification permissions to function properly.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                exitApp(); // Exit if declined
              },
              child: const Text("Exit"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog
                var result = await Permission.notification.request();

                if (result.isGranted) {
                  debugPrint("Notification permission granted.");
                } else if (result.isPermanentlyDenied) {
                  // Redirect to app settings if permission is permanently denied
                  openAppSettings();
                } else {
                  // If permission is denied but not permanently, request again
                  var secondResult = await Permission.notification.request();
                  if (secondResult.isGranted) {
                    debugPrint(
                        "Notification permission granted on second request.");
                  } else {
                    // Redirect to app settings if denied again
                    openAppSettings();
                  }
                }
              },
              child: const Text("Enable"),
            ),
          ],
        );
      },
    );
  }

  void exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop(); // Proper way to close app on Android
    } else if (Platform.isIOS) {
      exit(0); // Not recommended by Apple, but works if needed
    }
  }

  Future<void> loadStudentData() async {
    _networkController = NetworkController();

    final loginController = context.read<LoginController>();

    // Check if the widget is still mounted before proceeding
    if (!mounted) return;

    await loginController.getStudentDetail(context);

    // Check for mounted again after each await
    if (!mounted) return;

    await context.read<CarousalImageController>().getCarousalImages();

    if (!mounted) return;

    context.read<HomepageController>().getRaisedTickets();

    if (!mounted) return;

    context.read<CafeController>().getCafeItems();

    // Check for mounted again
    if (!mounted) return;

    context.read<CafeController>().getCategoryName();

    // Check for mounted again
    if (!mounted) return;

    context.read<HomepageController>().getFeesDetails();
  }

  @override
  void dispose() {
    _networkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<LoginController>().studentDetailModel?.student;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var imageController =
        context.watch<CarousalImageController>().carousalModels;
    String warningMessage;
    Color containerColor;
    log("warning status---${prov?.warningStatus}");
    if (prov?.warningStatus == 1) {
      warningMessage = "First warning";
      containerColor = Colors.yellow;
    } else if (prov?.warningStatus == 2) {
      warningMessage = "Second warning";
      containerColor = Colors.orange;
    } else {
      warningMessage = "Blacklisted";
      containerColor = Colors.red;
    }
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        toolbarHeight: 80, // Increased height of the AppBar
        backgroundColor: appBarColor, // Use the fetched color
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<LoginController>(
              builder: (context, value, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.studentDetailModel?.student?.name ?? "Student Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                      color: Colors.white, // Set text color to white
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    value.studentDetailModel?.student?.studentId ?? "ID",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.035,
                      color: Colors.white, // Set text color to white
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  value.studentDetailModel?.student?.warningStatus != 0
                      ? Container(
                          child: Text(
                            warningMessage,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: ColorConstants.primary_white),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: containerColor,
                              borderRadius: BorderRadius.circular(5)),
                        )
                      : SizedBox()
                ],
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationPage(),
                    ));
              },
              child: Stack(
                children: [
                  Icon(
                    Icons.notifications,
                    size: 30,
                    color: Colors.white, // Set icon color to white
                  ),
                  context.watch<HomepageController>().notifications.length == 0
                      ? SizedBox()
                      : Positioned(
                          top: MediaQuery.of(context).size.height * .001,
                          right: MediaQuery.of(context).size.height * .005,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: ColorConstants.dark_red,
                            child: Center(
                              child: Text(
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              .008,
                                      color: ColorConstants.primary_white),
                                  "${context.watch<HomepageController>().notifications.length}"),
                            ),
                          ))
                ],
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Move this outside of Padding so it gets full width
            Container(
              width: double.infinity, // Full width
              height: MediaQuery.of(context).size.height *
                  containerHeight, // Use fetched height
              decoration: BoxDecoration(
                color: mainContainerColor, // Background color
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                image: mainContainerImage != null
                    ? DecorationImage(
                        image: NetworkImage(
                            mainContainerImage!), // Use the fetched image
                        fit: BoxFit.cover, // Adjust the image fit
                      )
                    : null, // No image if null
              ),
            ),

            SizedBox(height: 5),
          if (emergencyMessageEnable) // Conditionally render the container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(
                        color: Colors.amber, // Left border color
                        width: 4, // Border thickness
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          emergencyMessageText, // Replace with actual dynamic text
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 22),
                      Image.network(
                        "https://cdn-icons-png.flaticon.com/512/552/552871.png",
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  if (prov?.profileCompletionPercentage != "100")
                    FinishSetupCard(
                      percent: prov?.profileCompletionPercentage ?? "0",
                    ),
                  SizedBox(height: 1),
                  if (imageController?[0].homeScreenImages.isNotEmpty == true)
                    Consumer<CarousalImageController>(
                      builder: (context, value, child) => ImageSlider(
                        imageList: value.carousalModels![0].homeScreenImages,
                      ),
                    ),
                  SizedBox(height: 30),
                  buildRowCards(
                    context,
                    [
                      CustomCard(
                          onTap: () {
                            showCustomSnackbar(context,
                                "At this time, we are unable to accept online payments.");
                          },
                          image: ImageConstants.fee_payments,
                          heading: "Fee Payments",
                          subtitle: "Pay your fees easily."),
                      CustomCard(
                        onTap: () =>
                            Navigator.pushNamed(context, "/payment_history"),
                        image: ImageConstants.payment_history,
                        heading: "Payment History",
                        subtitle: "View Transactions.",
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  buildRowCards(
                    context,
                    [
                      CustomCard(
                          onTap: () {
                            if (prov?.profileCompletionPercentage != "100") {
                              showCustomSnackbar(context,
                                  "Complete your profile for full access.");
                            } else if (prov!.isBlocked == true) {
                              showCustomSnackbar(context,
                                  "Complete your payment to gain entry");
                            } else {
                              showBottomSheet(context);
                            }
                          },
                          image: ImageConstants.maintenance,
                          heading: "Maintenance",
                          subtitle: "Report issue easily."),
                      CustomCard(
                        onTap: () => Navigator.pushNamed(context, "/raised"),
                        image: ImageConstants.raisedtickets,
                        heading: "Raised Tickets",
                        subtitle: "Track your requests.",
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRowCards(BuildContext context, List<Widget> cards) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: cards.map((card) {
        return SizedBox(
          width: screenWidth * 0.45,
          child: card,
        );
      }).toList(),
    );
  }

  void showBottomSheet(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final formKey = GlobalKey<FormState>();
    final reasonController = TextEditingController();
    String? selectedReason;
    final reasons = ["Electrical", "Water", "House Keeping", "Food", "Others"];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, // Moved to correct position
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        var provider =
            context.watch<LoginController>().studentDetailModel?.student;
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Raise a Ticket",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.025,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Align(
                          alignment: Alignment
                              .centerRight, // Aligns the dropdown to the right
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                              hintText: "Select the reason",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                            ),
                            value: selectedReason,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (String? value) {
                              setState(() {
                                selectedReason = value;
                              });
                            },
                            items: reasons.map((reason) {
                              return DropdownMenuItem<String>(
                                value: reason,
                                child: Text(reason),
                              );
                            }).toList(),
                            validator: (value) =>
                                value == null ? 'Please select a reason' : null,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: reasonController,
                    minLines: 3,
                    maxLines: 5,
                    hintText: "Describe the issue",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.05,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<HomepageController>().raiseIssue(
                              selectedReason ?? "",
                              reasonController.text,
                              provider?.id ?? "",
                              provider?.propertyId ?? "",
                              context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: ColorConstants.dark_red2,
                      ),
                      child: context.watch<HomepageController>().isLoading
                          ? CircularProgressIndicator(
                              color: ColorConstants.dark_red,
                            )
                          : Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
