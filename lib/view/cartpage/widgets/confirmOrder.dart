import 'package:flutter/material.dart';
import 'package:heavens_students/controller/cart_controller.dart';
import 'package:heavens_students/controller/mess_controller/MessController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/view/bottomnavigation/bottomnavigation.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ConfirmAnimated extends StatefulWidget {
  final bool? isAddons;
  ConfirmAnimated({super.key, required this.isAddons});

  @override
  _ConfirmAnimatedState createState() => _ConfirmAnimatedState();
}

class _ConfirmAnimatedState extends State<ConfirmAnimated> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      if (widget.isAddons == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigation(initialIndex: 1),
            ));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigation(initialIndex: 3),
            ));
      }
    });
    context.read<CartController>().addOns.clear();
    context.read<MessController>().addOns.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primary_white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/animations/animated.json",
              fit: BoxFit.cover,
              reverse: false,
              repeat: false,
            ),
            SizedBox(height: 20),

            SizedBox(height: 10),
            // Custombutton(
            //   padding: EdgeInsets.symmetric(vertical: 8),
            //   text: "Go to cafe",
            //   onTap: () {

            //     Navigator.pushReplacementNamed(context, "/mylearning");
            //   },
            // ),
            // SizedBox(height: 20),
            // Custombutton(
            //   padding: EdgeInsets.symmetric(vertical: 8),
            //   onTap: () {
            //     Navigator.pushReplacementNamed(context, "/bottomnavigation");
            //   },
            //   text: "Back to home",
            // ),
          ],
        ),
      ),
    );
  }
}
