import 'package:arogyamate/data/repositories/doctor_repository.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:flutter/foundation.dart';

class DoctorController extends ChangeNotifier {
  List<DoctorModel> _doctors = [];
  List<DoctorModel> _all = [];
  Map<String, List> _filterData = {};
  bool _isLoading = false;
  String? _error;

  String? selectedDepartment;
  String? selectedQualification;
  int? selectedAge;
  double? selectedFees;

  List<DoctorModel> get doctors => _doctors;
  Map<String, List> get filterData => _filterData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> get departments => _filterData['departments']?.cast<String>() ?? [];

  List<String> get qualifications =>
      _filterData['qualifications']?.cast<String>() ?? [];

  List<int> get ages => _filterData['ages']?.cast<int>() ?? [];

  List<double> get fees => _filterData['fees']?.cast<double>() ?? [];

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

  Future<void> add(DoctorModel model) async {
    await DoctorRepository.add(model);
    await loadAll();
  }

  Future<void> delete(int id) async {
    await DoctorRepository.delete(id);
    await loadAll();
  }

  Future<void> update(DoctorModel model) async {
    await DoctorRepository.update(model);
    await loadAll();
  }

  void searchByName(String query) {
    if (query.isEmpty) {
      _doctors = List.from(_all);
    } else {
      _doctors = DoctorRepository.searchByName(query);
    }
    notifyListeners();
  }

  void search(String query) => searchByName(query);

  void searchByDepartment(String query) {
    if (query.isEmpty) {
      _doctors = List.from(_all);
    } else {
      _doctors = DoctorRepository.searchByDepartment(query);
    }
    notifyListeners();
  }

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

  void clearFilter() {
    _doctors = List.from(_all);
    selectedDepartment = null;
    selectedQualification = null;
    selectedAge = null;
    selectedFees = null;
    notifyListeners();
  }

  void setFilterSelections({
    String? department,
    String? qualification,
    int? age,
    double? fees,
  }) {
    if (department != null) selectedDepartment = department;
    if (qualification != null) selectedQualification = qualification;
    if (age != null) selectedAge = age;
    if (fees != null) selectedFees = fees;
    notifyListeners();
  }

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

  Future<void> saveFilePath(DoctorModel model, String filePath) async {
    await DoctorRepository.saveFilePath(model, filePath);
    await loadAll();
  }
}
