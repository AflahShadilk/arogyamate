import 'package:arogyamate/data/repositories/appointment_repository.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:flutter/foundation.dart';

class AppointmentController extends ChangeNotifier {
  List<AppointModel> _appointments = [];
  List<AppointModel> _all = [];
  bool _isLoading = false;
  String? _error;
  bool _showSearchContainer = false;

  bool get showSearchContainer => _showSearchContainer;

  void toggleSearchContainer() {
    _showSearchContainer = !_showSearchContainer;
    notifyListeners();
  }

  void setShowSearchContainer(bool value) {
    _showSearchContainer = value;
    notifyListeners();
  }

  String? selectedDepartment;
  String? selectedDoctor;
  String? selectedBlood;
  String? selectedAddress;

  List<AppointModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _all = AppointmentRepository.getAll();
      _appointments = List.from(_all);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(AppointModel model) async {
    await AppointmentRepository.add(model);
    await loadAll();
  }

  Future<void> delete(int id) async {
    await AppointmentRepository.delete(id);
    await loadAll();
  }

  Future<void> update(AppointModel model) async {
    await AppointmentRepository.update(model);
    await loadAll();
  }

  void search(String query) {
    if (query.isEmpty) {
      _appointments = List.from(_all);
    } else {
      _appointments = AppointmentRepository.search(query);
    }
    notifyListeners();
  }

  void filterBy({String? department, String? doctorName}) {
    _appointments = AppointmentRepository.filter(
      department: department,
      doctorName: doctorName,
    );
    notifyListeners();
  }

  void clearFilter() {
    _appointments = List.from(_all);
    selectedDepartment = null;
    selectedDoctor = null;
    selectedBlood = null;
    selectedAddress = null;
    notifyListeners();
  }

  void setFilterSelections({
    String? department,
    String? doctor,
    String? blood,
    String? address,
  }) {
    if (department != null) selectedDepartment = department;
    if (doctor != null) selectedDoctor = doctor;
    if (blood != null) selectedBlood = blood;
    if (address != null) selectedAddress = address;
    notifyListeners();
  }

  Map<String, List<String>> get filterData =>
      AppointmentRepository.getFilterData();

  List<AppointModel> getPatientHistory(String phone) {
    return AppointmentRepository.getHistoryByPhone(phone);
  }
}
