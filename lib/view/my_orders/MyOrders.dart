import 'package:flutter/material.dart';
import 'package:heavens_students/controller/order_controller/order_controller.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/view/my_orders/widgets/OrderDetails.dart';
import 'package:heavens_students/view/my_orders/widgets/delivered_detail_card.dart';
import 'package:heavens_students/view/my_orders/widgets/no_orderscreen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    context.read<OrderController>().getOrderHistory();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primary_white,
      appBar: AppBar(
        backgroundColor: ColorConstants.primary_white,
        title: Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          indicatorColor: ColorConstants.dark_red,
          indicatorWeight: 3,
          labelColor: ColorConstants.dark_red,
          indicatorSize: TabBarIndicatorSize.tab,
          unselectedLabelColor: ColorConstants.primary_black.withOpacity(.5),
          controller: tabController,
          tabs: [
            Tab(text: "Ongoing"),
            Tab(text: "History"),
          ],
        ),
      ),
      body: context.watch<OrderController>().isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: ColorConstants.dark_red,
            ))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        Consumer<OrderController>(
                          builder: (context, provider, child) =>
                              onGoing(provider),
                        ),
                        Consumer<OrderController>(
                          builder: (context, provider, child) =>
                              history(provider),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
    );
  }

  Widget onGoing(OrderController provider) {
    return provider.pendingOrders.isEmpty
        ? NoOrderscreen()
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: provider.pendingOrders.length,
                  itemBuilder: (context, index) {
                    // Calculate the reversed index
                    var reversedIndex =
                        provider.pendingOrders.length - 1 - index;
                    var order = provider.pendingOrders[reversedIndex];
                    DateTime dateTime = order.date ?? DateTime.now();

                    String formattedDate =
                        DateFormat('MMM dd, yyyy').format(dateTime);

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetails(
                                  status: order.status ?? "",
                                  total: order.total ?? 0,
                                  date: formattedDate,
                                  orderId: order.orderId ?? "",
                                  items: order.items ?? [],
                                  paymentMethod: order.paymentMethod ?? "",
                                ),
                              ),
                            );
                          },
                          child: DeliveredDetailCard(
                            name: "Heavens Cafe",
                            orderId: order.orderId ?? "",
                            price: order.total ?? 0,
                            status: order.status ?? "",
                            date: formattedDate,
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                )
              ],
            ),
          );
  }

  Widget history(OrderController provider) {
    return provider.deliveredOrders.isEmpty
        ? NoOrderscreen()
        : SingleChildScrollView(
            child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.deliveredOrders.length,
            itemBuilder: (context, index) {
              // Calculate the reversed index
              var reversedIndex = provider.deliveredOrders.length - 1 - index;
              var order = provider.deliveredOrders[reversedIndex];
              DateTime dateTime = DateTime.parse("${order.date ?? ""}");

              String formattedDate =
                  DateFormat('MMM dd, yyyy').format(dateTime);

              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetails(
                            status: order.status ?? "",
                            total: order.total ?? 0,
                            date: formattedDate,
                            orderId: order.orderId ?? "",
                            items: order.items ?? [],
                            paymentMethod: order.paymentMethod ?? "",
                          ),
                        ),
                      );
                    },
                    child: DeliveredDetailCard(
                      name: "Heavens Cafe",
                      orderId: order.orderId ?? "",
                      price: order.total ?? 0,
                      status: order.status ?? "",
                      date: formattedDate,
                    ),
                  ),
                  Divider(),
                ],
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 10),
          ));
  }
}
