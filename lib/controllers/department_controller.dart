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

  List<String> get departmentNames =>
      _departments.map((d) => d.department).toList();

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

  Future<void> add(DepartmentModel model) async {
    await DepartmentRepository.add(model);
    await loadAll();
  }

  Future<bool> delete(int id, String name) async {
    final deleted = await DepartmentRepository.delete(id, name);
    if (deleted) await loadAll();
    return deleted;
  }

  void search(String query) {
    if (query.isEmpty) {
      _departments = List.from(_all);
    } else {
      _departments = DepartmentRepository.search(query);
    }
    notifyListeners();
  }

  void clearSearch() {
    _departments = List.from(_all);
    notifyListeners();
  }
}
