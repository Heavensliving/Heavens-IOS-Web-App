// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:heavens_students/controller/cart_controller.dart';
// import 'package:heavens_students/controller/mess_controller/MessController.dart';
// import 'package:heavens_students/core/constants/constants.dart';
// import 'package:heavens_students/core/widgets/customSnackbar.dart';
// import 'package:provider/provider.dart';

// class VerticalCard extends StatefulWidget {
//   final String name;
//   final String description;
//   final String price;
//   final String image;
//   final bool isCafe;
//   final String id;
//   final int lowsctock;
//   final int quantity;

//   const VerticalCard({
//     super.key,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.image,
//     required this.isCafe,
//     required this.id,
//     required this.lowsctock,
//     required this.quantity,
//   });

//   @override
//   State<VerticalCard> createState() => _VerticalCardState();
// }

// class _VerticalCardState extends State<VerticalCard> {
//   int value = 0;
//   bool stockFinshed = false;
//   @override
//   Widget build(BuildContext context) {
//     int pricePerItem = int.parse(widget.price);
//     var messController = context.watch<MessController>();
//     var cartController = context.watch<CartController>();

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 128,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               image: DecorationImage(
//                 fit: BoxFit.contain,
//                 image: NetworkImage(widget.image),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             widget.name,
//             maxLines: 1,
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               fontSize: 18,
//             ),
//           ),
//           // Text(
//           //   widget.description,
//           //   maxLines: 1,
//           //   overflow: TextOverflow.ellipsis,
//           //   style: TextStyle(
//           //     fontWeight: FontWeight.w400,
//           //     color: ColorConstants.primary_black.withOpacity(.5),
//           //     fontSize: 15,
//           //   ),
//           // ),
//           Text(
//             "₹ ${widget.price}",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           widget.quantity == 0
//               ? SizedBox(
//                   height: 10,
//                 )
//               : widget.quantity <= widget.lowsctock
//                   ? Row(
//                       children: [
//                         Icon(
//                           Icons.verified,
//                           color: ColorConstants.dark_red,
//                           size: 13,
//                         ),
//                         SizedBox(
//                           width: 2,
//                         ),
//                         Text(
//                           "Only Few Items Left!",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: ColorConstants.dark_red,
//                             fontSize: 10,
//                           ),
//                         )
//                       ],
//                     )
//                   : SizedBox(
//                       height: 10,
//                     ),

//           SizedBox(
//             height: 5,
//           ),
//           widget.quantity == 0
//               ? Container(
//                   padding: EdgeInsets.symmetric(vertical: 8),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: ColorConstants.primary_white,
//                     border: Border.all(
//                       color: ColorConstants.primary_black.withOpacity(.2),
//                     ),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Stocked Out!",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: ColorConstants.dark_red,
//                       ),
//                     ),
//                   ),
//                 )
//               : value == 0 && widget.quantity != 0
//                   ? InkWell(
//                       onTap: () {
//                         setState(() {
//                           value = 1;
//                           if (widget.isCafe) {
//                             cartController.submitOrder(
//                                 context,
//                                 widget.name,
//                                 value,
//                                 widget.image,
//                                 widget.price,
//                                 widget.id,
//                                 widget.lowsctock,
//                                 widget.quantity);
//                             // cartController.adjustTotal(pricePerItem);
//                             log("Total of cafe for $value item(s): ₹ ${value * pricePerItem}");
//                           } else {
//                             messController.submitOrder(
//                               context,
//                               widget.name,
//                               value,
//                               widget.image,
//                             );
//                             messController.adjustTotal(pricePerItem);
//                             log("Total of mess for $value item(s): ₹ ${value * pricePerItem}");
//                           }
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: 3),
//                         decoration: BoxDecoration(
//                           color: ColorConstants.primary_white,
//                           borderRadius: BorderRadius.circular(7),
//                           border: Border.all(
//                             color: ColorConstants.primary_black.withOpacity(.2),
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "ADD",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: ColorConstants.dark_red2,
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   : Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 15, vertical: 3),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: ColorConstants.primary_black.withOpacity(.2),
//                         ),
//                         color: ColorConstants.primary_white,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8),
//                             child: InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   if (value > 0) {
//                                     value--;

//                                     if (widget.isCafe) {
//                                       cartController.submitOrder(
//                                           context,
//                                           widget.name,
//                                           value,
//                                           widget.image,
//                                           widget.price,
//                                           widget.id,
//                                           widget.lowsctock,
//                                           widget.quantity);

//                                       // cartController.adjustTotal(-pricePerItem);
//                                     } else {
//                                       messController.submitOrder(context,
//                                           widget.name, value, widget.image);

//                                       messController.adjustTotal(-pricePerItem);
//                                     }
//                                     log("Total for cafe $value item(s): ₹ ${value * pricePerItem}");
//                                   }
//                                 });
//                               },
//                               child: Text(
//                                 "-",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                   color: ColorConstants.dark_red2,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Text(
//                             "$value",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20,
//                               color: ColorConstants.dark_red2,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 8),
//                             child: InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   if (widget.isCafe) {
//                                     log("quantity---${widget.quantity}");
//                                     if (widget.quantity == 1 ||
//                                         widget.quantity == 0) {
//                                       value;
//                                       showCustomSnackbar(
//                                           context, "Out of stock");
//                                     } else {
//                                       value++;
//                                       cartController.submitOrder(
//                                           context,
//                                           widget.name,
//                                           value,
//                                           widget.image,
//                                           widget.price,
//                                           widget.id,
//                                           widget.lowsctock,
//                                           widget.quantity);
//                                       // cartController.adjustTotal(pricePerItem);
//                                     }
//                                   } else {
//                                     value++;
//                                     messController.submitOrder(context,
//                                         widget.name, value, widget.image);
//                                     messController.adjustTotal(pricePerItem);
//                                   }
//                                   log("Total for cafe $value item(s): ₹ ${value * pricePerItem}");
//                                 });
//                               },
//                               child: Text(
//                                 "+",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                   color: ColorConstants.dark_red2,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/cart_controller.dart';
import 'package:heavens_students/controller/mess_controller/MessController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/widgets/customSnackbar.dart';
import 'package:provider/provider.dart';

