import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';

class CustomCard extends StatefulWidget {
  final String image;
  final String heading;
  final String subtitle;
  final Function()? onTap;

  const CustomCard(
      {super.key,
      required this.image,
      required this.heading,
      required this.subtitle,
      this.onTap});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 170,
        width: 180,
        decoration: BoxDecoration(
          color: ColorConstants.primary_white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.heading,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                widget.subtitle,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: ColorConstants.primary_black.withOpacity(.5)),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    child: Image.asset(widget.image),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
