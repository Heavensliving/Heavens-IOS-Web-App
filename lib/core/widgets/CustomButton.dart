// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:heavens_students/core/constants/constants.dart';

class Custombutton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Function()? onTap;
  final Widget? child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  const Custombutton({
    Key? key,
    required this.text,
    this.fontSize,
    this.onTap,
    this.child,
    this.padding,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          onTap: onTap,
          child: Container(
            padding: padding,
            // height: padding == null ? 50 : 0,
            // width: 200,
            decoration: BoxDecoration(
              color: color == null ? ColorConstants.dark_red2 : color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Container(
                child: child == null
                    ? Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize == null ? 20 : fontSize,
                        ),
                      )
                    : child,
              ),
            ),
          ),
        );
      },
    );
  }
}
