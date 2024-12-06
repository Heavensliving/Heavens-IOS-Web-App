import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';

class LoginCard extends StatelessWidget {
  final String text;
  final String Maintext;
  final Function() onTap;
  const LoginCard(
      {super.key,
      required this.text,
      required this.Maintext,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 1,
              width: 100,
              color: ColorConstants.primary_black.withOpacity(.5),
            ),
            Text(
              "   Or Sign In With   ",
              style: TextStyle(
                  color: ColorConstants.primary_black.withOpacity(.5)),
            ),
            Container(
              height: 1,
              width: 100,
              color: ColorConstants.primary_black.withOpacity(.5),
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.facebook,
                size: 30,
                color: Colors.blue,
              ),
              Icon(
                Icons.apple,
                size: 30,
              ),
              Container(
                height: 25,
                width: 25,
                child: Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwy-BUyQwlJDyw10lslxKluofTKQ6LzQSHMdayh-O3r-zbJo1_PLkYdLI&s"),
              )
            ],
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
        // InkWell(
        //   onTap: onTap,
        //   child: RichText(
        //       text: TextSpan(
        //           text: Maintext,
        //           style: TextStyle(color: ColorConstants.primary_black),
        //           children: [
        //         TextSpan(
        //             text: text,
        //             style: TextStyle(
        //                 fontWeight: FontWeight.bold,
        //                 color: ColorConstants.green)),
        //       ])),
        // )
      ],
    );
  }
}
