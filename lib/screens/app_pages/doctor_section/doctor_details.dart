import 'dart:io';
import 'package:arogyamate/controllers/appointment_controller.dart';
import 'package:provider/provider.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/edit_doctor.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/pdfviewer.dart';
import 'package:arogyamate/utilities/app_essencials/app_Bar.dart';
import 'package:arogyamate/utilities/constant/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DoctorView extends StatefulWidget {
  final DoctorModel? doctor;
  final AppointModel? patient;

  const DoctorView({super.key, this.doctor, this.patient});

  @override
  State<DoctorView> createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> {
  String? pdfPath;
  @override
  void initState() {
    super.initState();
    if (kDebugMode) print("DEBUG: DoctorView initState for ${widget.doctor?.name ?? 'Unknown'}");
    // Safely assign pdfPath if doctor exists
    pdfPath = widget.doctor?.newFilePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appBar(context, 'Doctor Profile'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isPhone = constraints.maxWidth < 600;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDoctorImageCard(isPhone),
                  const SizedBox(height: 24),
                  _buildDoctorInfoCard(),
                  const SizedBox(height: 24),
                  _buildAppointmentsCard(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorImageCard(bool isPhone) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: isPhone ? MediaQuery.of(context).size.height * 0.25 : MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: (widget.doctor?.imagePath?.isNotEmpty ?? false)
                    ? DecorationImage(
                        image: kIsWeb
                            ? NetworkImage(widget.doctor!.imagePath!) as ImageProvider
                            : FileImage(File(widget.doctor!.imagePath!)),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) =>
                            const AssetImage('assets/placeholder.png'),
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/placeholder.png'),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDoctor(doctor: widget.doctor),
                  ),
                );
              },
              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimary),
              style: IconButton.styleFrom(
                // ignore: deprecated_member_use
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.doctor?.name ?? 'Unknown',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoTile(Icons.person, 'Age', widget.doctor?.age),
            _buildInfoTile(
                Icons.school, 'Qualification', widget.doctor?.qualification),
            _buildInfoTile(
                Icons.local_hospital, 'Department', widget.doctor?.department),
            _buildInfoTile(Icons.work, 'Experience', widget.doctor?.years),
            _buildInfoTile(Icons.attach_money, 'Fees', widget.doctor?.fees),
            _buildInfoTile(
                Icons.health_and_safety, 'Status', widget.doctor?.status),
            SizedBox(
              width: isPhone(context) ? MediaQuery.of(context).size.width * 0.22: MediaQuery.of(context).size.width * 0.25,
              height: isPhone(context) ? MediaQuery.of(context).size.height * 0.07 : MediaQuery.of(context).size.height * 0.1,
              child: GestureDetector(
                onTap: () {
                  if (pdfPath != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PdfViewer(filePath: pdfPath!),
                    ));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.file_copy_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Appointments',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Consumer<AppointmentController>(
                builder: (context, ctrl, child) {
                  final appointsUnder = ctrl.appointments.where((a) => a.doctorName == widget.doctor?.name).toList();
                  if (appointsUnder.isEmpty) {
                    return const Center(
                        child: Text('No appointments available'));
                  }
                  return ListView.builder(
                    itemCount: appointsUnder.length,
                    itemBuilder: (context, index) {
                      final appointment = appointsUnder[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            appointment.name ?? 'Unknown',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              _buildAppointmentInfo(
                                  Icons.person, 'Age:', appointment.age),
                              _buildAppointmentInfo(Icons.location_on, 'Place:',
                                  appointment.address),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String? value) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value ?? 'N/A'),
      dense: true,
    );
  }

  Widget _buildAppointmentInfo(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }
}
