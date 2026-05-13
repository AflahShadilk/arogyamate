import 'dart:convert';
import 'dart:io';
import 'package:arogyamate/data/repositories/appointment_repository.dart';
import 'package:arogyamate/data/repositories/department_repository.dart';
import 'package:arogyamate/data/repositories/doctor_repository.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:arogyamate/data_base/models/department_model.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';


class BackupHelper {
  static Future<void> exportData() async {
    try {
      final doctors = DoctorRepository.getAll();
      final departments = DepartmentRepository.getAll();
      final appointments = AppointmentRepository.getAll();

      final Map<String, dynamic> backupData = {
        'version': 1,
        'timestamp': DateTime.now().toIso8601String(),
        'doctors': doctors.map((d) => {
          'name': d.name,
          'age': d.age,
          'phone': d.phone,
          'qualification': d.qualification,
          'department': d.department,
          'years': d.years,
          'fees': d.fees,
          'status': d.status,
          'imagePath': d.imagePath,
          'startTime': d.startTime,
          'endtime': d.endtime,
        }).toList(),
        'departments': departments.map((d) => {
          'department': d.department,
        }).toList(),
        'appointments': appointments.map((a) => {
          'name': a.name,
          'age': a.age,
          'phone': a.phone,
          'blood': a.blood,
          'address': a.address,
          'department': a.department,
          'doctorName': a.doctorName,
          'date': a.date,
          'time': a.time,
          'title': a.title,
        }).toList(),
      };

      final String jsonStr = jsonEncode(backupData);
      
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup',
        fileName: 'arogyamate_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(jsonStr);
      }
    } catch (e) {
      if (kDebugMode) print("Export Error: $e");
    }
  }

  static Future<bool> importData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final String content = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(content);

        // Simple validation
        if (!data.containsKey('doctors') || !data.containsKey('appointments')) {
          return false;
        }

        // Import Doctors
        for (var d in data['doctors']) {
          await DoctorRepository.add(DoctorModel(
            name: d['name'],
            age: d['age'],
            phone: d['phone'] ?? '',
            qualification: d['qualification'],
            department: d['department'],
            years: d['years'],
            fees: d['fees'],
            status: d['status'],
            imagePath: d['imagePath'],
            startTime: d['startTime'],
            endtime: d['endtime'],
          ));
        }

        // Import Departments
        for (var d in data['departments']) {
          await DepartmentRepository.add(DepartmentModel(
            department: d['department'],
          ));
        }

        // Import Appointments
        for (var a in data['appointments']) {
          await AppointmentRepository.add(AppointModel(
            name: a['name'],
            age: a['age'],
            phone: a['phone'],
            blood: a['blood'],
            address: a['address'],
            department: a['department'],
            doctorName: a['doctorName'],
            date: a['date'],
            time: a['time'],
            title: a['title'],
          ));
        }
        return true;
      }
    } catch (e) {
      if (kDebugMode) print("Import Error: $e");
    }
    return false;
  }
}
