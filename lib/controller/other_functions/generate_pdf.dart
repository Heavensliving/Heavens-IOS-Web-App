import 'package:flutter/services.dart'; // For loading assets
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generatePdf({
  required String transactionId,
  required String amountPaid,
  required String paymentMode,
  required String dueDate,
  required String paidDate,
  required String name,
  required String studentId,
  required String propertyName,
  required String roomNo,
  required String contactNo,
  required String billNo,
  required String invoiceNo,
  required String month,
  required String dueAmount,
}) async {
  final pdf = pw.Document();

  // Load logo image from assets
  final ByteData bytes = await rootBundle.load('assets/images/hevens_logo.png');
  final Uint8List logoImage = bytes.buffer.asUint8List();

  final amountPaidInWords = amountPaid;
  final dueAmountInWords = dueAmount;

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              // Header with logo and details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(
                    pw.MemoryImage(logoImage),
                    width: 80,
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Heavens Living',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Sannidhi Layout, Near HCL Tech Gate No:2,\n'
                        'Bande Nalla Sandra, Jigani, Bengaluru',
                        style: pw.TextStyle(fontSize: 10),
                        textAlign: pw.TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 50),

              // Academic (Next Installment Receipt) Header
              pw.Text(
                'Heavens PG Rental Payment Receipt',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 20),

              // Receipt Details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Date:', paidDate),
                      _buildDetailRow('Name:', name),
                      _buildDetailRow('Contact No.:', contactNo),
                      _buildDetailRow('Payment Mode:', paymentMode),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Bill No.:', billNo),
                      _buildDetailRow('Student Id:', studentId),
                      _buildDetailRow('Property Name:', propertyName),
                      _buildDetailRow('Room No:', roomNo),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 80),

              // Received Section
              pw.Text(
                'Received the following',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),

              // Fee Details Table
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'AMOUNT PAID',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Rs $amountPaid',
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 40),

              // Total and Due Amount

              // pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Due Amount: Rs $dueAmount ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Total Paid: Rs $amountPaid',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              // Payment Info
              pw.Text(
                'UPI Amount: $amountPaid | Transaction ID: $transactionId  ',
                style: pw.TextStyle(fontSize: 10),
              ),

              pw.Text(
                'Remarks: Outstanding Fees: Rs $dueAmount',
                style: pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 20),

              // Spacer to push signature to the bottom
              // pw.Expanded(child: pw.Container()),

              // Signature
              // pw.Row(
              //   mainAxisAlignment: pw.MainAxisAlignment.end,
              //   children: [
              //     pw.Text('Signature', style: pw.TextStyle(fontSize: 10)),
              //   ],
              // ),
            ],
          ),
        );
      },
    ),
  );

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: 'transaction_receipt.pdf',
  );
}

// Helper function to build a detail row with consistent formatting
pw.Widget _buildDetailRow(String label, String value) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      ),
      pw.SizedBox(width: 5),
      pw.Text(value, style: pw.TextStyle(fontSize: 10)),
    ],
  );
}
