
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/model/OrderHistoryModel.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  final String paymentMethod;
  final List<Item> items;
  final String date;
  final int total;
  final String orderId;
  final String status;
  const OrderDetails(
      {super.key,
      required this.paymentMethod,
      required this.items,
      required this.date,
      required this.total,
      required this.orderId,
      required this.status});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState() {}
  final List<IconData> icons = [
    Icons.shopping_bag_outlined,
    Icons.local_shipping_outlined,
    Icons.assignment_turned_in_outlined,
    Icons.check_circle_outline,
    Icons.receipt_long_outlined,
    Icons.shopping_cart_outlined
    // Add more icons as needed
  ];
  @override
  Widget build(BuildContext context) {
    TextEditingController rate_controller = TextEditingController();
    var provider = context.watch<LoginController>().studentDetailModel?.student;
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text(
          "Order details",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CheckoutStatusCard(index: 3),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.items.length,
                    // itemBuilder: (context, index) => DeliveredDetailCard(
                    //   name: widget.items[index].itemName ?? "",
                    //   price: widget.total,
                    //   orderId: widget.orderId,
                    //   status: widget.status,
                    //   date: widget.date,
                    // ),
                    itemBuilder: (context, index) {
                      var status = widget.status;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.items[index].itemName ?? "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      Text(
                                        "Quantity: " +
                                            " ${widget.items[index].quantity}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: ColorConstants.primary_black
                                                .withOpacity(.5)),
                                      ),
                                      Text(
                                        "Rate per item:" +
                                            " ₹ ${widget.items[index].rate}*",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: ColorConstants.primary_black
                                                .withOpacity(.5)),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                "₹ ${widget.items[index].total}",
                                style: TextStyle(
                                  color: ColorConstants.primary_black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Deliver To",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.2),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider?.name ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: ColorConstants.dark_red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            // Expanded(
                            //   child: Text(
                            //       textAlign: TextAlign.left,
                            //       style: TextStyle(
                            //           color: ColorConstants.primary_black
                            //               .withOpacity(.5)),
                            //       provider?.address ?? ""),
                            // ),

                            Expanded(
                              child: Text(
                                [
                                  if (provider?.address != null &&
                                      provider!.address!.isNotEmpty)
                                    provider.address,
                                  if (provider?.roomNo != null &&
                                      provider!.roomNo!.isNotEmpty)
                                    "Room No: ${provider.roomNo}",
                                  if (provider?.pgName != null &&
                                      provider!.pgName!.isNotEmpty)
                                    "Property: ${provider.pgName}",
                                ].join(",\n"),
                                style: TextStyle(
                                  color: ColorConstants.primary_black
                                      .withOpacity(.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: ColorConstants.dark_red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                style: TextStyle(
                                    color: ColorConstants.primary_black
                                        .withOpacity(.5)),
                                "6788787890989"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // CartTotal(),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Payment Method",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You Selected",
                          style: TextStyle(
                              color:
                                  ColorConstants.primary_black.withOpacity(.5)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              widget.paymentMethod,
                              style: TextStyle(
                                  color: ColorConstants.primary_black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              // Custombutton(
              //   text: "Submit",
              //   padding: EdgeInsets.symmetric(vertical: 10),
              // ),
              // SizedBox(
              //   height: 100,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
