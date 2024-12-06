import 'package:flutter/material.dart';

class RaisedTicketCards extends StatelessWidget {
  final String ticketId;
  final String issue;
  final String status;
  final String? assigned;
  const RaisedTicketCards(
      {super.key,
      required this.ticketId,
      required this.issue,
      required this.status,
      this.assigned});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ticket ID: " + "$ticketId",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              "Issue: " + "$issue",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
            ),
            SizedBox(height: 8),
            Text(
              "Status: " +
                  (assigned == null && status == "pending"
                      ? "Pending"
                      : (status == "resolved" && assigned != null
                          ? "Resolved"
                          : "Ongoing")),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: (assigned == null && status == "pending"
                    ? Colors.red
                    : (status == "resolved" && assigned != null
                        ? Colors.green
                        : Colors.amber)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
