import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heavens_students/controller/homepage_controller/HomepageController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/view/homepage/raised_tickets/RaisedTicketCards.dart';
import 'package:provider/provider.dart';

class RaisedTickets extends StatefulWidget {
  const RaisedTickets({super.key});

  @override
  State<RaisedTickets> createState() => _RaisedTicketsState();
}

class _RaisedTicketsState extends State<RaisedTickets> {
  @override
  void initState() {
    context.read<HomepageController>().getRaisedTickets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<HomepageController>();

    log("raised tickets--${provider.raisedTicketModels}");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Raised Tickets",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: provider.nothing == true
          ? Center(
              child: Text(
                "No tickets are raised !",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: ColorConstants.primary_black.withOpacity(.5)),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return RaisedTicketCards(
                          assigned:
                              provider.raisedTicketModels?[index].assignedTo,
                          issue:
                              provider.raisedTicketModels?[index].issue ?? "",
                          status:
                              provider.raisedTicketModels?[index].status ?? "",
                          ticketId:
                              provider.raisedTicketModels?[index].ticketId ??
                                  "",
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemCount: provider.raisedTicketModels?.length ?? 0,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
