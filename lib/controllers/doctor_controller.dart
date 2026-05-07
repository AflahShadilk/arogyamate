import 'package:arogyamate/data/repositories/doctor_repository.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:flutter/foundation.dart';

class DoctorController extends ChangeNotifier {
  List<DoctorModel> _doctors = [];
  List<DoctorModel> _all = [];
  Map<String, List> _filterData = {};
  bool _isLoading = false;
  String? _error;

  List<DoctorModel> get doctors => _doctors;
  Map<String, List> get filterData => _filterData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Returns unique department names from the current list.
  List<String> get departments => _filterData['departments']?.cast<String>() ?? [];

  /// Returns unique qualification names from the current list.
  List<String> get qualifications =>
      _filterData['qualifications']?.cast<String>() ?? [];

  /// Returns unique age (years of experience) values.
  List<int> get ages => _filterData['ages']?.cast<int>() ?? [];

  /// Returns unique consultation fee values.
  List<double> get fees => _filterData['fees']?.cast<double>() ?? [];

  /// Loads all doctors and filter metadata from the repository.
  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _all = DoctorRepository.getAll();
      _doctors = List.from(_all);
      _filterData = DoctorRepository.getFilterData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new doctor and refreshes.
  Future<void> add(DoctorModel model) async {
    await DoctorRepository.add(model);
    await loadAll();
  }

  /// Deletes doctor by [id] and refreshes.
  Future<void> delete(int id) async {
    await DoctorRepository.delete(id);
    await loadAll();
  }

  /// Updates an existing doctor and refreshes.
  Future<void> update(DoctorModel model) async {
    await DoctorRepository.update(model);
    await loadAll();
  }

  /// Filters the in-memory list by name query.
  void searchByName(String query) {
    if (query.isEmpty) {
      _doctors = List.from(_all);
    } else {
      _doctors = DoctorRepository.searchByName(query);
    }
    notifyListeners();
  }

  /// Filters the in-memory list by department name query.
  void searchByDepartment(String query) {
    if (query.isEmpty) {
      _doctors = List.from(_all);
    } else {
      _doctors = DoctorRepository.searchByDepartment(query);
    }
    notifyListeners();
  }

  /// Applies multi-criteria filter on the in-memory list.
  void filterBy({
    String? department,
    String? qualification,
    int? age,
    double? fees,
  }) {
    _doctors = _all.where((d) {
      final matchDept =
          department == null || d.department == department;
      final matchQual =
          qualification == null || d.qualification == qualification;
      final matchAge = age == null ||
          (d.years != null && int.tryParse(d.years!) == age);
      final matchFees = fees == null ||
          (d.fees != null && double.tryParse(d.fees!) == fees);
      return matchDept && matchQual && matchAge && matchFees;
    }).toList();
    notifyListeners();
  }

  /// Resets all filters — shows all doctors again.
  void clearFilter() {
    _doctors = List.from(_all);
    notifyListeners();
  }

  /// Updates shift settings for a doctor.
  Future<void> setShift(
    DoctorModel model, {
    required String? status,
    required String? startTime,
    required String? endTime,
  }) async {
    await DoctorRepository.setShift(model,
        status: status, startTime: startTime, endTime: endTime);
    await loadAll();
  }

  /// Updates status (leave/active) for a doctor.
  Future<void> setStatus(
    DoctorModel model, {
    required String status,
    String? startTime,
    String? endTime,
    String? leaveDate,
    String? endLeaveDate,
  }) async {
    await DoctorRepository.setStatus(model,
        status: status,
        startTime: startTime,
        endTime: endTime,
        leaveDate: leaveDate,
        endLeaveDate: endLeaveDate);
    await loadAll();
  }

  /// Saves an attached file path on the doctor record.
  Future<void> saveFilePath(DoctorModel model, String filePath) async {
    await DoctorRepository.saveFilePath(model, filePath);
    await loadAll();
  }
}
