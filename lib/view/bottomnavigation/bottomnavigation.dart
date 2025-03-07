// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:heavens_students/controller/login_controller/LoginController.dart';
// import 'package:heavens_students/core/constants/constants.dart';
// import 'package:heavens_students/core/widgets/customSnackbar.dart';
// import 'package:heavens_students/view/MessManager/MessManager.dart';
// import 'package:heavens_students/view/cafe/cafe.dart';
// import 'package:heavens_students/view/homepage/homepage.dart';
// import 'package:heavens_students/view/my_orders/MyOrders.dart';
// import 'package:heavens_students/view/profile/profile.dart';
// import 'package:provider/provider.dart';

// class BottomNavigation extends StatefulWidget {
//   final int initialIndex;
//   const BottomNavigation({super.key, required this.initialIndex});

//   @override
//   State<BottomNavigation> createState() => _BottomNavigationState();
// }

// class _BottomNavigationState extends State<BottomNavigation> {
//   int selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     selectedIndex = widget.initialIndex;
//   }

//   final List<Widget> allScreens = [
//     Homepage(),
//     Messmanager(),
//     Cafe(),
//     MyOrders(),
//     Profilescreen(),
//   ];

//   final List<Widget> restrictedScreens = [
//     Homepage(),
//     Profilescreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     var student = context.watch<LoginController>().studentDetailModel?.student;

//     bool isProfileComplete = student?.profileCompletionPercentage == "100";
//     bool isBlocked = student?.isBlocked == true;

//     List<Widget> screenlist =
//         isBlocked || !isProfileComplete ? restrictedScreens : allScreens;

//     if (selectedIndex >= screenlist.length) {
//       selectedIndex = 0;
//     }

//     return WillPopScope(
//       onWillPop: () async {
//         SystemNavigator.pop();
//         return false;
//       },
//       child: Scaffold(
//         body: screenlist[selectedIndex],
//         bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: ColorConstants.primary_white,
//           type: BottomNavigationBarType.fixed,
//           currentIndex: selectedIndex,
//           unselectedItemColor: Colors.grey.withOpacity(.5),
//           selectedItemColor: ColorConstants.dark_red2,
//           showUnselectedLabels: true,
//           onTap: (value) {
//             if (isBlocked && value >= restrictedScreens.length) {
//               showCustomSnackbar(
//                 context,
//                 "Complete your payment to gain entry",
//               );
//               return;
//             }
//             if (!isProfileComplete && value >= restrictedScreens.length) {
//               showCustomSnackbar(
//                 context,
//                 "Complete your profile to access all features",
//               );
//               return;
//             }

