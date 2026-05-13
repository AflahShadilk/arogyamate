import 'dart:io';
import 'package:flutter/foundation.dart';

class DoctorFormController extends ChangeNotifier {
  File? _profileImage;
  File? _uploadingFile;
  String? _updateImagePath;

  // Scheduling state
  String _startTime = '';
  String _endTime = '';
  String _status = '';
  bool _isLeave = false;

  File? get profileImage => _profileImage;
  File? get uploadingFile => _uploadingFile;
  String? get updateImagePath => _updateImagePath;

  String get startTime => _startTime;
  String get endTime => _endTime;
  String get status => _status;
  bool get isLeave => _isLeave;

  void setProfileImage(File? image) {
    _profileImage = image;
    notifyListeners();
  }

  void setUploadingFile(File? file) {
    _uploadingFile = file;
    notifyListeners();
  }

  void setUpdateImagePath(String? path) {
    _updateImagePath = path;
    notifyListeners();
  }

  void setSchedule({
    String? status,
    String? startTime,
    String? endTime,
    bool? isLeave,
  }) {
    if (status != null) _status = status;
    if (startTime != null) _startTime = startTime;
    if (endTime != null) _endTime = endTime;
    if (isLeave != null) _isLeave = isLeave;
    notifyListeners();
  }

  void clearForm() {
    _profileImage = null;
    _uploadingFile = null;
    _updateImagePath = null;
    _startTime = '';
    _endTime = '';
    _status = '';
    _isLeave = false;
    notifyListeners();
  }
}
