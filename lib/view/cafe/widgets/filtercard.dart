import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';

class FilterCard extends StatelessWidget {
  const FilterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(ColorConstants.primary_white)),
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    "Filter",
                    style: TextStyle(color: ColorConstants.primary_black),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.sort, color: ColorConstants.primary_black)
                ],
              )),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(ColorConstants.primary_white)),
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    "Exotics",
                    style: TextStyle(color: ColorConstants.primary_black),
                  ),
                ],
              )),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(ColorConstants.primary_white)),
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    "ground",
                    style: TextStyle(color: ColorConstants.primary_black),
                  ),
                ],
              )),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(ColorConstants.primary_white)),
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    "beans",
                    style: TextStyle(color: ColorConstants.primary_black),
                  ),
                ],
              )),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