//             setState(() {
//               selectedIndex = value;
//             });

            
//           },
//           items: [
//             BottomNavigationBarItem(
//               activeIcon: Icon(Icons.home_work_rounded),
//               icon: Icon(Icons.home_work_outlined),
//               label: "PG",
//             ),
//             if (isBlocked)
//               BottomNavigationBarItem(
//                 activeIcon: Icon(Icons.lock),
//                 icon: Icon(Icons.lock_outline),
//                 label: "Access Blocked",
//               )
//             else if (!isProfileComplete)
//               BottomNavigationBarItem(
//                 activeIcon: Icon(Icons.person_off),
//                 icon: Icon(Icons.person_rounded),
//                 label: "Complete Profile",
//               )
//             else
//               BottomNavigationBarItem(
//                 label: "Mess",
//                 activeIcon: Icon(Icons.fastfood),
//                 icon: Icon(Icons.fastfood_outlined),
//               ),
//             BottomNavigationBarItem(
//               activeIcon: Icon(Icons.local_cafe),
//               icon: Icon(Icons.local_cafe_outlined),
//               label: "Cafe",
//             ),
//             BottomNavigationBarItem(
//               activeIcon: Icon(Icons.shopping_bag_rounded),
//               icon: Icon(Icons.shopping_bag_outlined),
//               label: "Orders",
//             ),
//             BottomNavigationBarItem(
//               activeIcon: Icon(Icons.person_2_rounded),
//               icon: Icon(Icons.person_2_outlined),
//               label: "Profile",
//             ),
//           ].sublist(0, screenlist.length),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/widgets/customSnackbar.dart';
import 'package:heavens_students/view/MessManager/AddOnPage/AddonPage.dart';
import 'package:heavens_students/view/MessManager/MessManager.dart';
import 'package:heavens_students/view/homepage/homepage.dart';
import 'package:heavens_students/view/profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class BottomNavigation extends StatefulWidget {
  final int initialIndex;
  const BottomNavigation({super.key, required this.initialIndex});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });

   Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
  setState(() {
    // Check if any of the results indicate a connection
    _isConnected = results.any((result) => result != ConnectivityResult.none);
  });
});
  }

  final List<Widget> allScreens = [
    Homepage(),
    Messmanager(),
    // Cafe(), // Temporarily commented out
    // MyOrders(), // Temporarily commented out
    MealSelectionPage(), // Add the new Addon option
    Profilescreen(),
  ];

  final List<Widget> restrictedScreens = [
    Homepage(),
    Profilescreen(),
  ];

  @override
  Widget build(BuildContext context) {
    var student = context.watch<LoginController>().studentDetailModel?.student;

    bool isProfileComplete = student?.profileCompletionPercentage == "100";
    bool isBlocked = student?.isBlocked == true;

    List<Widget> screenlist =
        isBlocked || !isProfileComplete ? restrictedScreens : allScreens;

    if (selectedIndex >= screenlist.length) {
      selectedIndex = 0;
    }

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: screenlist[selectedIndex],
        bottomNavigationBar: _isConnected
            ? BottomNavigationBar(
                backgroundColor: ColorConstants.primary_white,
                type: BottomNavigationBarType.fixed,
                currentIndex: selectedIndex,
                unselectedItemColor: Colors.grey.withOpacity(.5),
                selectedItemColor: ColorConstants.dark_red2,
                showUnselectedLabels: true,
                onTap: (value) {
                  if (isBlocked && value >= restrictedScreens.length) {
                    showCustomSnackbar(
                      context,
                      "Complete your payment to gain entry",
                    );
                    return;
                  }
                  if (!isProfileComplete && value >= restrictedScreens.length) {
                    showCustomSnackbar(
                      context,
                      "Complete your profile to access all features",
                    );
                    return;
                  }

                  setState(() {
                    selectedIndex = value;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    activeIcon: Icon(Icons.home_work_rounded),
                    icon: Icon(Icons.home_work_outlined),
                    label: "PG",
                  ),
                  if (isBlocked)
                    BottomNavigationBarItem(
                      activeIcon: Icon(Icons.lock),
                      icon: Icon(Icons.lock_outline),
                      label: "Access Blocked",
                    )
                  else if (!isProfileComplete)
                    BottomNavigationBarItem(
                      activeIcon: Icon(Icons.person_off),
                      icon: Icon(Icons.person_rounded),
                      label: "Complete Profile",
                    )
                  else
                    BottomNavigationBarItem(
                      label: "Mess",
                      activeIcon: Icon(Icons.fastfood),
                      icon: Icon(Icons.fastfood_outlined),
                    ),
                  // Temporarily commented out the Cafe and Orders items
                  // BottomNavigationBarItem(
                  //   activeIcon: Icon(Icons.local_cafe),
                  //   icon: Icon(Icons.local_cafe_outlined),
                  //   label: "Cafe",
                  // ),
                  // BottomNavigationBarItem(
                  //   activeIcon: Icon(Icons.shopping_bag_rounded),
                  //   icon: Icon(Icons.shopping_bag_outlined),
                  //   label: "Orders",
                  // ),
                  BottomNavigationBarItem(
                    activeIcon: Icon(Icons.restaurant_menu_outlined), // New Addon icon
                    icon: Icon(Icons.restaurant_menu_outlined),
                    label: "Addon",
                  ),
                  BottomNavigationBarItem(
                    activeIcon: Icon(Icons.person_2_rounded),
                    icon: Icon(Icons.person_2_outlined),
                    label: "Profile",
                  ),
                ].sublist(0, screenlist.length),
              )
            : null, // Hide the bottom navigation bar if there is no internet
      ),
    );
  }
}