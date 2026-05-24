import 'dart:io';
import 'package:provider/provider.dart';
import 'package:arogyamate/controllers/doctor_controller.dart';
import 'package:arogyamate/controllers/appointment_controller.dart';
import 'package:arogyamate/controllers/notification_controller.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/edit_doctor.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/doctors_timing.dart';
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
    pdfPath = widget.doctor?.newFilePath;
  }

  DateTime? parseAppointmentDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;
    try {
      final parts = dateStr.trim().split('-');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return null;
  }

  Future<void> _handleSetLeave(DateTime start, DateTime end) async {
    final doctor = widget.doctor;
    if (doctor == null) return;

    final startStr = "${start.day}-${start.month}-${start.year}";
    final endStr = "${end.day}-${end.month}-${end.year}";

    // 1. Check appointment conflicts
    bool hasConflict = false;
    final appoints = context.read<AppointmentController>().appointments;
    for (final app in appoints) {
      if (app.doctorName == doctor.name) {
        final appDate = parseAppointmentDate(app.date);
        if (appDate != null) {
          final startMidnight = DateTime(start.year, start.month, start.day);
          final endMidnight = DateTime(end.year, end.month, end.day);
          final appMidnight = DateTime(appDate.year, appDate.month, appDate.day);

          if ((appMidnight.isAfter(startMidnight) || appMidnight.isAtSameMomentAs(startMidnight)) &&
              (appMidnight.isBefore(endMidnight) || appMidnight.isAtSameMomentAs(endMidnight))) {
            hasConflict = true;
            break;
          }
        }
      }
    }

    if (hasConflict) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                SizedBox(width: 8),
                Text('Leave Conflict'),
              ],
            ),
            content: Text(
              'There are appointments scheduled for Dr. ${doctor.name} during the selected period ($startStr to $endStr). Do you still want to schedule this leave?',
              style: const TextStyle(fontSize: 15),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm Leave'),
              ),
            ],
          );
        },
      );

      if (confirm != true) return;
    }

    if (!mounted) return;
    final doctorCtrl = context.read<DoctorController>();
    final notificationCtrl = context.read<NotificationController>();

    // Update Status & Dates in DB
    await doctorCtrl.setStatus(
          doctor,
          status: Constants.leave,
          leaveDate: startStr,
          endLeaveDate: endStr,
        );

    // Save local notification
    await notificationCtrl.addNotification(
          title: 'Doctor On Leave',
          body: 'Dr. ${doctor.name} is on leave from $startStr to $endStr.',
          type: 'doctor_leave',
        );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Leave scheduled for Dr. ${doctor.name}'),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }

  void _showSetLeaveDialog(BuildContext context) {
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Set Leave Period',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Start Date Picker Button
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          startDate = picked;
                          if (endDate != null && endDate!.isBefore(startDate!)) {
                            endDate = null;
                          }
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red.shade400, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month, color: Colors.red.shade600),
                          const SizedBox(width: 12),
                          Text(
                            startDate == null
                                ? 'Select Start Date'
                                : '${startDate!.day}-${startDate!.month}-${startDate!.year}',
                            style: TextStyle(
                              color: startDate == null
                                  ? Colors.grey
                                  : Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // End Date Picker Button
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: startDate ?? DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          endDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade400, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month, color: Colors.blue.shade600),
                          const SizedBox(width: 12),
                          Text(
                            endDate == null
                                ? 'Select End Date'
                                : '${endDate!.day}-${endDate!.month}-${endDate!.year}',
                            style: TextStyle(
                              color: endDate == null
                                  ? Colors.grey
                                  : Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: (startDate == null || endDate == null)
                      ? null
                      : () {
                          Navigator.pop(context);
                          _handleSetLeave(startDate!, endDate!);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade800,
                    disabledBackgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Set Leave'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appBar(
        context,
        'Doctor Profile',
        showDeleteButton: widget.doctor?.id != null,
        deleteFunction: widget.doctor?.id == null
            ? null
            : () async {
                await context.read<DoctorController>().delete(widget.doctor!.id!);
              },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isTablet = constraints.maxWidth >= 600;
          return Consumer<DoctorController>(
            builder: (context, doctorCtrl, _) {
              // Find the updated doctor from state to reflect shifts, leave status, etc.
              final doctor = doctorCtrl.doctors.firstWhere(
                (d) => d.id == widget.doctor?.id,
                orElse: () => widget.doctor ?? DoctorModel(
                  name: 'Unknown',
                  age: '',
                  phone: '',
                  qualification: '',
                  department: '',
                  years: '',
                  fees: '',
                  imagePath: '',
                ),
              );

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: isTablet
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  _buildAvatarHeader(doctor),
                                  const SizedBox(height: 24),
                                  _buildActionButtons(doctor),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  _buildInfoCard(doctor),
                                  const SizedBox(height: 24),
                                  _buildAppointmentsCard(doctor),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _buildAvatarHeader(doctor),
                            const SizedBox(height: 24),
                            _buildActionButtons(doctor),
                            const SizedBox(height: 24),
                            _buildInfoCard(doctor),
                            const SizedBox(height: 24),
                            _buildAppointmentsCard(doctor),
                          ],
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAvatarHeader(DoctorModel doctor) {
    final hasLeave = doctor.status == Constants.leave;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.15),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child: (doctor.imagePath?.isNotEmpty ?? false)
                    ? (kIsWeb
                        ? Image.network(
                            doctor.imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/placeholder.png', fit: BoxFit.cover),
                          )
                        : Image.file(
                            File(doctor.imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/placeholder.png', fit: BoxFit.cover),
                          ))
                    : Image.asset('assets/placeholder.png', fit: BoxFit.cover),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDoctor(doctor: doctor),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Blue capsule name container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Text(
            doctor.name ?? 'Unknown Doctor',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        if (hasLeave && doctor.leaveDate != null) ...[
          const SizedBox(height: 8),
          Chip(
            backgroundColor: Colors.red.shade50,
            side: BorderSide(color: Colors.red.shade200),
            avatar: Icon(Icons.beach_access_rounded, size: 16, color: Colors.red.shade700),
            label: Text(
              'Leave: ${doctor.leaveDate} to ${doctor.endLeaveDate ?? ""}',
              style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ] else if (doctor.status != null && doctor.status!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Chip(
            backgroundColor: Colors.green.shade50,
            side: BorderSide(color: Colors.green.shade200),
            avatar: Icon(Icons.check_circle_outline_rounded, size: 16, color: Colors.green.shade700),
            label: Text(
              'Active (${doctor.status})',
              style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildInfoCard(DoctorModel doctor) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.local_hospital_rounded,
              iconColor: Colors.blue,
              label: 'Department',
              value: doctor.department,
            ),
            _buildDetailRow(
              icon: Icons.cake_rounded,
              iconColor: Colors.orange,
              label: 'Age',
              value: doctor.age != null ? '${doctor.age} Years' : null,
            ),
            _buildDetailRow(
              icon: Icons.school_rounded,
              iconColor: Colors.purple,
              label: 'Qualification',
              value: doctor.qualification,
            ),
            _buildDetailRow(
              icon: Icons.work_history_rounded,
              iconColor: Colors.teal,
              label: 'Experience',
              value: doctor.years != null ? '${doctor.years} Years' : null,
            ),
            _buildDetailRow(
              icon: Icons.access_time_filled_rounded,
              iconColor: Colors.indigo,
              label: 'Timing',
              value: (doctor.startTime != null && doctor.endtime != null)
                  ? '${doctor.startTime} - ${doctor.endtime}'
                  : 'Not Configured',
            ),
            _buildDetailRow(
              icon: Icons.attach_money_rounded,
              iconColor: Colors.green,
              label: 'Consultation Fees',
              value: doctor.fees != null ? '\$${doctor.fees}' : null,
            ),
            _buildDetailRow(
              icon: Icons.phone_iphone_rounded,
              iconColor: Colors.pink,
              label: 'Mobile',
              value: doctor.phone,
            ),
            _buildDetailRow(
              icon: Icons.verified_user_rounded,
              iconColor: Colors.blueAccent,
              label: 'Certificates',
              value: (doctor.newFilePath != null && doctor.newFilePath!.isNotEmpty)
                  ? 'Document Uploaded'
                  : 'No Certificate Uploaded',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value ?? 'N/A',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(DoctorModel doctor) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  if (doctor.newFilePath != null && doctor.newFilePath!.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PdfViewer(filePath: doctor.newFilePath!),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No certificate uploaded for this doctor')),
                    );
                  }
                },
                icon: const Icon(Icons.description_outlined, size: 20),
                label: const Text('Certificates'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showSetLeaveDialog(context),
                icon: const Icon(Icons.beach_access_rounded, size: 20),
                label: const Text('Set On Leave'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TimingDoctor(doctor: doctor),
              ));
            },
            icon: const Icon(Icons.access_time_rounded, size: 20),
            label: const Text('Manage Shift / Schedule'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentsCard(DoctorModel doctor) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Upcoming Appointments',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<AppointmentController>(
              builder: (context, ctrl, child) {
                final appointsUnder = ctrl.appointments
                    .where((a) => a.doctorName?.trim().toLowerCase() == doctor.name?.trim().toLowerCase())
                    .toList();

                if (appointsUnder.isEmpty) {
                  return Container(
                    height: 120,
                    alignment: Alignment.center,
                    child: Text(
                      'No appointments scheduled',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appointsUnder.length,
                  itemBuilder: (context, index) {
                    final app = appointsUnder[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app.name ?? 'Unknown Patient',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month_rounded,
                                        size: 14, color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
                                    const SizedBox(width: 4),
                                    Text(
                                      app.date ?? 'N/A',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(Icons.access_time_rounded,
                                        size: 14, color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
                                    const SizedBox(width: 4),
                                    Text(
                                      app.time ?? 'N/A',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              app.blood ?? 'N/A',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
