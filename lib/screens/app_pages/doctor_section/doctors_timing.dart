import 'dart:io';
import 'package:arogyamate/data_base/functions/db_doctorfuctions.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/utilities/Field_item/field_headings.dart';
import 'package:arogyamate/utilities/app_essencials/app_Bar.dart';
import 'package:arogyamate/utilities/constant/constants.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:arogyamate/utilities/date_time/date_time.dart';
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
  String startTime = '';
  String endTime = '';
  String status = '';
  bool isLeave = false;
  TextEditingController dateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();

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
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200,
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
                    backgroundColor: Colors.green,
                    backgroundImage: widget.doctor?.imagePath != null
                        ? FileImage(File(widget.doctor!.imagePath!))
                        : null,
                    child: widget.doctor?.imagePath == null
                        ? Icon(Icons.person, color: Colors.white, size: 30)
                        : null,
                  ),
                  title: Text(
                    widget.doctor?.name ?? "Unknown Doctor",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Color(0xFF1A5CFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.school_outlined,
                        color: Color(0xFF1A5CFF),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        widget.doctor?.department ?? "No Department",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    value: status.isEmpty ? null : status,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    hint: Text("Select Shift", style: TextStyle(fontSize: 16)),
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
                      status = newValue!;

                      if (status == Constants.leave) {
                        // startTime = '0';
                        // endTime = '0';
                      } else if (status == Constants.fullday) {
                        startTime = Constants.fulldatTime[0];
                        endTime = Constants.fulldatTime[1];
                      } else if (status == Constants.halfday) {
                        startTime = Constants.halfdayTime[0];
                        endTime = Constants.halfdayTime[1];
                      } else if (status == Constants.nightshift) {
                        startTime = Constants.nightshiftTime[0];
                        endTime = Constants.nightshiftTime[1];
                      }
                      setState(() {});
                    },
                  ),
                ),
                status == Constants.leave
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                    width: isPhone
                                        ? s.width * 0.36
                                        : s.width * 0.36,
                                    child: Column(
                                      children: [
                                        HeadLine(head: 'Start Date'),
                                        DatePickerField(
                                            controller: dateController),
                                      ],
                                    )),
                                SizedBox(width: 30),
                                SizedBox(
                                    width: isPhone
                                        ? s.width * 0.36
                                        : s.width * 0.36,
                                    child: Column(
                                      children: [
                                        HeadLine(head: 'End Date'),
                                        DatePickerField(
                                            controller: enddateController),
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () async {
                                if (dateController.text.isEmpty ||
                                    enddateController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
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
                                      SnackBar(
                                          content: Text(
                                              'Start date should be earlier than End date')),
                                    );
                                    return; 
                                  }
                                }
                                await settingDoctorStatus(
                                    widget.doctor!.id!, widget.doctor!, status,
                                    date: dateController.text,
                                    endDate: enddateController.text);
                                    // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                setState(() {
                                  isLeave = true;
                                });
                                
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                              ),
                              child: Text(
                                'Confirm Leave',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isLeave) ...[
                              SizedBox(height: 15),
                              Text(
                                'Leave from ${dateController.text} to ${enddateController.text}',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ]
                          ],
                        ),
                      )
                    : status == Constants.fullday
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  // print('starting${startTime}');
                                  // print('ending${endTime}');
                                  settingDoctorStatus(
                                    widget.doctor!.id!,
                                    widget.doctor!,
                                    status,
                                    stattTime: startTime,
                                    endTime: endTime,
                                  );
                                  Navigator.pop(context);
                                  setState(() {});
                                  
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.access_time, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      "$startTime - $endTime",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : status == Constants.halfday
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      settingDoctorStatus(
                                        widget.doctor!.id!,
                                        widget.doctor!,
                                        status,
                                        stattTime: startTime,
                                        endTime: endTime,
                                      );
                                       Navigator.pop(context);
                                      setState(() {});
                                     
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.access_time, size: 20),
                                        SizedBox(width: 8), // Spacing
                                        Text(
                                          "$startTime - $endTime", // Show time range
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : status == Constants.nightshift
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          settingDoctorStatus(
                                              widget.doctor!.id!,
                                              widget.doctor!,
                                              status,
                                              stattTime: startTime,
                                              endTime: endTime);
                                          Navigator.pop(context);

                                          setState(() {});
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.access_time, size: 20),
                                            SizedBox(width: 8), // Spacing
                                            Text(
                                              "$startTime - $endTime", // Show time range
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                SizedBox(height: 20),
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
