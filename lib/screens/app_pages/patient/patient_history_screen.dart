import 'package:arogyamate/controllers/appointment_controller.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PatientHistoryScreen extends StatelessWidget {
  final String phone;
  final String patientName;

  const PatientHistoryScreen({
    super.key,
    required this.phone,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    final history = context.read<AppointmentController>().getPatientHistory(phone);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Medical History",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 700;
          return Column(
            children: [
              // --- Patient Info Header ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                margin: EdgeInsets.symmetric(
                  horizontal: isWide ? constraints.maxWidth * 0.15 : 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(Icons.person_rounded, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patientName,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Phone: $phone",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- Timeline List ---
              Expanded(
                child: history.isEmpty
                    ? const Center(child: Text("No previous records found."))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? constraints.maxWidth * 0.15 : 20,
                        ),
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final item = history[index];
                          return _buildHistoryItem(context, item, index == history.length - 1);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, AppointModel item, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Left Side: Timeline Indicator ---
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          // --- Right Side: Record Card ---
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.date ?? "Unknown Date",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        item.time ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(context, Icons.medical_services_rounded, "Department", item.department ?? "N/A"),
                  const SizedBox(height: 6),
                  _buildDetailRow(context, Icons.person_pin_rounded, "Doctor", item.doctorName ?? "N/A"),
                  if (item.title != null && item.title!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      "Diagnosis/Note:",
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    Text(
                      item.title!,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
