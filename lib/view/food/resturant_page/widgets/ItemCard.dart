import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _isExpanded = false;
  bool add = false;
  int value = 1;

  @override
  Widget build(BuildContext context) {
    String description =
        "description vhgxhdhfhjhhhdyufyfttttttttttttttttttttttttttttttt";

    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Pizza",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          fontFamily: "Poppins",
                        ),
                      ),
                      Text(
                        "₹ 349",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: ColorConstants.dark_red2,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "4.5",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                                color: ColorConstants.dark_red2),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.green,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Bestseller",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      height: 130,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6etN5PN9mt1mEev4ysisVMx6SMZ6tdrT5CA&s"),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isExpanded
                        ? description
                        : description.substring(0, 40) + '...',
                    maxLines: _isExpanded ? null : 1,
                    overflow: _isExpanded ? null : TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: ColorConstants.primary_black.withOpacity(.5),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(_isExpanded ? "Less" : "More",
                        style: TextStyle(
                            color: ColorConstants.primary_black.withOpacity(.8),
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(),
            )
          ],
        ),
        add == false
            ? Positioned(
                bottom: 60,
                right: 30,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (add == true) {
                        add = false;
                      } else {
                        add = true;
                      }
                    });
                  },
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 23, vertical: 5),
                      decoration: BoxDecoration(
                        color: ColorConstants.primary_white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "ADD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: ColorConstants.dark_red2,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Positioned(
                bottom: 60,
                right: 20,
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: ColorConstants.primary_white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              value--;
                            });
                          },
                          child: Text(
                            "-",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: ColorConstants.dark_red2,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "$value",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: ColorConstants.dark_red2,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              value++;
                            });
                          },
                          child: Text(
                            "+",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: ColorConstants.dark_red2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
