import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FinishSetupCard extends StatefulWidget {
  final String? percent;
  const FinishSetupCard({super.key, this.percent});

  @override
  State<FinishSetupCard> createState() => _FinishSetupCardState();
}

class _FinishSetupCardState extends State<FinishSetupCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double inputPercent;
    try {
      inputPercent = double.parse(widget.percent ?? "10");
    } catch (e) {
      inputPercent = 10;
    }

    double result = ((inputPercent - 10) / 90).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
          color: ColorConstants.primary_white,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              CircularPercentIndicator(
                radius: 27,
                progressColor: ColorConstants.dark_red,
                lineWidth: 4,
                percent: result,
                center: Text(
                  "${inputPercent.toInt()}%",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.dark_red2),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Complete Your Profile",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    "To get the full access",
                    style: TextStyle(
                        color: ColorConstants.primary_black.withOpacity(.5),
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/personal_information");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: ColorConstants.dark_red,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    "COMPLETE PROFILE",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.primary_white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
