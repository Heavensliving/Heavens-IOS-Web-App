import 'dart:math';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/homepage_controller/HomepageController.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/controller/other_functions/generate_pdf.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  void initState() {
    context.read<HomepageController>().getFeesDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<HomepageController>();
    var student = context.watch<LoginController>().studentDetailModel?.student;
    return Scaffold(
      backgroundColor: ColorConstants.primary_white,
      appBar: AppBar(
        title: Text(
          "Payment History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: ColorConstants.primary_white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: provider.feesModel == null
            ? Center(
                child: Text(
                "No payment has been made.",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: ColorConstants.primary_black.withOpacity(.5)),
              ))
            : ListView.separated(
                itemBuilder: (context, index) {
                  String dateString =
                      "${provider.feesModel?[index].paymentDate}";
                  DateTime dateTime = DateTime.parse(dateString);
                  String formattedPaidDate =
                      DateFormat('MMM dd, yyyy').format(dateTime);
                  String formattedMonth = DateFormat('MMMM').format(dateTime);

                  return Stack(
                    children: [
                      Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    provider.feesModel?[index].transactionId ??
                                        "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "Paid",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Amount",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18)),
                                  RichText(
                                    text: TextSpan(
                                      text: "₹ ",
                                      style: TextStyle(
                                          color: ColorConstants.primary_black
                                              .withOpacity(.5),
                                          fontSize: 18),
                                      children: [
                                        TextSpan(
                                          text:
                                              "${provider.feesModel?[index].amountPaid}",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Payment Mode",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18)),
                                  Text("UPI",
                                      style: TextStyle(
                                          color: ColorConstants.primary_black
                                              .withOpacity(.5),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Due Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18)),
                                  Text(
                                      "${provider.feesModel?[index].paymentClearedMonthYear}",
                                      style: TextStyle(
                                          color: ColorConstants.primary_black
                                              .withOpacity(.5),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Paid Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18)),
                                  Text(formattedPaidDate,
                                      style: TextStyle(
                                          color: ColorConstants.primary_black
                                              .withOpacity(.5),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 30,
                        top: 20,
                        child: GestureDetector(
                          onTap: () {
                            String randomBillNo = generateRandomBillNumber();
                            String randomInvoiceid = generateRandomBillNumber();
                            generatePdf(
                                dueAmount:
                                    "${provider.feesModel?[index].totalAmountToPay ?? "0"}",
                                month: formattedMonth,
                                amountPaid: provider
                                        .feesModel?[index].amountPaid
                                        .toString() ??
                                    "",
                                transactionId:
                                    provider.feesModel?[index].transactionId ??
                                        "",
                                contactNo: student?.contactNo ?? "",
                                billNo: randomBillNo,
                                dueDate: provider.feesModel?[index]
                                        .paymentClearedMonthYear ??
                                    "",
                                name: student?.name ?? "",
                                paymentMode:
                                    provider.feesModel?[index].paymentMode ??
                                        "",
                                paidDate: formattedPaidDate,
                                propertyName: student?.pgName ?? "",
                                roomNo: student?.roomNo ?? "",
                                studentId: student?.studentId ?? "",
                                invoiceNo: randomInvoiceid);
                          },
                          child: Icon(
                            Icons.cloud_download_outlined,
                            color: ColorConstants.primary_black.withOpacity(.5),
                          ),
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                      height: 15,
                    ),
                itemCount:
                    context.read<HomepageController>().feesModel?.length ?? 0),
      ),
    );
  }

  String generateRandomBillNumber() {
    const int length = 10;

    final Random random = Random();

    String billNumber = '';
    for (int i = 0; i < length; i++) {
      if (random.nextBool()) {
        billNumber += random.nextInt(10).toString();
      } else {
        billNumber += String.fromCharCode(random.nextInt(26) + 65);
      }
    }

    return billNumber;
  }

  String generateRandomInvoiceNumber() {
    const int length = 12;

    final Random random = Random();

    String invoiceNumber = '';
    for (int i = 0; i < length; i++) {
      if (random.nextBool()) {
        invoiceNumber += random.nextInt(10).toString();
      } else {
        invoiceNumber += String.fromCharCode(random.nextInt(26) + 65); // A-Z
      }
    }
    return invoiceNumber;
  }
}
