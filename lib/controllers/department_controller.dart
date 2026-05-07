import 'package:arogyamate/data/repositories/department_repository.dart';
import 'package:arogyamate/data_base/models/department_model.dart';
import 'package:flutter/foundation.dart';

class DepartmentController extends ChangeNotifier {
  List<DepartmentModel> _departments = [];
  List<DepartmentModel> _all = [];
  bool _isLoading = false;
  String? _error;

  List<DepartmentModel> get departments => _departments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Returns department names as plain strings (useful for dropdowns).
  List<String> get departmentNames =>
      _departments.map((d) => d.department).toList();

  /// Loads all departments from the repository and notifies listeners.
  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _all = DepartmentRepository.getAll();
      _departments = List.from(_all);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new department and refreshes.
  Future<void> add(DepartmentModel model) async {
    await DepartmentRepository.add(model);
    await loadAll();
  }

  /// Attempts to delete department by [id] and [name].
  /// Returns `false` if doctors are still assigned to this department.
  Future<bool> delete(int id, String name) async {
    final deleted = await DepartmentRepository.delete(id, name);
    if (deleted) await loadAll();
    return deleted;
  }

  /// Filters the in-memory list by department name query.
  void search(String query) {
    if (query.isEmpty) {
      _departments = List.from(_all);
    } else {
      _departments = DepartmentRepository.search(query);
    }
    notifyListeners();
  }

  /// Resets search — shows all departments again.
  void clearSearch() {
    _departments = List.from(_all);
    notifyListeners();
  }
}
