import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/widgets/CustomButton.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';

class NoOrderscreen extends StatelessWidget {
  const NoOrderscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primary_white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset("assets/images/no order logo.png"),
          Text(
            "You haven’t made any \norders",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Text(
            "Order is empty. You can make orders from the home screen.",
            textAlign: TextAlign.center,
            style:
                TextStyle(color: ColorConstants.primary_black.withOpacity(.7)),
          ),
          SizedBox(height: 100),
          Custombutton(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigation(initialIndex: 2),
                  ));
            },
            text: "Try Ordering",
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
        ],
      ),
    );
  }
}
