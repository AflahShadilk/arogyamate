import 'package:arogyamate/data/repositories/appointment_repository.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:flutter/foundation.dart';

class AppointmentController extends ChangeNotifier {
  List<AppointModel> _appointments = [];
  List<AppointModel> _all = [];
  bool _isLoading = false;
  String? _error;

  List<AppointModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Loads all appointments from the repository and notifies listeners.
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

  /// Adds a new appointment and refreshes the list.
  Future<void> add(AppointModel model) async {
    await AppointmentRepository.add(model);
    await loadAll();
  }

  /// Deletes appointment by [id] and refreshes the list.
  Future<void> delete(int id) async {
    await AppointmentRepository.delete(id);
    await loadAll();
  }

  /// Updates an existing appointment and refreshes the list.
  Future<void> update(AppointModel model) async {
    await AppointmentRepository.update(model);
    await loadAll();
  }

  /// Filters the in-memory list by name query. Call [loadAll] to reset.
  void search(String query) {
    if (query.isEmpty) {
      _appointments = List.from(_all);
    } else {
      _appointments = AppointmentRepository.search(query);
    }
    notifyListeners();
  }

  /// Filters the in-memory list by optional department / doctor name.
  void filterBy({String? department, String? doctorName}) {
    _appointments = AppointmentRepository.filter(
      department: department,
      doctorName: doctorName,
    );
    notifyListeners();
  }

  /// Resets search/filter — shows all appointments again.
  void clearFilter() {
    _appointments = List.from(_all);
    notifyListeners();
  }

  /// Returns unique filter options (departments, doctors, blood groups).
  Map<String, List<String>> get filterData =>
      AppointmentRepository.getFilterData();
}
