import 'dart:io';
import 'package:arogyamate/controllers/doctor_form_controller.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/controllers/doctor_controller.dart';
import 'package:provider/provider.dart';
import 'package:arogyamate/utilities/Field_item/field_headings.dart';
import 'package:arogyamate/utilities/app_essencials/app_Bar.dart';
import 'package:arogyamate/utilities/constant/constants.dart';
import 'package:arogyamate/utilities/date_time/date_time.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimingDoctor extends StatefulWidget {
  final DoctorModel? doctor;
  // ignore: use_super_parameters
  const TimingDoctor({Key? key, this.doctor}) : super(key: key);

  @override
  State<TimingDoctor> createState() => _TimingDoctorState();
}

class _TimingDoctorState extends State<TimingDoctor> {

  TextEditingController dateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-populate DoctorFormController with the doctor's existing timing info
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.doctor != null && mounted) {
        final doc = widget.doctor!;
        final status = doc.status ?? '';
        final startTime = doc.startTime ?? '';
        final endTime = doc.endtime ?? '';
        context.read<DoctorFormController>().setSchedule(
          status: status,
          startTime: startTime,
          endTime: endTime,
        );
        // Pre-fill leave dates if doctor is on leave
        if (doc.leaveDate != null) dateController.text = doc.leaveDate!;
        if (doc.endLeaveDate != null) enddateController.text = doc.endLeaveDate!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPhone = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: appBar(context, "Schedule"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    backgroundImage: (widget.doctor?.imagePath != null && widget.doctor!.imagePath!.isNotEmpty)
                        ? (kIsWeb 
                            ? NetworkImage(widget.doctor!.imagePath!) as ImageProvider
                            : FileImage(File(widget.doctor!.imagePath!)))
                        : null,
                    child: widget.doctor?.imagePath == null
                        ? Icon(Icons.person, color: Theme.of(context).colorScheme.primary, size: 30)
                        : null,
                  ),
                  title: Text(
                    widget.doctor?.name ?? "Unknown Doctor",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.school_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        widget.doctor?.department ?? "No Department",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<DoctorFormController>(
                    builder: (context, formCtrl, _) => DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: formCtrl.status.isEmpty ? null : formCtrl.status,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: const Text("Select Shift", style: TextStyle(fontSize: 16)),
                      items: [
                        Constants.leave,
                        Constants.fullday,
                        Constants.halfday,
                        Constants.nightshift,
                      ].map((String shift) {
                        return DropdownMenuItem<String>(
                          value: shift,
                          child: Text(shift, style: TextStyle(fontSize: 16)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        final newStatus = newValue!;
                        String newStartTime = '';
                        String newEndTime = '';

                        if (newStatus == Constants.fullday) {
                          newStartTime = Constants.fulldatTime[0];
                          newEndTime = Constants.fulldatTime[1];
                        } else if (newStatus == Constants.halfday) {
                          newStartTime = Constants.halfdayTime[0];
                          newEndTime = Constants.halfdayTime[1];
                        } else if (newStatus == Constants.nightshift) {
                          newStartTime = Constants.nightshiftTime[0];
                          newEndTime = Constants.nightshiftTime[1];
                        }
                        formCtrl.setSchedule(
                          status: newStatus,
                          startTime: newStartTime,
                          endTime: newEndTime,
                        );
                      },
                    ),
                  ),
                ),
                Consumer<DoctorFormController>(
                  builder: (context, formCtrl, _) {
                    final status = formCtrl.status;
                    final startTime = formCtrl.startTime;
                    final endTime = formCtrl.endTime;

                    if (status == Constants.leave) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: isPhone ? MediaQuery.of(context).size.width * 0.36 : MediaQuery.of(context).size.width * 0.36,
                                  child: Column(
                                    children: [
                                      HeadLine(head: 'Start Date'),
                                      DatePickerField(controller: dateController),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 30),
                                SizedBox(
                                  width: isPhone ? MediaQuery.of(context).size.width * 0.36 : MediaQuery.of(context).size.width * 0.36,
                                  child: Column(
                                    children: [
                                      HeadLine(head: 'End Date'),
                                      DatePickerField(controller: enddateController),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () async {
                                if (dateController.text.isEmpty ||
                                    enddateController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please select both start and end dates')),
                                  );
                                  return;
                                }
                                DateTime? startDate =
                                    DateTime.tryParse(dateController.text);
                                DateTime? endDate =
                                    DateTime.tryParse(enddateController.text);

                                if (startDate != null && endDate != null) {
                                  if (startDate.isAfter(endDate) ||
                                      startDate.isAtSameMomentAs(endDate)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Start date should be earlier than End date')),
                                    );
                                    return;
                                  }
                                }
                                await context.read<DoctorController>().setStatus(
                                    widget.doctor!,
                                    status: status,
                                    leaveDate: dateController.text,
                                    endLeaveDate: enddateController.text);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                              ),
                              child: Text(
                                'Confirm Leave',
                                style: GoogleFonts.poppins(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (formCtrl.isLeave) ...[
                              const SizedBox(height: 15),
                              Text(
                                'Leave from ${dateController.text} to ${enddateController.text}',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ]
                          ],
                        ),
                      );
                    } else if (status == Constants.fullday ||
                        status == Constants.halfday ||
                        status == Constants.nightshift) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<DoctorController>().setStatus(
                                    widget.doctor!,
                                    status: status,
                                    startTime: startTime,
                                    endTime: endTime,
                                  );
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.access_time, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  "$startTime - $endTime",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DoctorCardState {
  List<bool> isSelected;
  String status;
  String startTime;
  String endTime;
  bool isLeave;
  String date;
  TextEditingController dateController;

  DoctorCardState({
    required this.isSelected,
    required this.status,
    required this.startTime,
    required this.endTime,
    this.isLeave = false,
    this.date = '',
    required this.dateController,
  });
}
