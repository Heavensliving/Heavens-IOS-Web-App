import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heavens_students/core/widgets/customSnackbar.dart';
import 'package:provider/provider.dart';
import 'package:heavens_students/controller/cart_controller.dart';
import 'package:heavens_students/core/constants/constants.dart';

class CartCard extends StatefulWidget {
  final String image;
  final String itemName;
  final String itemCount;
  final String pricePerItem;
  final String id;
  final int lowSctock;
  final int quantity;

  const CartCard({
    super.key,
    required this.image,
    required this.itemName,
    required this.itemCount,
    required this.pricePerItem,
    required this.id,
    required this.lowSctock,
    required this.quantity,
  });

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  late int value;
  late int totalPrice;

  @override
  void initState() {
    super.initState();
    value = int.parse(widget.itemCount);
    totalPrice = value * int.parse(widget.pricePerItem);
  }

  @override
  Widget build(BuildContext context) {
    final cartController = context.read<CartController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      widget.itemName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      softWrap: true,
                    ),
                    const Text(
                      "Description",
                      style: TextStyle(),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Column(
                children: [
                  SizedBox(height: 20),
                  // widget.quantity == 0
                  //     ? Text(
                  //         "Stocked Out!",
                  //         style: TextStyle(
                  //           decoration: TextDecoration.lineThrough,
                  //           decorationColor: Colors.red,
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 13,
                  //           color: Colors.red,
                  //         ),
                  //       )
                  //     : SizedBox(),
                  SizedBox(height: 10),
                  Container(
                    // padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 18, 74, 20)
                              .withOpacity(.8)),
                      color: Colors.green.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            // if (value > 0) {
                            //   setState(() {
                            //     value--;
                            //     log("value---$value");
                            //     totalPrice =
                            //         value * int.parse(widget.pricePerItem);
                            //     cartController.submitOrder(
                            //         context,
                            //         widget.itemName,
                            //         value,
                            //         widget.image,
                            //         widget.pricePerItem.toString(),
                            //         widget.id,
                            //         widget.lowSctock,
                            //         widget.quantity);
                            //   });
                            // }

                            if (value > 1) {
                              setState(() {
                                value--;
                                totalPrice =
                                    value * int.parse(widget.pricePerItem);
                                cartController.submitOrder(
                                  context,
                                  widget.itemName,
                                  value,
                                  widget.image,
                                  widget.pricePerItem.toString(),
                                  widget.id,
                                  widget.lowSctock,
                                  widget.quantity,
                                );
                              });
                            } else {
                              // Value is 1, remove the item
                              cartController.removeItem(
                                  widget.id); // Remove from the list
                              cartController.submitOrder(
                                context,
                                widget.itemName,
                                0,
                                widget.image,
                                "0",
                                widget.id,
                                widget.lowSctock,
                                widget.quantity,
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: const Text(
                              "-",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "$value",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color:
                                  ColorConstants.primary_black.withOpacity(.7)),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              log("widget.quantity--${widget.quantity}");
                              if (widget.quantity == 0) {
                                value;
                                showCustomSnackbar(context,
                                    "Oops! ${widget.itemName} is Out of Stock for Now!");
                              } else {
                                value++;
                                totalPrice =
                                    value * int.parse(widget.pricePerItem);
                                cartController.submitOrder(
                                  context,
                                  widget.itemName,
                                  value,
                                  widget.image,
                                  widget.pricePerItem.toString(),
                                  widget.id,
                                  widget.lowSctock,
                                  widget.quantity,
                                );
                              }
                            });

                            // cartController
                            //     .adjustTotal(int.parse(totalPrice.toString()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "+",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "₹ $totalPrice",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primary_black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  cartController.submitOrder(
                      context,
                      widget.itemName,
                      0,
                      widget.image,
                      "0",
                      widget.id,
                      widget.lowSctock,
                      widget.quantity);
                },
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Remove",
                    style: TextStyle(color: ColorConstants.dark_red2),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => BottomNavigation(initialIndex: 2),
                  //     ));
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Add more items",
                    style: TextStyle(color: ColorConstants.dark_red2),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
