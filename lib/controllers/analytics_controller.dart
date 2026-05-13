import 'package:arogyamate/data/repositories/appointment_repository.dart';
import 'package:arogyamate/data/repositories/doctor_repository.dart';
import 'package:flutter/foundation.dart';

class AnalyticsController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _totalAppointments = 0;
  int _totalDoctors = 0;
  Map<String, int> _appointmentsByDepartment = {};
  Map<String, int> _appointmentsByDay = {};

  int get totalAppointments => _totalAppointments;
  int get totalDoctors => _totalDoctors;
  Map<String, int> get appointmentsByDepartment => _appointmentsByDepartment;
  Map<String, int> get appointmentsByDay => _appointmentsByDay;

  Future<void> refreshStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      final appointments = AppointmentRepository.getAll();
      final doctors = DoctorRepository.getAll();

      _totalAppointments = appointments.length;
      _totalDoctors = doctors.length;

      // Group by Department
      _appointmentsByDepartment = {};
      for (var app in appointments) {
        if (app.department != null) {
          _appointmentsByDepartment[app.department!] = 
            (_appointmentsByDepartment[app.department!] ?? 0) + 1;
        }
      }

      // Group by Day (Simplified for demo: using appointment date string)
      _appointmentsByDay = {};
      for (var app in appointments) {
        // Assuming app.date is a string like "2024-05-13"
        String day = app.date ?? 'Unknown';
        if (day.length > 10) day = day.substring(0, 10);
        _appointmentsByDay[day] = (_appointmentsByDay[day] ?? 0) + 1;
      }

    } catch (e) {
      if (kDebugMode) print("Analytics Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
