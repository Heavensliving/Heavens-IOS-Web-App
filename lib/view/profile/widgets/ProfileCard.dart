import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';

class ProfileCards extends StatelessWidget {
  final IconData icon;
  final String data;
  final bool? lang;
  final bool? isLogout;
  final Function()? onTap;
  const ProfileCards(
      {super.key,
      required this.icon,
      required this.data,
      this.lang,
      this.onTap,
      this.isLogout});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: isLogout == true
                          ? Colors.red
                          : ColorConstants.dark_red2,
                      size: 24,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      data,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: isLogout == true
                              ? Colors.red
                              : ColorConstants.primary_black),
                    ),
                  ],
                ),
                lang == true
                    ? Container(
                        height: 30,
                        width: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Eng",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: ColorConstants.dark_red2),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: ColorConstants.dark_red2,
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorConstants.dark_red2,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                      )
                    : Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: ColorConstants.primary_black.withOpacity(.5),
                        size: 18,
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
