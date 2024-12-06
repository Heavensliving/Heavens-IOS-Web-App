import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';
import 'package:heavens_students/view/cafe/cafe.dart';
import 'package:heavens_students/view/food/history_page/HistoryPage.dart';
import 'package:heavens_students/view/food/resturant_page/ResturantPage.dart';

class FoodBottomNavigation extends StatefulWidget {
  final int initialIndex;
  const FoodBottomNavigation({super.key, required this.initialIndex});

  @override
  State<FoodBottomNavigation> createState() => _FoodBottomNavigationState();
}

class _FoodBottomNavigationState extends State<FoodBottomNavigation> {
  @override
  void initState() {
    init();
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  init() async {
    setState(() {});
  }

  List screenlist = [
    // BottomNavigation(initialIndex: 0),
    Container(
      color: Colors.blue,
    ),
    ResturantPage(),
    Cafe(),
    HistoryPage()
  ];
  int selectedIndex = 0;
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigation(initialIndex: 0),
        ),
      );
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenlist[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorConstants.primary_white,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          // fixedColor: ColorConstants.rose,
          unselectedItemColor: Colors.grey.withOpacity(.5),
          selectedItemColor: ColorConstants.dark_red2,

          // iconSize: 10,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.arrow_circle_left),
                icon: Icon(Icons.arrow_circle_left_outlined),
                label: "Home"),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.restaurant),
                icon: Icon(Icons.restaurant_sharp),
                label: "Resturant"),
            BottomNavigationBarItem(
              label: "Cafe",
              activeIcon: Icon(
                Icons.local_cafe,
              ),
              icon: Icon(
                Icons.local_cafe_outlined,
              ),
            ),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.history_sharp),
                icon: Icon(Icons.history),
                label: "history"),
          ]),
    );
  }
}