class VerticalCard extends StatefulWidget {
  final String name;
  final String description;
  final String price;
  final String image;
  final bool isCafe;
  final String id;
  final int lowsctock;
  final int quantity;

  const VerticalCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.isCafe,
    required this.id,
    required this.lowsctock,
    required this.quantity,
  });

  @override
  State<VerticalCard> createState() => _VerticalCardState();
}

class _VerticalCardState extends State<VerticalCard> {
  int value = 0;
  bool stockFinshed = false;

  @override
  Widget build(BuildContext context) {
    int pricePerItem = int.parse(widget.price);
    var messController = context.watch<MessController>();
    var cartController = context.watch<CartController>();

    // Get screen width for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.025, // Responsive horizontal padding
        vertical: screenWidth * 0.01, // Responsive vertical padding
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenWidth * 0.35, // Responsive height for image container
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(widget.image),
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.025), // Responsive spacing
          Text(
            widget.name,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: screenWidth * 0.045, // Responsive font size
            ),
          ),
          Text(
            "₹ ${widget.price}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.045, // Responsive font size
            ),
          ),
          SizedBox(height: screenWidth * 0.01), // Responsive spacing
          widget.quantity == 0
              ? SizedBox(height: screenWidth * 0.03)
              : widget.quantity <= widget.lowsctock
                  ? Row(
                      children: [
                        Icon(
                          Icons.verified,
                          color: ColorConstants.dark_red,
                          size: screenWidth * 0.03, // Responsive icon size
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          "Only Few Items Left!",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.dark_red,
                            fontSize:
                                screenWidth * 0.025, // Responsive font size
                          ),
                        )
                      ],
                    )
                  : SizedBox(height: screenWidth * 0.03),
          SizedBox(height: screenWidth * 0.01),
          widget.quantity == 0
              ? Container(
                  padding: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.02), // Responsive padding
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorConstants.primary_white,
                    border: Border.all(
                        color: ColorConstants.primary_black.withOpacity(.2)),
                  ),
                  child: Center(
                    child: Text(
                      "Stocked Out!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.035, // Responsive font size
                        color: ColorConstants.dark_red,
                      ),
                    ),
                  ),
                )
              : value == 0 && widget.quantity != 0
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          value = 1;
                          if (widget.isCafe) {
                            cartController.submitOrder(
                              context,
                              widget.name,
                              value,
                              widget.image,
                              widget.price,
                              widget.id,
                              widget.lowsctock,
                              widget.quantity,
                            );
                            log("Total of cafe for $value item(s): ₹ ${value * pricePerItem}");
                          } else {
                            messController.submitOrder(context, widget.name,
                                value, widget.image, widget.id, widget.price);
                            messController.adjustTotal(pricePerItem);
                            log("Total of mess for $value item(s): ₹ ${value * pricePerItem}");
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                screenWidth * 0.015), // Responsive padding
                        decoration: BoxDecoration(
                          color: ColorConstants.primary_white,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                              color:
                                  ColorConstants.primary_black.withOpacity(.2)),
                        ),
                        child: Center(
                          child: Text(
                            "ADD",
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.05, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.dark_red2,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenWidth * 0.015), // Responsive padding
                      decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                ColorConstants.primary_black.withOpacity(.2)),
                        color: ColorConstants.primary_white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    screenWidth * 0.02), // Responsive padding
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (value > 0) {
                                    value--;
                                    if (widget.isCafe) {
                                      cartController.submitOrder(
                                          context,
                                          widget.name,
                                          value,
                                          widget.image,
                                          widget.price,
                                          widget.id,
                                          widget.lowsctock,
                                          widget.quantity);
                                    } else {
                                      messController.submitOrder(
                                          context,
                                          widget.name,
                                          value,
                                          widget.image,
                                          widget.id,
                                          widget.price);
                                      messController.adjustTotal(-pricePerItem);
                                    }
                                    log("Total for cafe $value item(s): ₹ ${value * pricePerItem}");
                                  }
                                });
                              },
                              child: Text("-",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.05,
                                      color: ColorConstants.dark_red2)),
                            ),
                          ),
                          Text("$value",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.05,
                                  color: ColorConstants.dark_red2)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    screenWidth * 0.02), // Responsive padding
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (widget.isCafe) {
                                      if (widget.quantity == 1 ||
                                          widget.quantity == 0) {
                                        showCustomSnackbar(
                                            context, "Out of stock");
                                      } else {
                                        value++;
                                        cartController.submitOrder(
                                            context,
                                            widget.name,
                                            value,
                                            widget.image,
                                            widget.price,
                                            widget.id,
                                            widget.lowsctock,
                                            widget.quantity);
                                      }
                                    } else {
                                      value++;
                                      messController.submitOrder(
                                          context,
                                          widget.name,
                                          value,
                                          widget.image,
                                          widget.id,
                                          widget.price);
                                      messController.adjustTotal(pricePerItem);
                                    }
                                    log("Total for cafe $value item(s): ₹ ${value * pricePerItem}");
                                  });
                                },
                                child: Text("+",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.05,
                                        color: ColorConstants.dark_red2))),
                          )
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}
