import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';

class DeliveredDetailCard extends StatelessWidget {
  final String orderId;
  final int price;
  final String date;
  final String status;
  final String name;

  const DeliveredDetailCard(
      {super.key,
      required this.orderId,
      required this.price,
      required this.date,
      required this.status,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: ColorConstants.dark_red.withOpacity(.1),
              child: Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: ColorConstants.dark_red,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  orderId,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: ColorConstants.primary_black.withOpacity(.5)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹ ${price}",
                      style: TextStyle(
                        color: ColorConstants.primary_black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Text(
                status,
                style: TextStyle(
                    color: status == "delivered" || status == "cancelled"
                        ? const Color.fromARGB(255, 163, 31, 22)
                        : const Color.fromARGB(255, 29, 121, 32)),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: status == "delivered" || status == "cancelled"
                      ? const Color.fromARGB(255, 255, 211, 208)
                      : const Color.fromARGB(255, 132, 197, 135)
                          .withOpacity(.5)),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              date,
              style: TextStyle(
                color: ColorConstants.primary_black.withOpacity(.5),
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        )
      ],
    );
  }
}
