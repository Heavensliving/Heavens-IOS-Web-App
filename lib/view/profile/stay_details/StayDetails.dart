// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:heavens_students/controller/login_controller/LoginController.dart';
// import 'package:heavens_students/core/constants/constants.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class StayDetails extends StatelessWidget {
//   const StayDetails({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var provider = context.watch<LoginController>().studentDetailModel?.student;
//     log("date---${provider?.joinDate}");
//     DateTime dateTime = DateTime.parse(provider!.joinDate!);

//     String formattedDate = DateFormat('MMM d, y').format(dateTime);
//     return Scaffold(
//       backgroundColor: ColorConstants.primary_white,
//       appBar: AppBar(
//         leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(
//               Icons.arrow_back,
//               color: ColorConstants.primary_white,
//             )),
//         title: Text(
//           "Stay Details",
//           style: TextStyle(
//               fontWeight: FontWeight.bold, color: ColorConstants.primary_white),
//         ),
//         backgroundColor: ColorConstants.dark_red,
//       ),
//       body: Center(
//         child: Card(
//           elevation: 8.0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.home, color: ColorConstants.dark_red, size: 30),
//                     SizedBox(width: 10),
//                     Text(
//                       provider.pgName ?? "",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 24,
//                         color: ColorConstants.dark_red,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),

//                 // Detail rows
//                 _buildDetailRow(
//                     Icons.business, "Stay Type: ", provider.typeOfStay ?? ""),
//                 SizedBox(height: 10),
//                 _buildDetailRow(
//                     Icons.single_bed, "Room Type: ", provider.roomType ?? ""),
//                 SizedBox(height: 10),
//                 _buildDetailRow(
//                     Icons.calendar_today, "Join Date: ", formattedDate),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(IconData icon, String title, String value) {
//     return Row(
//       children: [
//         Icon(icon, color: ColorConstants.dark_red),
//         SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             "$title $value",
//             style: TextStyle(fontSize: 18),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StayDetails extends StatelessWidget {
  const StayDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<LoginController>().studentDetailModel?.student;
    log("date---${provider?.joinDate}");
    DateTime dateTime = DateTime.parse(provider!.joinDate!);
    String formattedDate = DateFormat('MMM d, y').format(dateTime);

    return Scaffold(
      backgroundColor: ColorConstants.primary_white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Stay Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: ColorConstants.dark_red,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadowColor: ColorConstants.dark_red.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ColorConstants.dark_red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.home_work_outlined,
                          size: 40,
                          color: ColorConstants.dark_red,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        provider.pgName ?? "Your Stay",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.dark_red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Accommodation Details",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Details Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildDetailTile(
                        icon: Icons.type_specimen,
                        title: "Stay Type",
                        value: provider.typeOfStay ?? "Not specified",
                        context: context,
                      ),
                      const Divider(height: 30, thickness: 0.5),
                      _buildDetailTile(
                        icon: Icons.king_bed,
                        title: "Room Type",
                        value: provider.roomType ?? "Not specified",
                        context: context,
                      ),
                      const Divider(height: 30, thickness: 0.5),
                      _buildDetailTile(
                        icon: Icons.calendar_month,
                        title: "Join Date",
                        value: formattedDate,
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Additional Info (optional)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "For any changes to your stay details, please contact the administration.",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorConstants.dark_red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: ColorConstants.dark_red, size: 22),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
