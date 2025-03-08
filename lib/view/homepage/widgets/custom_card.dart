import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';

class CustomCard extends StatefulWidget {
  final String image;
  final String heading;
  final String subtitle;
  final Function()? onTap;
  final double height; // Add height parameter

  const CustomCard({
    super.key,
    required this.image,
    required this.heading,
    required this.subtitle,
    this.onTap,
    this.height = 180, // Default height
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: widget.height, // Use the height parameter
        width: 180,
        decoration: BoxDecoration(
          color: ColorConstants.primary_white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: widget.height * 0.6, // Adjust image height relative to card height
                      width: 80,
                      child: Image.asset(
                        widget.image,
                        fit: BoxFit.cover,
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
}