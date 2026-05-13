import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfHelper {
  static Future<void> generateDailySummary({
    required String hospitalName,
    required String hospitalId,
    required List<AppointModel> appointments,
    String? date,
  }) async {
    final pdf = pw.Document();

    // Group appointments for the table
    final tableHeaders = ['Time', 'Patient Name', 'Doctor', 'Department', 'Phone'];
    final tableData = appointments.map((a) => [
      a.time ?? '',
      a.name ?? '',
      a.doctorName ?? '',
      a.department ?? '',
      a.phone ?? '',
    ]).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // --- Header ---
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    hospitalName,
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text("ID: $hospitalId", style: const pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 5),
                  pw.Text("Daily Appointment Summary", style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Date: ${date ?? DateTime.now().toString().substring(0, 10)}"),
                  pw.Text("Total Patients: ${appointments.length}"),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 20),

          // --- Table ---
          pw.TableHelper.fromTextArray(
            headers: tableHeaders,
            data: tableData,
            border: pw.TableBorder.all(color: PdfColors.grey300),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerLeft,
              4: pw.Alignment.centerLeft,
            },
          ),

          // --- Footer ---
          pw.SizedBox(height: 40),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              children: [
                pw.Container(width: 150, height: 1, color: PdfColors.black),
                pw.SizedBox(height: 5),
                pw.Text("Authorized Signature", style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );

    // Save or Print
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Daily_Summary_${date ?? "today"}.pdf',
    );
  }

  static Future<void> generateIndividualReceipt({
    required String hospitalName,
    required String hospitalId,
    required AppointModel appointment,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(hospitalName, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.Text("Hospital ID: $hospitalId", style: const pw.TextStyle(fontSize: 10)),
                  pw.Divider(),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text("APPOINTMENT RECEIPT", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 15),
            _receiptRow("Patient Name", appointment.name ?? 'N/A'),
            _receiptRow("Age", appointment.age ?? 'N/A'),
            _receiptRow("Phone", appointment.phone ?? 'N/A'),
            _receiptRow("Blood Group", appointment.blood ?? 'N/A'),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 10),
            _receiptRow("Department", appointment.department ?? 'N/A'),
            _receiptRow("Consultant", appointment.doctorName ?? 'N/A'),
            _receiptRow("Date", appointment.date ?? 'N/A'),
            _receiptRow("Time", appointment.time ?? 'N/A'),
            pw.SizedBox(height: 30),
            pw.Divider(),
            pw.Center(child: pw.Text("Thank you for choosing $hospitalName", style: const pw.TextStyle(fontSize: 8))),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Receipt_${appointment.name}.pdf',
    );
  }

  static pw.Widget _receiptRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(width: 100, child: pw.Text("$label:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Text(value),
        ],
      ),
    );
  }
}
